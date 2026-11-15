import Foundation

enum CategoriaPersonalizare: String, CaseIterable, Identifiable {
    case corp
    case piele
    case fata
    case par
    case ochi
    case sprancene
    case barba
    case detalii
    case culoriEchipament

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .corp: "Corp"
        case .piele: "Piele"
        case .fata: "Fata"
        case .par: "Par"
        case .ochi: "Ochi"
        case .sprancene: "Sprancene"
        case .barba: "Barba"
        case .detalii: "Detalii"
        case .culoriEchipament: "Culori echipament"
        }
    }

    var stare: StarePersonalizare {
        switch self {
        case .corp, .piele, .ochi: .pregatitaPentruViitor
        case .par, .culoriEchipament: .functionala
        case .fata, .sprancene, .barba, .detalii: .indisponibila
        }
    }

    var incadrare: IncadrarePersonaj {
        switch self {
        case .par, .ochi, .fata, .sprancene, .barba, .detalii: .fata
        case .corp, .piele, .culoriEchipament: .completa
        }
    }
}

enum IncadrarePersonaj: Equatable {
    case completa
    case fata
}

enum StarePersonalizare {
    case functionala
    case pregatitaPentruViitor
    case indisponibila

    var titlu: String {
        switch self {
        case .functionala: "Functionala"
        case .pregatitaPentruViitor: "Pregatita pentru viitor"
        case .indisponibila: "Inca indisponibila"
        }
    }

    var simbol: String {
        switch self {
        case .functionala: "checkmark.circle"
        case .pregatitaPentruViitor: "clock"
        case .indisponibila: "eye.slash"
        }
    }
}

enum SubtonPiele: String, CaseIterable, Identifiable {
    case cald
    case neutru
    case rece

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .cald: "Cald"
        case .neutru: "Neutru"
        case .rece: "Rece"
        }
    }
}

enum FamilieCuloarePar: String, CaseIterable, Identifiable {
    case naturale
    case blond
    case saten
    case brunet
    case roscat
    case griAlb
    case fantasy

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .naturale: "Naturale"
        case .blond: "Blond"
        case .saten: "Saten"
        case .brunet: "Brunet"
        case .roscat: "Roscat"
        case .griAlb: "Gri si alb"
        case .fantasy: "Fantasy"
        }
    }
}

enum FamilieCuloareOchi: String, CaseIterable, Identifiable {
    case naturale
    case fantasy

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .naturale: "Naturale"
        case .fantasy: "Fantasy"
        }
    }
}

enum FamilieCuloareEchipament: String, CaseIterable, Identifiable {
    case metale
    case pieleSiLemn
    case textile
    case fantasy

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .metale: "Metale"
        case .pieleSiLemn: "Piele si lemn"
        case .textile: "Textile"
        case .fantasy: "Fantasy"
        }
    }
}

struct OptiuneCuloarePersonaj: Identifiable, Equatable {
    let id: String
    let nume: String
    let culoare: CodCuloare
}

struct OptiuneGraficaPersonaj: Identifiable, Equatable {
    let id: String
    let nume: String
    let asset: String?
    let miniatura: String?
}

enum CatalogPersonalizare {
    static let coafuri: [OptiuneGraficaPersonaj] = []
    static let formeCorp: [OptiuneGraficaPersonaj] = []
    static let formeFata: [OptiuneGraficaPersonaj] = []
    static let formeOchi: [OptiuneGraficaPersonaj] = []
    static let sprancene: [OptiuneGraficaPersonaj] = []
    static let barbi: [OptiuneGraficaPersonaj] = []
    static let detalii: [OptiuneGraficaPersonaj] = []

    static let culoriPar: [OptiuneCuloarePersonaj] =
        rampa("par-natural", "Natural", ["34231C", "68422D", "A66A42", "D4A071"], 8)
        + rampa("par-blond", "Blond", ["60401F", "A47536", "D5AC5B", "F2D995"], 8)
        + rampa("par-saten", "Saten", ["33221B", "63402D", "94613E", "C08A5D"], 8)
        + rampa("par-brunet", "Brunet", ["100F13", "211916", "382922", "594334"], 8)
        + rampa("par-roscat", "Roscat", ["4A2119", "81391F", "B9572B", "E39A5B"], 8)
        + rampa("par-gri-alb", "Gri si alb", ["45464F", "777983", "B6B9C0", "F2EEE8"], 8)
        + rampa("par-fantasy", "Fantasy", ["263F9E", "7139B9", "D04AA7", "ED5C65", "F0A23F", "48A46D", "28A3B7", "627EE8"], 16)

    static let culoriPieleCald = rampa(
        "piele-cald",
        "Cald",
        ["F7E5D0", "E9C8A9", "D8A985", "C58A66", "AC6B4D", "8C4E38", "633829", "39221A"],
        18
    )

    static let culoriPieleNeutru = rampa(
        "piele-neutru",
        "Neutru",
        ["F5E5DB", "E7C9B9", "D7A991", "C48B70", "A96B55", "89503F", "633A30", "3B2824"],
        18
    )

