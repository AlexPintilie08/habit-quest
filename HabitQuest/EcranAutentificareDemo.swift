import SwiftUI

struct EcranAutentificareDemo: View {
    let autentificaDemo: () -> Void

    @State private var email = ""
    @State private var parola = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Habit Quest")
                .font(.largeTitle)
                .foregroundStyle(.black)

            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)

                SecureField("Parola", text: $parola)
                    .textContentType(.password)
                    .textFieldStyle(.roundedBorder)
            }

            Button("Login Demo", action: autentificaDemo)
                .buttonStyle(.borderedProminent)
                .tint(.black)
        }
        .padding(24)
        .frame(maxWidth: 400)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }
}
