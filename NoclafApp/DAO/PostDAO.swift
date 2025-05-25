import Foundation
import Alamofire

/// Classe responsável por gerenciar as operações de posts com a API
class PostDAO {
    // MARK: - Singleton
    static let shared = PostDAO()
    private init() {}
    
    // MARK: - Constantes
    private let baseURL = "https://unifesoios.noclaf.com.br/core"
    
    // MARK: - Obter Posts
    /// Obtém a lista de posts
    func getPosts(completion: @escaping (Result<PostResponse, Error>) -> Void) {
        print("Obtendo posts...")
        
        // Obtém o token salvo
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("Token não encontrado")
            completion(.failure(NSError(domain: "Token não disponível", code: 401, userInfo: nil)))
            return
        }
        
        // Endpoint da API
        let url = "\(baseURL)/load-posts/"
        
        // Headers com o token
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)"
        ]
         
        print("Enviando requisição para: \(url)")
        
        // Realiza a requisição
        AF.request(url,
                   method: .get,
                   headers: headers)
            .validate()
            .responseDecodable(of: PostResponse.self) { response in
                print("Resposta recebida")
                
                switch response.result {
                case .success(let postResponse):
                    print("Posts obtidos com sucesso")
                    completion(.success(postResponse))
                    
                case .failure(let error):
                    print("Falha ao obter posts: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
} 
