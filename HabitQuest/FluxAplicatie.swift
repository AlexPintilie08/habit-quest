import SwiftUI

private enum EtapaAplicatie {
    case bunVenit
    case autentificareDemo
    case acasa
}

struct FluxAplicatie: View {
    @State private var etapa = EtapaAplicatie.bunVenit

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
        .preferredColorScheme(.light)
    }
}
