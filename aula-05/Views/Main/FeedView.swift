import SwiftUI

// MARK: - FeedView
struct FeedView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var posts: [PostModel] = []
    @State private var posts: 
    @State private var isLoading = true
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    ProgressView()
                } else if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(posts) { post in
                                PostView(post: post, colorScheme: colorScheme)
                                    .padding(.vertical)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .onAppear {
                fetchPosts()
            }
        }
    }
    
    private func fetchPosts() {
        isLoading = true
        errorMessage = ""
        
        PostDAO.shared.getPosts { result in
            isLoading = false
            
            switch result {
            case .success(let response):
                self.posts = response.posts
                print("Posts obtidos com sucesso")
            case .failure(let error):
                errorMessage = "Erro: \(error.localizedDescription)"
                print("Erro ao buscar posts: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - PostView
struct PostView: View {
    let post: PostModel
    var colorScheme: ColorScheme
    @State private var isLiked = false
    @State private var showLikeAnimation = false
    @State private var comment = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Cabeçalho do post
            HStack {
                Text(post.createdByObject.name)
                    .font(.headline)
                Spacer()
                Text(post.createdAt)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // Título do post
            Text(post.title)
                .font(.title3)
                .padding(.horizontal)
            
            // Imagem do post
            AsyncImage(url: URL(string: post.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(height: 250)
            }
            .padding(.horizontal)
            
            // Botões e campo de comentário
            InteractionView(isLiked: $isLiked, showLikeAnimation: $showLikeAnimation, comment: $comment, colorScheme: colorScheme)
                .padding(.horizontal)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - InteractionView
struct InteractionView: View {
    @Binding var isLiked: Bool
    @Binding var showLikeAnimation: Bool
    @Binding var comment: String
    var colorScheme: ColorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: {
                isLiked.toggle()
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : .gray)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            CommentField(comment: $comment, colorScheme: colorScheme)
        }
    }
}

// MARK: - CommentField
struct CommentField: View {
    @Binding var comment: String
    var colorScheme: ColorScheme
    
    var body: some View {
        let backgroundColor = colorScheme == .dark ? Color.black : Color.white
        let borderColor = colorScheme == .dark ? Color.white : Color.black
        
        return TextField("Comentar", text: $comment)
            .autocapitalization(.none)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 2)
                    )
            )
            .frame(height: 40)
    }
}

// MARK: - Preview
#Preview {
    FeedView()
}
