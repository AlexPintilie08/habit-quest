import SwiftUI

private enum FilaAcasa: Hashable {
    case sat
    case harta
    case profil
}

struct EcranAcasa: View {
    @State private var filaSelectata = FilaAcasa.sat

    var body: some View {
        TabView(selection: $filaSelectata) {
            paginaSat
                .tabItem { Label("Sat", systemImage: "house.fill") }
                .tag(FilaAcasa.sat)

            ecranCuTitlu("Harta")
                .tabItem { Label("Harta", systemImage: "map") }
                .tag(FilaAcasa.harta)

            ecranCuTitlu("Profil")
                .tabItem { Label("Profil", systemImage: "person.crop.circle") }
                .tag(FilaAcasa.profil)
        }
        .tint(.black)
        .background(Color.white.ignoresSafeArea())
    }

    private var paginaSat: some View {
        GeometryReader { geometrie in
            VStack(alignment: .leading, spacing: 0) {
                Text("Habit Quest")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.black)
                    .padding(.top, 12)

                Spacer(minLength: 20)

                VStack(spacing: 8) {
                    Image("IlustratieSatAcasa")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: min(geometrie.size.height * 0.43, 330))
                        .accessibilityHidden(true)

                    Text("Sat")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(.black)

                    Text("Aici va creste satul tau")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }

    private func ecranCuTitlu(_ titlu: String) -> some View {
        Text(titlu)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}
