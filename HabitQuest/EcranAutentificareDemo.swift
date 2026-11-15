import SwiftUI

struct EcranAutentificareDemo: View {
    let autentificaDemo: () -> Void

    var body: some View {
        GeometryReader { geometrie in
            ScrollView {
                VStack(spacing: 0) {
                    Image("IlustratieAutentificare")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: min(geometrie.size.height * 0.28, 230))
                        .background(CuloriHabitQuest.fundalIlustratie)
                        .padding(.horizontal, -24)
                        .accessibilityHidden(true)

                    VStack(spacing: 4) {
                        Text("Habit Quest")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(CuloriHabitQuest.textPrincipal)

                        Text("Aventura ta incepe aici")
                            .font(.body)
                            .foregroundStyle(CuloriHabitQuest.textSecundar)
                    }
                    .padding(.bottom, 22)

                    VStack(spacing: 4) {
                        randIndisponibil("Continue with Apple")
                        randIndisponibil("Continue with Google")
                        randIndisponibil("Continue with Facebook")
                        randIndisponibil("Sign in with Microsoft")
                    }

                    butonLoginDemo
                        .padding(.top, 22)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 24)
                .frame(maxWidth: 480)
                .frame(maxWidth: .infinity)
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

    private func randIndisponibil(_ titlu: String) -> some View {
        HStack(spacing: 12) {
            Text(titlu)
                .font(.body)
                .foregroundStyle(CuloriHabitQuest.textSecundar)

            Spacer(minLength: 8)

            Text("Indisponibil")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 44)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Metoda de autentificare indisponibila")
    }
}
