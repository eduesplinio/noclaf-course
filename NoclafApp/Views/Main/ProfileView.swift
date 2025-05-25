import SwiftUI

/// View responsável pela exibição e gerenciamento do perfil do usuário
///
/// Esta view exibe as informações do usuário logado e fornece opções para:
/// - Visualizar dados do perfil
/// - Acessar lista de amigos
/// - Acessar lista de seguidores
/// - Realizar logout
///
/// # Exemplo de uso:
/// ```swift
/// ProfileView()
/// ```
struct ProfileView: View {
    /// Estado de login do usuário
    @AppStorage("login") var isLogin: Bool = false
    
    /// Controla a navegação após logout
    @State private var isNavigate: Bool = false
    
    /// Nome do usuário logado
    @AppStorage("user") var user: String = ""
    
    /// Dados detalhados do usuário
    @State private var userDetails: UserModel?
    
    /// Indica se está carregando os dados do usuário
    @State private var isLoading = true
    
    /// Mensagem de erro a ser exibida
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .padding()
                        } else if let userData = userDetails {
                            Text("Olá, \(userData.name)!")
                                .font(.title)
                                .foregroundColor(.primary)
                                .padding()
                        } else if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        Spacer()
                    }

                    Spacer()

                    VStack(spacing: 12) {
                        MenuRow(title: "Perfil", icon: "person.fill")
                        MenuRow(title: "Amigos", icon: "person.2.fill")
                        MenuRow(title: "Seguidores", icon: "person.3.fill")
                        Button {
                            logout()
                        } label: {
                            MenuRow(
                                title: "Sair",
                                icon: "rectangle.portrait.and.arrow.right.fill"
                            )
                        }
                    }
                    .frame(maxWidth: 300)
                    Spacer()
                }
            }
            .background(
                NavigationLink(
                    destination: ContentView(),
                    isActive: $isNavigate,
                    label: {
                        EmptyView()
                    }
                )
            )
            .padding()
            .onAppear {
                fetchUserData()
            }
        }
    }
    
    /// Busca os dados do usuário no servidor
    ///
    /// Esta função é chamada quando a view aparece e busca as informações
    /// atualizadas do usuário no servidor.
    private func fetchUserData() {
        isLoading = true
        errorMessage = ""
        
        UserDAO.shared.getUser { result in
            isLoading = false
            
            switch result {
            case .success(let response):
                if response.success, let userData = response.user {
                    userDetails = userData
                    print("Dados do usuário obtidos com sucesso")
                } else {
                    errorMessage = "Não foi possível obter os dados: \(response.message)"
                    print("Falha ao obter dados do usuário: \(response.message)")
                }
            case .failure(let error):
                errorMessage = "Erro: \(error.localizedDescription)"
                print("Erro ao buscar dados do usuário: \(error.localizedDescription)")
            }
        }
    }
    
    /// Realiza o logout do usuário
    ///
    /// Esta função limpa os dados do usuário armazenados localmente e
    /// navega de volta para a tela de login.
    private func logout() {
        // Limpa os dados do usuário e token
        isLogin = false
        user = ""
        UserDefaults.standard.removeObject(forKey: "userToken")
        isNavigate = true
        print("Usuário deslogado")
    }
}

/// View responsável por exibir uma linha do menu do perfil
///
/// Esta view é usada para exibir as opções do menu do perfil com um ícone
/// e uma seta indicando que é clicável.
struct MenuRow: View {
    /// Título da opção do menu
    let title: String
    
    /// Nome do ícone do SF Symbols
    let icon: String

    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileView()
}
