import SwiftUI

struct TextView: View {
    @Binding var textField: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TextField("Usuário", text: $textField)
            .autocapitalization(.none)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? .black : .white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                colorScheme == .dark ? .white : .black,
                                lineWidth: 2
                            )
                    )
            )
            .frame(width: 360)
    }
}

#Preview {
    @State var previewText = ""
    return TextView(textField: $previewText)
}
