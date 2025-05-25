import Foundation

/// Modelo que representa um usuário no sistema
///
/// Este modelo contém todas as informações de um usuário, incluindo:
/// - Dados básicos (id, nome, email)
/// - Dados de perfil (imagem, data de nascimento)
/// - Status do usuário (ativo, admin, deletado)
/// - Dados de segurança (hash de senha, expiração)
/// - Timestamps (criação, atualização)
///
/// # Exemplo de uso:
/// ```swift
/// let user = UserModel(id: 1, name: "João", email: "joao@email.com", ...)
/// ```
struct UserModel: Codable {
    /// Identificador único do usuário
    let id: Int
    
    /// URL da imagem de perfil do usuário (opcional)
    let profileImage: String?
    
    /// Data e hora do último login
    let lastLogin: String
    
    /// Email do usuário
    let email: String
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.profileImage, forKey: .profileImage)
        try container.encode(self.lastLogin, forKey: .lastLogin)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.birthday, forKey: .birthday)
        try container.encode(self.isAdmin, forKey: .isAdmin)
        try container.encode(self.isActive, forKey: .isActive)
        try container.encode(self.isDeleted, forKey: .isDeleted)
        try container.encodeIfPresent(self.forgotPasswordHash, forKey: .forgotPasswordHash)
        try container.encodeIfPresent(self.forgotPasswordExpire, forKey: .forgotPasswordExpire)
        try container.encode(self.createdAt, forKey: .createdAt)
        try container.encode(self.updatedAt, forKey: .updatedAt)
    }
    
    /// Nome completo do usuário
    let name: String
    
    /// Data de nascimento do usuário
    let birthday: String
    
    /// Indica se o usuário é administrador
    let isAdmin: Bool
    
    /// Indica se o usuário está ativo
    let isActive: Bool
    
    /// Indica se o usuário foi deletado
    let isDeleted: Bool
    
    /// Hash para recuperação de senha (opcional)
    let forgotPasswordHash: String?
    
    /// Data de expiração do hash de recuperação (opcional)
    let forgotPasswordExpire: String?
    
    /// Data de criação do usuário
    let createdAt: String
    
    /// Data da última atualização do usuário
    let updatedAt: String
    
    /// Mapeamento das chaves da API para as propriedades do modelo
    enum CodingKeys: String, CodingKey {
        case id
        case profileImage = "profile_image"
        case lastLogin = "last_login"
        case email
        case name
        case birthday
        case isAdmin = "is_admin"
        case isActive = "is_active"
        case isDeleted = "is_deleted"
        case forgotPasswordHash = "forgot_password_hash"
        case forgotPasswordExpire = "forgot_password_expire"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

/// Resposta da API para operações de login
///
/// Este modelo representa a resposta do servidor após uma tentativa de login,
/// contendo informações sobre o sucesso da operação e o token de autenticação.
struct LoginResponse: Codable {
    /// Indica se o login foi bem-sucedido
    let success: Bool
    
    /// Mensagem de retorno da API
    let message: String
    
    /// Token de autenticação (opcional)
    let token: String?
    
    /// Mapeamento das chaves da API
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case token
    }
    
    /// Inicializador para criação direta da resposta
    /// - Parameters:
    ///   - success: Indica se o login foi bem-sucedido
    ///   - message: Mensagem de retorno
    ///   - token: Token de autenticação
    init(success: Bool, message: String, token: String?) {
        self.success = success
        self.message = message
        self.token = token
    }
    
    /// Inicializador para decodificação da resposta da API
    /// - Parameter decoder: Decodificador da resposta
    /// - Throws: Erro de decodificação
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decodificar 'success' que pode ser boolean ou string
        if let successBool = try? container.decode(Bool.self, forKey: .success) {
            success = successBool
        } else if let successString = try? container.decode(String.self, forKey: .success) {
            success = successString.lowercased() == "true"
        } else {
            success = false
        }
        
        // Decodificar 'message'
        message = (try? container.decode(String.self, forKey: .message)) ?? "Sem mensagem"
        
        // Decodificar 'token' opcional
        token = try? container.decodeIfPresent(String.self, forKey: .token)
    }
}

/// Resposta da API para operações relacionadas ao usuário
///
/// Este modelo representa a resposta do servidor para operações que retornam
/// dados do usuário, como busca de perfil ou atualização.
struct UserResponse: Codable {
    /// Indica se a operação foi bem-sucedida
    let success: Bool
    
    /// Mensagem de retorno da API
    let message: String
    
    /// Dados do usuário (opcional)
    let user: UserModel?
    
    /// Mapeamento das chaves da API
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case user
    }
    
    /// Inicializador para criação direta da resposta
    /// - Parameters:
    ///   - success: Indica se a operação foi bem-sucedida
    ///   - message: Mensagem de retorno
    ///   - user: Dados do usuário
    init(success: Bool, message: String, user: UserModel?) {
        self.success = success
        self.message = message
        self.user = user
    }
    
    /// Inicializador para decodificação da resposta da API
    /// - Parameter decoder: Decodificador da resposta
    /// - Throws: Erro de decodificação
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decodificar 'success' que pode ser boolean ou string
        if let successBool = try? container.decode(Bool.self, forKey: .success) {
            success = successBool
        } else if let successString = try? container.decode(String.self, forKey: .success) {
            success = successString.lowercased() == "true"
        } else {
            success = false
        }
        
        // Decodificar 'message'
        message = (try? container.decode(String.self, forKey: .message)) ?? "E-mail ou Senha inválidos."
        
        // Decodificar 'user' opcional
        user = try? container.decodeIfPresent(UserModel.self, forKey: .user)
    }
}
