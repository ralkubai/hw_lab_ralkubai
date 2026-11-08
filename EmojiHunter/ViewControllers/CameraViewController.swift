//
//  CameraViewController.swift
//  EmojiHunter
//
//  Full-screen camera that sends each frame to MobileNetV2 (via Vision) and
//  tells its delegate when the target object is recognised.
//

import UIKit
import AVFoundation
import Vision
import CoreML

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // MARK: - Setup VC and video settings
    weak var delegate: EmojiFoundDelegate?   // weak + AnyObject protocol = no retain cycle

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    private let videoDataOutput = AVCaptureVideoDataOutput()

    var emojiString = ""   // Label text we're hunting for, e.g. "pen"

    /// Creates the controller for one emoji hunt.
    init(emoji: String) {
        self.emojiString = emoji
        super.init(nibName: nil, bundle: nil)
    }

    /// Storyboard init isn't used in this app.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets up the camera input, the frame output, and the live preview layer, then starts the session.
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        // No camera (e.g. the simulator): show a message instead of a black screen
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showCameraUnavailableMessage()
            return
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        // Ask for frames in a pixel format Vision can read
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]

        // Drop frames we can't keep up with instead of queueing them
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)

        // Full-screen live preview
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // startRunning() blocks, so keep it off the main thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    /// Shows a centred "Camera not available" label (used in the simulator).
    private func showCameraUnavailableMessage() {
        let label = UILabel(frame: view.bounds)
        label.text = "📷 Camera not available\n(Run on a real device)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        view.addSubview(label)
    }

    /// Called by AVFoundation for every camera frame (on its own queue, hence nonisolated).
    /// Hands the frame to the classifier.
    nonisolated func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {

        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }

            // CVPixelBuffer isn't Sendable, but this frame is only used once on the main actor,
            // so it's safe to pass along without a copy.
            nonisolated(unsafe) let pixelBuffer = frame

            Task { @MainActor in
                self.updateClassifications(in: pixelBuffer)
            }
            
    }

    /// Restarts the camera when the view comes back on screen.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }

    /// Stops the camera when the view leaves the screen, to save battery.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    /// Hides the status bar for a full-screen camera.
    override var prefersStatusBarHidden: Bool {
        return true
    }

    /// Locks the camera screen to portrait.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Setup ML Model

    /// The Vision request that runs MobileNetV2 on a frame. Created once, on first use.
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            // MobileNetV2 is the class Xcode generates from MobileNetV2.mlmodel
            let model = try VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model)

            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop   // Crop to the centre square the model expects
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()

    // MARK: - Classification methods

    /// Runs the classification request on one frame, off the main thread.
    /// `.right` orientation matches a portrait phone's camera.
    func updateClassifications(in image: CVPixelBuffer) {

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .right, options: [:])
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }

    /// Reads the top prediction; if it's over 50% confident and matches the target, notifies the delegate.
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            // Safe cast (no force-unwrap) so a bad result can't crash the app
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }

            guard let top = results.first, top.confidence > 0.5 else { return }

            // Prints what the model sees in real time (visible in the Xcode console)
            print("Classification: Identifier \(top.identifier) ; Confidence \(top.confidence)")

            if top.identifier.contains(self.emojiString) {
                self.delegate?.emojiWasFound(result: true)
            }
        }
    }
}
