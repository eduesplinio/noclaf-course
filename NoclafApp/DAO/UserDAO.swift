import Foundation
import Alamofire
import SwiftHash

/// Classe responsável por gerenciar as operações de usuário com a API
///
/// Esta classe implementa o padrão Singleton e fornece métodos para:
/// - Autenticação de usuários
/// - Obtenção de dados do usuário
/// - Gerenciamento de tokens
class UserDAO {
    // MARK: - Singleton
    /// Instância compartilhada do UserDAO
    static let shared = UserDAO()
    
    /// Inicializador privado para garantir o padrão Singleton
    private init() {}
    
    // MARK: - Constantes
    /// URL base da API
    private let baseURL = "https://unifesoios.noclaf.com.br/core"
    
    // MARK: - Autenticação
    /// Autentica um usuário na API
    ///
    /// Este método realiza a autenticação do usuário, gerando um hash MD5 da senha
    /// e enviando as credenciais para a API.
    ///
    /// - Parameters:
    ///   - username: Email do usuário
    ///   - password: Senha do usuário
    ///   - completion: Closure chamada com o resultado da autenticação
    func authenticate(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        print("Iniciando processo de autenticação...")
        
        // Normaliza o email (converte para minúsculas)
        let normalizedEmail = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Gera o hash MD5 da senha em maiúsculas
        let hashedPassword = MD5(password).uppercased()
        print("Email: \(normalizedEmail)")
        print("Hash da senha: \(hashedPassword)")
        
        // Prepara os parâmetros da requisição
        let parameters: [String: String] = [
            "email": normalizedEmail,
            "password": hashedPassword
        ]
        
        // Endpoint da API
        let url = "\(baseURL)/auth-user/"
        print("Enviando requisição para: \(url)")
        
        // Realiza a requisição
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                print("Resposta recebida")
                
                // Imprime a resposta bruta para debug
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print("Resposta bruta: \(responseString)")
                }
                
                switch response.result {
                case .success(let loginResponse):
                    // Se recebemos um token, consideramos a autenticação bem-sucedida
                    if let token = loginResponse.token {
                        print("Autenticação bem-sucedida")
                        print("Token recebido: \(token)")
                        
                        // Salva o token
                        UserDefaults.standard.set(token, forKey: "userToken")
                        print("Token salvo com sucesso")
                        
                        // Cria uma nova resposta com sucesso
                        let successResponse = LoginResponse(
                            success: true,
                            message: "Autenticação bem-sucedida",
                            token: token
                        )
                        completion(.success(successResponse))
                    } else {
                        print("Autenticação falhou: Token não recebido")
                        completion(.failure(NSError(domain: "Token não recebido", code: 401, userInfo: nil)))
                    }
                    
                case .failure(let error):
                    print("Falha na autenticação: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Obter Dados do Usuário
    /// Obtém os dados do usuário logado
    ///
    /// Este método busca os dados do usuário usando o token de autenticação
    /// armazenado localmente.
    ///
    /// - Parameter completion: Closure chamada com o resultado da operação
    func getUser(completion: @escaping (Result<UserResponse, Error>) -> Void) {
        print("Obtendo informações do usuário...")
        
        // Obtém o token salvo
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("Token não encontrado")
            completion(.failure(NSError(domain: "Token não disponível", code: 401, userInfo: nil)))
            return
        }
        
        print("Token usado: \(token)")
        
        // Endpoint da API
        let url = "\(baseURL)/get-user/"
        
        // Headers com o token
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)"
        ]
        
        print("Enviando requisição para: \(url)")
        print("Headers: \(headers)")
        
        // Realiza a requisição
        AF.request(url,
                   method: .get,
                   headers: headers)
            .validate()
            .responseData { response in
                print("Resposta recebida")
                
                switch response.result {
                case .success(let data):
                    do {
                        // Decodifica diretamente para UserModel
                        let user = try JSONDecoder().decode(UserModel.self, from: data)
                        print("Dados do usuário obtidos com sucesso")
                        print("Nome: \(user.name)")
                        print("Email: \(user.email)")
                        
                        // Cria uma resposta de sucesso
                        let userResponse = UserResponse(success: true, message: "Dados obtidos com sucesso", user: user)
                        completion(.success(userResponse))
                    } catch {
                        print("Erro ao decodificar resposta: \(error)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Falha ao obter dados do usuário: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
