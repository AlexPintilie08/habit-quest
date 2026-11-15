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
                .tabItem { Label("Sat", systemImage: "house.fill") }
                .tag(FilaAcasa.sat)

            NavigationStack {
                paginaJourney
                    .navigationTitle("Journey")
            }
                .tabItem { Label("Journey", systemImage: "map") }
                .tag(FilaAcasa.journey)

            EcranPersonaj(esteActiv: filaSelectata == .character)
                .tabItem { Label("Character", systemImage: "person.crop.square") }
                .tag(FilaAcasa.character)

            EcranSetari()
                .tabItem { Label("Setari", systemImage: "gearshape") }
                .tag(FilaAcasa.setari)
        }
        .tint(.accentColor)
        .background(CuloriHabitQuest.fundalPrincipal.ignoresSafeArea())
    }

    private var paginaSat: some View {
        GeometryReader { geometrie in
            VStack(spacing: 12) {
                Image("IlustratieSatAcasa")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: min(max(geometrie.size.height * 0.58, 280), 420))
                    .background(CuloriHabitQuest.fundalIlustratie)
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
