import SwiftUI

struct EcranAutentificareDemo: View {
    let autentificaDemo: () -> Void

    var body: some View {
        GeometryReader { geometrie in
            let inaltimeImagine = min(max(geometrie.size.height * 0.34, 180), 280)
            let latimeImagine = min(inaltimeImagine * 1122 / 1402, geometrie.size.width - 48)

            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    Image("IlustratieCastelPoveste")
                        .resizable()
                        .scaledToFit()
                        .frame(width: latimeImagine, height: latimeImagine * 1402 / 1122)
                        .accessibilityHidden(true)

                    VStack(spacing: 4) {
                        Text("Habit Quest")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(CuloriHabitQuest.textPrincipal)

                        Text("Aventura ta incepe aici")
                            .font(.body)
                            .foregroundStyle(CuloriHabitQuest.textSecundar)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 20)

                    VStack(spacing: 0) {
                        randIndisponibil("Continue with Apple", simbol: "apple.logo")
                        Divider().padding(.leading, 48)
                        randIndisponibil("Continue with Google", sigla: "SiglaGoogle")
                        Divider().padding(.leading, 48)
                        randIndisponibil("Continue with Facebook", sigla: "SiglaFacebook")
                        Divider().padding(.leading, 48)
                        randIndisponibil("Sign in with Microsoft", sigla: "SiglaMicrosoft")
                    }
                    .padding(.horizontal, 12)
                    .background(
                        CuloriHabitQuest.suprafataSecundara,
                        in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                    )

                    butonLoginDemo
                        .padding(.top, 20)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .frame(maxWidth: 480)
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometrie.size.height)
            }
            .scrollIndicators(.hidden)
        }
        .background(CuloriHabitQuest.fundalPrincipal.ignoresSafeArea())
    }

    private var butonLoginDemo: some View {
        Button(action: autentificaDemo) {
            Label("Login Demo", systemImage: "house.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(CuloriHabitQuest.albastruInteractiune)
        .foregroundStyle(CuloriHabitQuest.textPeAccent)
    }

    @ViewBuilder
    private func randIndisponibil(
        _ titlu: String,
        sigla: String? = nil,
        simbol: String? = nil
    ) -> some View {
        HStack(spacing: 12) {
            Group {
                if let sigla {
                    Image(sigla)
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                } else if let simbol {
                    Image(systemName: simbol)
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .padding(4)
                        .foregroundStyle(CuloriHabitQuest.textPrincipal)
                }
            }
            .frame(width: 28, height: 28)
            .accessibilityHidden(true)

            Text(titlu)
                .font(.body.weight(.medium))
                .foregroundStyle(CuloriHabitQuest.textPrincipal)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            HStack(spacing: 5) {
                Image(systemName: "lock.fill")
                Text("Indisponibil")
            }
            .font(.caption)
            .foregroundStyle(CuloriHabitQuest.textSecundar)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(titlu), indisponibil momentan")
    }
}
