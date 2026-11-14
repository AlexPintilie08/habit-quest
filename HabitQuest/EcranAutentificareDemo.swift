import SwiftUI

struct EcranAutentificareDemo: View {
    let autentificaDemo: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Habit Quest")
                        .font(.largeTitle)
                        .foregroundStyle(.black)

                    Text("Alege cum vrei sa continui.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 10) {
                    Text("Indisponibile momentan")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    butonIndisponibil("Continue with Apple")
                    butonIndisponibil("Continue with Google")
                    butonIndisponibil("Continue with Facebook")
                    butonIndisponibil("Continue with Microsoft")
                }

                Divider()

                Button("Login Demo", action: autentificaDemo)
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
            }
            .padding(24)
            .frame(maxWidth: 400)
            .frame(maxWidth: .infinity)
        }
        .background(Color.white.ignoresSafeArea())
    }

    private func butonIndisponibil(_ titlu: String) -> some View {
        Button(titlu) {}
            .frame(maxWidth: .infinity)
            .buttonStyle(.bordered)
            .disabled(true)
    }
}
