import Foundation

struct DefinitieEchipament: Codable, Equatable, Identifiable {
    var id: String
    var nume: String
    var tip: TipEchipament
    var slot: SlotEchipament
    var descriere: String?
    var asseturiVizuale: [ReferintaAsset]
    var compatibilitate: CompatibilitateEchipament
}

enum CatalogEchipament {
    static let obiecte: [DefinitieEchipament] = [
        DefinitieEchipament(
            id: "corp_aventurier",
            nume: "Aventurier",
            tip: .corp,
            slot: .corp,
            descriere: "Ilustratia actuala a personajului.",
            asseturiVizuale: [
                ReferintaAsset(identificator: "PersonajPlaceholderErou", ordine: 0)
            ],
            compatibilitate: .oricare
        ),
        DefinitieEchipament(
            id: "sabie_fier",
            nume: "Sabie de fier",
            tip: .arma,
            slot: .armaPrincipala,
            descriere: "Definitie demonstrativa fara sprite dedicat.",
            asseturiVizuale: [],
            compatibilitate: .oricare
        ),
        DefinitieEchipament(
            id: "sabie_bronz",
            nume: "Sabie de bronz",
            tip: .arma,
            slot: .armaPrincipala,
            descriere: "Definitie demonstrativa fara sprite dedicat.",
            asseturiVizuale: [],
            compatibilitate: .oricare
        ),
        DefinitieEchipament(
            id: "armura_piele",
            nume: "Armura de piele",
            tip: .armura,
            slot: .armura,
            descriere: "Definitie demonstrativa fara sprite dedicat.",
            asseturiVizuale: [],
            compatibilitate: .oricare
        )
    ]

    static func obiect(cu id: String) -> DefinitieEchipament? {
        obiecte.first { $0.id == id }
    }
}
