import SwiftUI

struct EcranPersonaj: View {
    let esteActiv: Bool

    @State private var personaj = StocarePersonaj.incarca()
    @State private var afiseazaAspect = false
    @State private var afiseazaEchipament = false
    @AppStorage("animatiiActive") private var animatiiActive = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var stareAplicatie

    private var animatiaEstePermisa: Bool {
        esteActiv && animatiiActive && !reduceMotion && stareAplicatie == .active
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                antet
                    .padding(.top, 8)

                Spacer(minLength: 0)

                RandarePersonaj(
                    personaj: personaj,
                    animatiePermisa: animatiaEstePermisa
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .layoutPriority(1)

                Spacer(minLength: 8)

                HStack(spacing: 12) {
                    Button {
                        afiseazaAspect = true
                    } label: {
                        Label("Aspect", systemImage: "person.crop.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    Button {
                        afiseazaEchipament = true
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
            .background(CuloriHabitQuest.fundalPrincipal)
            .navigationTitle("Character")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $afiseazaAspect) {
                PanouAspectPersonaj(
                    personaj: $personaj,
                    animatiePermisa: animatiaEstePermisa
                )
            }
            .sheet(isPresented: $afiseazaEchipament) {
                PanouEchipamentPersonaj(personaj: $personaj)
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
                    afiseazaAspect = true
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
