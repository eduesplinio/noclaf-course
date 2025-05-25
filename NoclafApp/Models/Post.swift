import Foundation

/// Modelo que representa um post no feed
struct Post: Identifiable {
    /// Identificador único do post
    let id = UUID()
    
    /// Nome da imagem associada ao post
    let imageName: String
    
    /// Indica se o post foi curtido pelo usuário atual
    var isLiked: Bool = false
    
    /// Comentário associado ao post
    var comment: String = ""
    
    /// Controla a animação de like
    var showLikeAnimation: Bool = false
} 