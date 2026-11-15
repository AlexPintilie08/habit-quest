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
            paginaSat
                .tabItem { Label("Sat", systemImage: "house.fill") }
                .tag(FilaAcasa.sat)

            ecranCuTitlu("Journey")
                .tabItem { Label("Journey", systemImage: "map") }
                .tag(FilaAcasa.journey)

            EcranPersonaj(esteActiv: filaSelectata == .character)
                .tabItem { Label("Character", systemImage: "person.crop.square") }
                .tag(FilaAcasa.character)

            EcranSetari()
                .tabItem { Label("Setari", systemImage: "gearshape") }
                .tag(FilaAcasa.setari)
        }
        .tint(.primary)
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
    }

    private var paginaSat: some View {
        GeometryReader { geometrie in
            VStack(alignment: .leading, spacing: 0) {
                Text("Habit Quest")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 12)

                Spacer(minLength: 20)

                VStack(spacing: 8) {
                    Image("IlustratieSatAcasa")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: min(geometrie.size.height * 0.43, 330))
                        .padding(8)
                        .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .accessibilityHidden(true)

                    Text("Sat")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(.primary)

                    Text("Aici va creste satul tau")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
        }
    }

    private func ecranCuTitlu(_ titlu: String) -> some View {
        Text(titlu)
            .font(.title2)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
    }
}
