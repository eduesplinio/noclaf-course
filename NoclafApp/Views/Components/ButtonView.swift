import SwiftUI

/// View responsável pelo botão de login e autenticação do usuário
///
/// Esta view gerencia o processo de autenticação, incluindo:
/// - Validação dos campos de entrada
/// - Autenticação com o servidor
/// - Tratamento de erros
/// - Navegação após login bem-sucedido
///
/// # Exemplo de uso:
/// ```swift
/// @State var email = ""
/// @State var senha = ""
/// ButtonView(textField: $email, securityField: $senha)
/// ```
struct ButtonView: View {
    /// Campo de texto para email/usuário
    @Binding var textField: String
    
    /// Campo de texto para senha
    @Binding var securityField: String
    
    /// Controla a navegação após login bem-sucedido
    @State private var isNavigate = false
    
    /// Indica se está carregando durante a autenticação
    @State private var isLoading = false
    
    /// Mensagem de erro a ser exibida
    @State private var errorMessage = ""
    
    /// Controla a exibição da mensagem de erro
    @State private var showError = false
    
    /// Estado de login do usuário
    @AppStorage("login") var isLogin: Bool = false
    
    /// Nome do usuário logado
    @AppStorage("user") var user: String = ""
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .padding(.bottom, 10)
            }
            
            Button {
                // Validação dos campos
                if textField.isEmpty || securityField.isEmpty {
                    errorMessage = "Por favor, preencha todos os campos"
                    showError = true
                    return
                }
                
                isLoading = true
                showError = false
                
                // Prepara o username - remove espaços e converte para maiúsculas
                let username = textField.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                
                // Autenticação com UserDAO
                UserDAO.shared.authenticate(username: username, password: securityField) { result in
                    self.isLoading = false
                    
                    switch result {
                    case .success(let response):
                        if response.success {
                            // Login bem-sucedido
                            print("Login realizado com sucesso")
                            self.isLogin = true
                            self.user = username
                            
                            // Busca dados do usuário
                            self.fetchUserData()
                            
                            // Navega para a próxima tela
                            self.isNavigate = true
                        }
                        
                    case .failure(let error):
                        // Falha na autenticação
                        if let urlError = error as? URLError {
                            switch urlError.code {
                            case .notConnectedToInternet:
                                self.errorMessage = "Sem conexão com a internet"
                            case .timedOut:
                                self.errorMessage = "Tempo de conexão esgotado"
                            default:
                                self.errorMessage = "Não foi possível conectar ao servidor"
                            }
                        } else {
                            self.errorMessage = "E-mail ou senha incorretos"
                        }
                        self.showError = true
                    }
                }
                
            } label: {
                Text("Enviar")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 15)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.blue)
                    )
            }
            .disabled(isLoading)
            .opacity(isLoading ? 0.7 : 1.0)
            .background(
                NavigationLink(destination: TabNavView(), isActive: $isNavigate,
                               label: { EmptyView() })
            )
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    /// Busca os dados do usuário após login bem-sucedido
    ///
    /// Esta função é chamada automaticamente após a autenticação bem-sucedida
    /// e busca informações adicionais do usuário no servidor.
    private func fetchUserData() {
        UserDAO.shared.getUser { result in
            switch result {
            case .success(let response):
                if response.success, let userData = response.user {
                    print("Dados do usuário obtidos: \(userData.name)")
                    // Aqui você pode armazenar dados adicionais do usuário se necessário
                } else {
                    print("Falha ao obter dados do usuário: \(response.message)")
                }
            case .failure(let error):
                print("Erro ao buscar dados do usuário: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    @State var previewTextField = ""
    @State var previewSecurityField = ""
    
    return ButtonView(textField: $previewTextField, securityField: $previewSecurityField)
}
