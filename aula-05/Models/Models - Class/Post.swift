import Foundation

struct Post: Identifiable {
    let id = UUID()
    let imageName: String
    var isLiked: Bool = false
    var comment: String = ""
    var showLikeAnimation: Bool = false
}
