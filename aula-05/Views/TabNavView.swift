import SwiftUI

/// View responsável pela navegação principal do aplicativo
///
/// Esta view gerencia a navegação entre as principais seções do app:
/// - Feed: Exibe o conteúdo principal
/// - Perfil: Exibe as informações do usuário
///
/// # Exemplo de uso:
/// ```swift
/// TabNavView()
/// ```
struct TabNavView: View {
    /// Estado de login do usuário
    @AppStorage("login") var isLogin: Bool = false
    
    /// Nome do usuário logado
    @AppStorage("user") var user: String = ""
    
    var body: some View {
        TabView {
            // Tab do Feed
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "house.fill")
                }
            
            // Tab do Perfil
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    TabNavView()
} 
