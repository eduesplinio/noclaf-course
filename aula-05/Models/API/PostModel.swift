import Foundation

/// Modelo que representa um post no sistema
struct PostModel: Codable, Identifiable {
    let id: Int
    let image: String
    let title: String
    let createdAt: String
    let updatedAt: String
    let createdBy: Int
    let createdByObject: UserModel
    
    /// Mapeamento das chaves da API para as propriedades do modelo
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case createdBy = "created_by"
        case createdByObject = "created_by_object"
    }
}

/// Resposta da API para operações relacionadas a posts
struct PostResponse: Codable {
    /// Lista de posts
    let posts: [PostModel]
    
    /// Inicializador para decodificação da resposta da API
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        posts = try container.decode([PostModel].self)
    }
} 
