import SwiftUI

struct IndicatorPaginare: View {
    let paginaActiva: Int
    let numarPagini: Int
    let progres: Double

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numarPagini, id: \.self) { index in
                if index == paginaActiva {
                    GeometryReader { geometrie in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.black.opacity(0.2))

                            Capsule()
                                .fill(Color.black)
                                .frame(width: geometrie.size.width * progres)
                        }
                    }
                    .frame(width: 40, height: 6)
                } else {
                    Circle()
                        .fill(Color.black.opacity(0.25))
                        .frame(width: 6, height: 6)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progres onboarding")
        .accessibilityValue("Pagina \(paginaActiva + 1) din \(numarPagini)")
    }
}
