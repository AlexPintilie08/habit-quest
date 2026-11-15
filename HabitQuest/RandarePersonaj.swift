import SwiftUI
import UIKit

struct RandarePersonaj: View {
    let personaj: Personaj
    let animatiePermisa: Bool
    var incadrare: IncadrarePersonaj = .completa
    var stare: StarePersonaj = .idle

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        straturi
            .phaseAnimator([false, true]) { continut, faza in
                continut.offset(y: animatiePermisa && faza ? -1.5 : 0)
            } animation: { _ in
                animatiePermisa ? .easeInOut(duration: 2.4) : nil
            }
            .animation(
                reduceMotion ? nil : .easeInOut(duration: 0.22),
                value: incadrare
            )
    }

    private var straturi: some View {
        GeometryReader { geometrie in
            ZStack {
                ForEach(straturiRandate) { strat in
                    if let imagine = UIImage(named: strat.asset.identificator) {
                        continut(imagine, pentru: strat, dimensiune: geometrie.size)
                    }
                }
            }
            .frame(width: geometrie.size.width, height: geometrie.size.height)
            .scaleEffect(incadrare == .fata ? 2.1 : 1, anchor: .center)
            .offset(y: incadrare == .fata ? geometrie.size.height * 0.74 : 0)
            .frame(width: geometrie.size.width, height: geometrie.size.height)
            .clipped()
        }
        .compositingGroup()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Personajul \(personaj.nume)")
    }

    private var straturiRandate: [StratRandat] {
        let corpEchipat = OperatiiEchipare.obiectEchipat(
            in: .corp,
            pentru: personaj
        )
        let stratCorp = corpEchipat?.asseturiVizuale.first {
            esteDisponibil($0) && ($0.stare == nil || $0.stare == stare)
        } ?? ReferintaAsset(identificator: "PersonajBaza", ordine: 0)

        var straturi = [StratRandat(
            id: "corp-\(stratCorp.id)",
            asset: stratCorp,
            slot: .corp
        )]

        if personaj.aspect.culoarePrincipalaPar != nil
            || personaj.aspect.nuantaPar.culoareSuprapunere != nil {
            straturi.append(
                StratRandat(
                    id: "masca-par",
                    asset: ReferintaAsset(
                        identificator: "MascaPar",
                        nuantare: .par
                    ),
                    slot: .par
                )
            )
        }

        if personaj.paleta.primaraActiva
            || personaj.aspect.nuantaLama.culoareSuprapunere != nil {
            straturi.append(
                StratRandat(
                    id: "masca-lama",
                    asset: ReferintaAsset(
                        identificator: "MascaLama",
                        nuantare: .lama
                    ),
                    slot: .armaPrincipala
                )
            )
        }

        for obiectEchipat in personaj.echipament.obiecteEchipate
        where obiectEchipat.slot != .corp {
            guard let definitie = CatalogEchipament.obiect(cu: obiectEchipat.identificatorObiect),
                  OperatiiEchipare.esteVizualCompatibil(definitie, cu: personaj) else {
                continue
            }

            for asset in definitie.asseturiVizuale where esteDisponibil(asset) {
                straturi.append(
                    StratRandat(
                        id: "\(definitie.id)-\(asset.id)",
                        asset: asset,
                        slot: definitie.slot
                    )
                )
            }
        }

        return straturi
            .filter { $0.asset.stare == nil || $0.asset.stare == stare }
            .sorted { $0.ordine < $1.ordine }
    }

    private func esteDisponibil(_ asset: ReferintaAsset) -> Bool {
        UIImage(named: asset.identificator) != nil
    }

    @ViewBuilder
    private func continut(
        _ imagine: UIImage,
        pentru strat: StratRandat,
        dimensiune: CGSize
    ) -> some View {
        let transformare = strat.asset.transformare

        Group {
            if let culoare = culoarePentru(strat.asset.nuantare) {
                Image(uiImage: imagine)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(culoare)
                    .blendMode(.color)
            } else {
                Image(uiImage: imagine)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: dimensiune.width, height: dimensiune.height)
        .scaleEffect(
            transformare.scalare,
            anchor: UnitPoint(
                x: transformare.ancoraXNormalizata,
                y: transformare.ancoraYNormalizata
            )
        )
        .offset(
            x: dimensiune.width * transformare.deplasareXRelativa,
            y: dimensiune.height * transformare.deplasareYRelativa
        )
        .zIndex(Double(strat.ordine))
    }

    private func culoarePentru(_ nuantare: NuantareStrat?) -> Color? {
        switch nuantare {
        case .par:
            personaj.aspect.culoarePrincipalaPar?.culoareSwiftUI
                ?? personaj.aspect.nuantaPar.culoareSuprapunere
        case .lama:
            personaj.paleta.primaraActiva
                ? personaj.paleta.primara.culoareSwiftUI
                : personaj.aspect.nuantaLama.culoareSuprapunere
        case nil: nil
        }
    }
}

extension CodCuloare {
    var culoareSwiftUI: Color {
        let valoare = UInt32(hex, radix: 16) ?? 0

        return Color(
            .sRGB,
            red: Double((valoare >> 16) & 0xFF) / 255,
            green: Double((valoare >> 8) & 0xFF) / 255,
            blue: Double(valoare & 0xFF) / 255,
            opacity: 1
        )
    }

    init(culoare: Color) {
        let culoareUIKit = UIColor(culoare)
        var rosu: CGFloat = 0
        var verde: CGFloat = 0
        var albastru: CGFloat = 0
        var opacitate: CGFloat = 0

        if culoareUIKit.getRed(&rosu, green: &verde, blue: &albastru, alpha: &opacitate) {
            self.init(
                hex: String(
                    format: "%02X%02X%02X",
                    Int((rosu * 255).rounded()),
                    Int((verde * 255).rounded()),
                    Int((albastru * 255).rounded())
                )
            )
        } else {
            self.init(hex: "BFC6CC")
        }
    }
}

private struct StratRandat: Identifiable {
    let id: String
    let asset: ReferintaAsset
    let slot: SlotEchipament

    var ordine: Int {
        asset.ordine ?? slot.ordineDesenare
    }
}
