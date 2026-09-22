import Foundation

public struct Book: Identifiable, Comparable {

    //to conform to identifiable protocol
    public var id = UUID()

    var title: String
    var author: String
    var gender: String
    var displayed: Bool

    //init method
    init(title: String, author: String, gender: String, displayed: Bool) {
        self.title = title
        self.author = author
        self.gender = gender
        self.displayed = displayed
    }

    public static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author
    }

    public static func < (lhs: Book, rhs: Book) -> Bool {
        return lhs.title < rhs.title
    }
}
