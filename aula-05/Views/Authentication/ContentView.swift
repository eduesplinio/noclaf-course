import SwiftUI

struct ContentView: View {
    @State private var textField: String = ""
    @State private var securityField: String = ""
    @State private var isNavigate: Bool = false
    
    @AppStorage("login") var isLogin: Bool = false
    @AppStorage("user") var user: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                LogoView()
                TitleView()
                TextView(textField: $textField)
                SecureView(securityField: $securityField)
                ButtonView(textField: $textField, securityField: $securityField)
            }
            .padding()
            .onAppear {
                checkIfUserIsLoggedIn()
            }
            .background(
                NavigationLink(destination: TabNavView(), isActive: $isNavigate,
                               label: { EmptyView() })
            )
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        print("Verificando se o usuário já está logado...")
        
        // Verifica se o usuário já está logado
        if isLogin && !user.isEmpty && UserDefaults.standard.string(forKey: "userToken") != nil {
            print("Usuário já está logado: \(user)")
            
            // Verifica a validade do token fazendo uma requisição para o endpoint get-user
            UserDAO.shared.getUser { result in
                switch result {
                case .success(let response):
                    if response.success {
                        print("Token válido, login automático bem-sucedido")
                        // Se o token for válido, navega para a tela principal
                        DispatchQueue.main.async {
                            isNavigate = true
                        }
                    } else {
                        print("Token inválido ou expirado, necessário fazer login novamente")
                        // Se o token for inválido, reseta o estado de login
                        isLogin = false
                        UserDefaults.standard.removeObject(forKey: "userToken")
                    }
                case .failure:
                    print("Falha ao validar token, necessário fazer login novamente")
                    // Se a requisição falhar, reseta o estado de login
                    isLogin = false
                    UserDefaults.standard.removeObject(forKey: "userToken")
                }
            }
        } else {
            print("Nenhuma sessão de login salva encontrada")
        }
    }
}

#Preview {
    ContentView()
}
