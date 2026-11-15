import SwiftUI

private enum EtapaAplicatie {
    case bunVenit
    case autentificareDemo
    case acasa
}

struct FluxAplicatie: View {
    @State private var etapa = EtapaAplicatie.bunVenit
    @AppStorage("temaAplicatie") private var temaAplicatie = TemaAplicatie.sistem.rawValue

    var body: some View {
        Group {
            switch etapa {
            case .bunVenit:
                EcranBunVenit {
                    etapa = .autentificareDemo
                }
            case .autentificareDemo:
                EcranAutentificareDemo {
                    etapa = .acasa
                }
            case .acasa:
                EcranAcasa()
            }
        }
        .preferredColorScheme(TemaAplicatie(rawValue: temaAplicatie)?.schemaCulori)
    }
}
