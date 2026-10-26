//
//  ArbeitApp.swift
//  Arbeit
//
//  App entry point; configures Firebase on launch.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    /// Called once at launch; connects the app to Firebase using GoogleService-Info.plist.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ArbeitApp: App {
    // Hooks the UIKit AppDelegate into the SwiftUI app lifecycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    /// The app's window, starting at AppView.
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
