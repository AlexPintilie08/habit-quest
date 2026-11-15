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
                        .padding(8)
                        .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .accessibilityHidden(true)

                    VStack(spacing: 4) {
                        Text("Habit Quest")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(.primary)

                        Text("Aventura ta incepe aici")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 22)

                    VStack(spacing: 10) {
                        butonIndisponibil("Continue with Apple", sigla: nil, simbol: "apple.logo")
                        butonIndisponibil("Continue with Google", sigla: "SiglaGoogle")
                        butonIndisponibil("Continue with Facebook", sigla: "SiglaFacebook")
                        butonIndisponibil("Sign in with Microsoft", sigla: "SiglaMicrosoft")
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
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
    }

    private var butonLoginDemo: some View {
        Button(action: autentificaDemo) {
            HStack(spacing: 16) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 25, weight: .medium))
                    .frame(width: 46, height: 46)

                Rectangle()
                    .fill(Color(uiColor: .systemBackground).opacity(0.3))
                    .frame(width: 1, height: 38)

                Text("Login Demo")
                    .font(.system(size: 21, weight: .semibold))

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 20, weight: .medium))
            }
            .foregroundStyle(Color(uiColor: .systemBackground))
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 76)
            .background(Color.primary, in: RoundedRectangle(cornerRadius: 24))
        }
        .buttonStyle(.plain)
    }

    private func butonIndisponibil(_ titlu: String, sigla: String?, simbol: String? = nil) -> some View {
        Button {} label: {
            HStack(spacing: 14) {
                Group {
                    if let sigla {
                        Image(sigla)
                            .resizable()
                            .scaledToFit()
                            .padding(4)
                    } else if let simbol {
                        Image(systemName: simbol)
                            .resizable()
                            .scaledToFit()
                            .padding(11)
                            .foregroundStyle(.primary)
                    }
                }
                .frame(width: 44, height: 44)
                .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 14))

                Rectangle()
                    .fill(Color.primary.opacity(0.1))
                    .frame(width: 1, height: 44)

                VStack(alignment: .leading, spacing: 3) {
                    Text(titlu)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.primary.opacity(0.82))

                    Text("Indisponibil momentan")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 4)

                Image(systemName: "lock")
                    .font(.system(size: 19, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(Color.primary.opacity(0.04), in: RoundedRectangle(cornerRadius: 22))
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            }
        }
        .buttonStyle(StilButonInactiv())
        .disabled(true)
        .accessibilityHint("Metoda de autentificare indisponibila")
    }
}

private struct StilButonInactiv: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