    static let culoriPieleRece = rampa(
        "piele-rece",
        "Rece",
        ["F0E2DE", "E1C6C0", "D0A69F", "B9877E", "9F685F", "7E4C46", "5B3835", "392727"],
        18
    )

    static let culoriOchiNaturale = rampa(
        "ochi-natural",
        "Natural",
        ["291B18", "80512B", "C08A3A", "638549", "3C8A82", "4479B2", "8293A2"],
        20
    )

    static let culoriOchiFantasy = rampa(
        "ochi-fantasy",
        "Fantasy",
        ["4D2CA0", "B13E9C", "E45E73", "E6AA38", "61AE53", "27A8A7", "3976D2"],
        20
    )

    static let culoriEchipamentMetale = rampa(
        "echipament-metal",
        "Metal",
        ["464D58", "9CA4AE", "E6D9B8", "B87834", "8F3D31"],
        12
    )

    static let culoriEchipamentPieleSiLemn = rampa(
        "echipament-lemn",
        "Piele si lemn",
        ["33231D", "68442F", "A7754C", "D2A46E", "76513A"],
        12
    )

    static let culoriEchipamentTextile = rampa(
        "echipament-textil",
        "Textile",
        ["6F2530", "B34B3B", "D39A54", "477453", "38629A", "584477"],
        12
    )

    static let culoriEchipamentFantasy = rampa(
        "echipament-fantasy",
        "Fantasy",
        ["382A95", "A63FA9", "DA4B76", "EF9C42", "4AA36B", "2A93AE", "547DE2"],
        12
    )

    static func culoriPiele(pentru subton: SubtonPiele) -> [OptiuneCuloarePersonaj] {
        switch subton {
        case .cald: culoriPieleCald
        case .neutru: culoriPieleNeutru
        case .rece: culoriPieleRece
        }
    }

    static func culoriPar(pentru familie: FamilieCuloarePar) -> [OptiuneCuloarePersonaj] {
        let prefix: String

        switch familie {
        case .naturale: prefix = "par-natural-"
        case .griAlb: prefix = "par-gri-alb-"
        case .blond, .saten, .brunet, .roscat, .fantasy:
            prefix = "par-\(familie.rawValue)-"
        }

        return culoriPar.filter { $0.id.hasPrefix(prefix) }
    }

    static func culoriOchi(pentru familie: FamilieCuloareOchi) -> [OptiuneCuloarePersonaj] {
        let prefix = familie == .naturale ? "ochi-natural-" : "ochi-fantasy-"
        return (familie == .naturale ? culoriOchiNaturale : culoriOchiFantasy)
            .filter { $0.id.hasPrefix(prefix) }
    }

    static func culoriEchipament(pentru familie: FamilieCuloareEchipament) -> [OptiuneCuloarePersonaj] {
        let prefix: String
        let culori: [OptiuneCuloarePersonaj]

        switch familie {
        case .metale:
            prefix = "echipament-metal-"
            culori = culoriEchipamentMetale
        case .pieleSiLemn:
            prefix = "echipament-lemn-"
            culori = culoriEchipamentPieleSiLemn
        case .textile:
            prefix = "echipament-textil-"
            culori = culoriEchipamentTextile
        case .fantasy:
            prefix = "echipament-fantasy-"
            culori = culoriEchipamentFantasy
        }

        return culori.filter { $0.id.hasPrefix(prefix) }
    }

    private static func rampa(
        _ prefix: String,
        _ numeGrup: String,
        _ ancore: [String],
        _ numar: Int
    ) -> [OptiuneCuloarePersonaj] {
        guard ancore.count >= 2, numar > 1 else { return [] }

        return (0..<numar).map { index in
            let pozitie = Double(index) / Double(numar - 1) * Double(ancore.count - 1)
            let segment = min(Int(pozitie), ancore.count - 2)
            let fractie = pozitie - Double(segment)
            let stanga = UInt32(ancore[segment], radix: 16) ?? 0
            let dreapta = UInt32(ancore[segment + 1], radix: 16) ?? 0
            let rosu = amesteca((stanga >> 16) & 0xFF, (dreapta >> 16) & 0xFF, fractie)
            let verde = amesteca((stanga >> 8) & 0xFF, (dreapta >> 8) & 0xFF, fractie)
            let albastru = amesteca(stanga & 0xFF, dreapta & 0xFF, fractie)
            let hex = String(format: "%02X%02X%02X", rosu, verde, albastru)
            let numarNuanta = index < 9 ? "0\(index + 1)" : "\(index + 1)"

            return OptiuneCuloarePersonaj(
                id: "\(prefix)-\(numarNuanta)",
                nume: "\(numeGrup) \(numarNuanta)",
                culoare: CodCuloare(hex: hex)
            )
        }
    }

    private static func amesteca(_ stanga: UInt32, _ dreapta: UInt32, _ fractie: Double) -> UInt32 {
        UInt32((Double(stanga) + (Double(dreapta) - Double(stanga)) * fractie).rounded())
    }
}
