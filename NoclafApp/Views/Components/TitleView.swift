import SwiftUI

struct TitleView: View {
    var body: some View {
        Text("Login")
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    TitleView()
}
