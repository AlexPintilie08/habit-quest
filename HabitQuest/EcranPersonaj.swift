import SwiftUI

struct EcranPersonaj: View {
    let esteActiv: Bool

    @State private var personaj = StocarePersonaj.incarca()
    @State private var panouDeschis: PanouPersonaj?
    @AppStorage("animatiiActive") private var animatiiActive = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var stareAplicatie

    private var animatiaEstePermisa: Bool {
        esteActiv && animatiiActive && !reduceMotion && stareAplicatie == .active
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometrie in
                VStack(spacing: 8) {
                    antet
                        .padding(.top, 8)

                    Spacer(minLength: 0)

                    RandarePersonaj(
                        personaj: personaj,
                        animatiePermisa: animatiaEstePermisa
                    )
                    .frame(height: min(max(geometrie.size.height * 0.64, 250), 460))
                    .frame(maxWidth: .infinity)

                    Spacer(minLength: 8)

                    HStack(spacing: 12) {
                        Button {
                            panouDeschis = .aspect
                        } label: {
                            Label("Aspect", systemImage: "person.crop.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)

                        Button {
                            panouDeschis = .echipament
                        } label: {
                            Label("Echipament", systemImage: "shield.lefthalf.filled")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                    .padding(.bottom, 12)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(CuloriHabitQuest.fundalPrincipal)
            .navigationTitle("Character")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $panouDeschis) { panou in
                switch panou {
                case .aspect:
                    PanouAspectPersonaj(personaj: $personaj)
                case .echipament:
                    PanouEchipamentPersonaj(personaj: $personaj)
                }
            }
            .onChange(of: personaj) { _, personajActualizat in
                StocarePersonaj.salveaza(personajActualizat)
            }
        }
    }

    private var antet: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Text(personaj.nume)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Button {
                    panouDeschis = .aspect
                } label: {
                    Image(systemName: "pencil")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Editeaza numele si aspectul eroului")
            }

            Label(personaj.clasa.titlu, systemImage: "shield.lefthalf.filled")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private enum PanouPersonaj: String, Identifiable {
    case aspect
    case echipament

    var id: String { rawValue }
}
