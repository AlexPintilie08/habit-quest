import Foundation

enum ClasaPersonaj: String, CaseIterable, Codable, Identifiable {
    case razboinic
    case mag
    case arcas
    case paladin

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .razboinic: "Razboinic"
        case .mag: "Mag"
        case .arcas: "Arcas"
        case .paladin: "Paladin"
        }
    }
}

enum TipEchipament: String, Codable {
    case corp
    case par
    case casca
    case armura
    case manusi
    case pantaloni
    case incaltaminte
    case mantie
    case arma
    case scut
    case accesoriu
}

enum SlotEchipament: String, CaseIterable, Codable, Identifiable {
    case corp
    case par
    case casca
    case armura
    case manusi
    case pantaloni
    case incaltaminte
    case mantie
    case armaPrincipala
    case armaSecundara
    case accesoriu

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .corp: "Corp"
        case .par: "Par"
        case .casca: "Casca"
        case .armura: "Armura"
        case .manusi: "Manusi"
        case .pantaloni: "Pantaloni"
        case .incaltaminte: "Incaltaminte"
        case .mantie: "Mantie"
        case .armaPrincipala: "Arma principala"
        case .armaSecundara: "Arma secundara / scut"
        case .accesoriu: "Accesoriu"
        }
    }

    var simbol: String {
        switch self {
        case .corp: "person.fill"
        case .par: "scissors"
        case .casca: "crown.fill"
        case .armura: "tshirt.fill"
        case .manusi: "hand.raised.fill"
        case .pantaloni: "figure.stand"
        case .incaltaminte: "shoe"
        case .mantie: "wind"
        case .armaPrincipala: "sword"
        case .armaSecundara: "shield"
        case .accesoriu: "sparkle"
        }
    }

    var tipuriAcceptate: Set<TipEchipament> {
        switch self {
        case .corp: [.corp]
        case .par: [.par]
        case .casca: [.casca]
        case .armura: [.armura]
        case .manusi: [.manusi]
        case .pantaloni: [.pantaloni]
        case .incaltaminte: [.incaltaminte]
        case .mantie: [.mantie]
        case .armaPrincipala: [.arma]
        case .armaSecundara: [.arma, .scut]
        case .accesoriu: [.accesoriu]
        }
    }

    var permiteDezechipare: Bool {
        self != .corp
    }

    var ordineDesenare: Int {
        switch self {
        case .corp: 0
        case .mantie: 10
        case .incaltaminte: 20
        case .pantaloni: 30
        case .armura: 40
        case .manusi: 50
        case .armaSecundara: 60
        case .armaPrincipala: 70
        case .accesoriu: 80
        case .par: 90
        case .casca: 100
        }
    }
}

enum StarePersonaj: String, Codable {
    case idle
    case mers
    case atac
    case victorie
}

enum NuantareStrat: String, Codable {
    case par
    case lama
}

struct TransformareStrat: Codable, Equatable {
    var deplasareXRelativa: Double = 0
    var deplasareYRelativa: Double = 0
    var scalare: Double = 1
    var ancoraXNormalizata: Double = 0.5
    var ancoraYNormalizata: Double = 0.5

    static let implicita = TransformareStrat()
}

struct ReferintaAsset: Codable, Equatable, Identifiable {
    var identificator: String
    var ordine: Int?
    var transformare: TransformareStrat
    var stare: StarePersonaj?
    var nuantare: NuantareStrat?

    var id: String {
        "\(stare?.rawValue ?? "toate")-\(identificator)"
    }

    init(
        identificator: String,
        ordine: Int? = nil,
        transformare: TransformareStrat = .implicita,
        stare: StarePersonaj? = nil,
        nuantare: NuantareStrat? = nil
    ) {
        self.identificator = identificator
        self.ordine = ordine
        self.transformare = transformare
        self.stare = stare
        self.nuantare = nuantare
    }
}

struct CompatibilitateEchipament: Codable, Equatable {
    var corpuriPermise: Set<String>?
    var clasePermise: Set<ClasaPersonaj>?

    static let oricare = CompatibilitateEchipament(
        corpuriPermise: nil,
        clasePermise: nil
    )
}

struct ObiectEchipat: Codable, Equatable, Identifiable {
    var slot: SlotEchipament
    var identificatorObiect: String

    var id: String {
        "\(slot.rawValue):\(identificatorObiect)"
    }
}

struct ConfiguratieEchipament: Codable, Equatable {
    var obiecteEchipate: [ObiectEchipat]

    static let initiala = ConfiguratieEchipament(
        obiecteEchipate: [
            ObiectEchipat(slot: .corp, identificatorObiect: "corp_aventurier")
        ]
    )

    func obiect(in slot: SlotEchipament) -> ObiectEchipat? {
        obiecteEchipate.last { $0.slot == slot }
    }

    var normalizata: ConfiguratieEchipament {
        var obiectePeSlot = [SlotEchipament: ObiectEchipat]()

        for obiect in obiecteEchipate {
            obiectePeSlot[obiect.slot] = obiect
        }

        return ConfiguratieEchipament(
            obiecteEchipate: SlotEchipament.allCases.compactMap { obiectePeSlot[$0] }
        )
    }
}

struct AspectPersonaj: Codable, Equatable {
    var nuantaPar: NuantaPar
    var nuantaLama: NuantaLama

    static let implicit = AspectPersonaj(
        nuantaPar: .castaniu,
        nuantaLama: .otel
    )
}

struct Personaj: Codable, Equatable, Identifiable {
    let id: String
    var nume: String
    var clasa: ClasaPersonaj
    var aspect: AspectPersonaj
    var echipament: ConfiguratieEchipament

    static let idPrincipal = "erou_principal"

    init(
        id: String = Personaj.idPrincipal,
        nume: String = "Aventurier",
        clasa: ClasaPersonaj = .razboinic,
        aspect: AspectPersonaj = .implicit,
        echipament: ConfiguratieEchipament = .initiala
    ) {
        self.id = id
        self.nume = nume
        self.clasa = clasa
        self.aspect = aspect
        self.echipament = echipament.normalizata
    }

    var idCorp: String {
        echipament.obiect(in: .corp)?.identificatorObiect ?? "corp_aventurier"
    }
}
