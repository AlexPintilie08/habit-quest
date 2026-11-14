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
            ecranCuTitlu("Sat")
                .tabItem { Text("Sat") }
                .tag(FilaAcasa.sat)

            ecranCuTitlu("Harta")
                .tabItem { Text("Harta") }
                .tag(FilaAcasa.harta)

            ecranCuTitlu("Profil")
                .tabItem { Text("Profil") }
                .tag(FilaAcasa.profil)
        }
        .tint(.black)
        .background(Color.white.ignoresSafeArea())
    }

    private func ecranCuTitlu(_ titlu: String) -> some View {
        Text(titlu)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}
