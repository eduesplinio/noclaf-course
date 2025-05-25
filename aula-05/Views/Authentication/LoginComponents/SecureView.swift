import SwiftUI

struct SecureView: View {
    @Binding var securityField: String
    @State private var isSecured: Bool = true
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Group {
                if isSecured {
                    SecureField("Senha", text: $securityField)
                } else {
                    TextField("Senha", text: $securityField)
                }
            }
            .autocapitalization(.none)

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? .black : .white)
                .stroke(
                    colorScheme == .dark ? .white : .black,
                    lineWidth: 2
                )
        )
        .frame(width: 360)
    }
}

#Preview {
    @State var previewSecureField = ""
    return SecureView(securityField: $previewSecureField)
}
