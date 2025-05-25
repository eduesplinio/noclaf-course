import SwiftUI

struct LogoView: View {
    @State private var logoScale: CGFloat = 0.1
    @State private var logoOpacity: Double = 0
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Image(systemName: "swift")
            .resizable()
            .scaledToFit()
            .frame(width: 90, height: 90)
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.0, green: 0.8, blue: 1.0),
                                Color(red: 0.0, green: 0.4, blue: 0.9),
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .shadow(
                color: colorScheme == .dark ? .white : .black.opacity(0.6),
                radius: 15
            )
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
            .onAppear {
                withAnimation(.spring(response: 3.5, dampingFraction: 0.7)) {
                    logoScale = 1.0
                    logoOpacity = 1.0
                }
            }
    }
}

#Preview {
    LogoView()
}
