import SwiftUI
import UIKit

struct RandarePersonaj: View {
    let personaj: Personaj
    let animatiePermisa: Bool
    var stare: StarePersonaj = .idle

    var body: some View {
        if animatiePermisa {
            straturi
                .phaseAnimator([false, true]) { continut, faza in
                    continut.offset(y: faza ? -1.5 : 0)
                } animation: { _ in
                    .easeInOut(duration: 2.4)
                }
        } else {
            straturi
        }
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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

        if personaj.aspect.nuantaPar.culoareSuprapunere != nil {
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

        if personaj.aspect.nuantaLama.culoareSuprapunere != nil {
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
        case .par: personaj.aspect.nuantaPar.culoareSuprapunere
        case .lama: personaj.aspect.nuantaLama.culoareSuprapunere
        case nil: nil
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
