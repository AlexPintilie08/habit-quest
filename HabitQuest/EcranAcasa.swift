import SwiftUI

private enum FilaAcasa: Hashable {
    case sat
    case journey
    case character
    case setari
}

struct EcranAcasa: View {
    @State private var filaSelectata = FilaAcasa.sat

    var body: some View {
        TabView(selection: $filaSelectata) {
            NavigationStack {
                paginaSat
                    .navigationTitle("Sat")
                    .toolbarBackground(CuloriHabitQuest.fundalPrincipal, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
                .tabItem {
                    Label(
                        "Sat",
                        systemImage: filaSelectata == .sat ? "house.fill" : "house"
                    )
                }
                .tag(FilaAcasa.sat)

            NavigationStack {
                paginaJourney
                    .navigationTitle("Journey")
            }
                .tabItem {
                    Label(
                        "Journey",
                        systemImage: filaSelectata == .journey ? "map.fill" : "map"
                    )
                }
                .tag(FilaAcasa.journey)

            EcranPersonaj(esteActiv: filaSelectata == .character)
                .tabItem {
                    Label(
                        "Character",
                        systemImage: filaSelectata == .character
                            ? "person.crop.square.fill"
                            : "person.crop.square"
                    )
                }
                .tag(FilaAcasa.character)

            EcranSetari()
                .tabItem {
                    Label(
                        "Setari",
                        systemImage: filaSelectata == .setari ? "gearshape.fill" : "gearshape"
                    )
                }
                .tag(FilaAcasa.setari)
        }
        .tint(
            filaSelectata == .journey
                ? CuloriHabitQuest.accentChihlimbar
                : CuloriHabitQuest.albastruInteractiune
        )
        .background(CuloriHabitQuest.fundalPrincipal.ignoresSafeArea())
    }

    private var paginaSat: some View {
        GeometryReader { geometrie in
            let latimeImagine = min(
                min(geometrie.size.height * 0.48, 360) * 640 / 520,
                geometrie.size.width - 48
            )

            VStack(spacing: 16) {
                Spacer(minLength: 0)

                Image("IlustratieSatAcasa")
                    .resizable()
                    .scaledToFit()
                    .frame(width: latimeImagine, height: latimeImagine * 520 / 640)
                    .accessibilityHidden(true)

                Text("Aici va creste satul tau")
                    .font(.title3)
                    .foregroundStyle(CuloriHabitQuest.textSecundar)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CuloriHabitQuest.fundalPrincipal)
        }
    }

    private var paginaJourney: some View {
        ContentUnavailableView(
            "Harta va aparea aici",
            systemImage: "map"
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CuloriHabitQuest.fundalPrincipal)
    }
}
