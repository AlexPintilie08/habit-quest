import SwiftUI

enum CategoriaPersonalizare: String, CaseIterable, Identifiable {
    case par
    case haine
    case mantie
    case echipament

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .par: "Par"
        case .haine: "Haine"
        case .mantie: "Mantie"
        case .echipament: "Echipament"
        }
    }
}

enum NuantaPar: String, CaseIterable, Codable, Identifiable {
    case castaniu
    case auriu

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .castaniu: "Castaniu"
        case .auriu: "Auriu"
        }
    }

    var culoareSwatch: Color {
        switch self {
        case .castaniu: Color(red: 0.43, green: 0.23, blue: 0.13)
        case .auriu: Color(red: 0.88, green: 0.55, blue: 0.18)
        }
    }

    var culoareSuprapunere: Color? {
        switch self {
        case .castaniu: nil
        case .auriu: Color(red: 0.88, green: 0.55, blue: 0.18)
        }
    }
}

enum NuantaLama: String, CaseIterable, Codable, Identifiable {
    case otel
    case azuriu

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .otel: "Otel"
        case .azuriu: "Azuriu"
        }
    }

    var culoareSwatch: Color {
        switch self {
        case .otel: Color(red: 0.72, green: 0.75, blue: 0.78)
        case .azuriu: Color(red: 0.25, green: 0.48, blue: 0.82)
        }
    }

    var culoareSuprapunere: Color? {
        switch self {
        case .otel: nil
        case .azuriu: Color(red: 0.25, green: 0.48, blue: 0.82)
        }
    }
}

enum GenPersonaj: String, CaseIterable, Codable, Identifiable {
    case masculin
    case feminin

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .masculin: "Masculin"
        case .feminin: "Feminin"
        }
    }
}

enum TonPiele: String, CaseIterable, Codable, Identifiable {
    case foarteDeschis
    case deschis
    case mediu
    case masliniu
    case inchis

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .foarteDeschis: "Foarte deschis"
        case .deschis: "Deschis"
        case .mediu: "Mediu"
        case .masliniu: "Masliniu"
        case .inchis: "Inchis"
        }
    }
}

enum Coafura: String, CaseIterable, Codable, Identifiable {
    case scurta
    case ondulata
    case lunga

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .scurta: "Scurta"
        case .ondulata: "Ondulata"
        case .lunga: "Lunga"
        }
    }
}

enum FormaOchi: String, CaseIterable, Codable, Identifiable {
    case rotunzi
    case migdalati
    case ingusti

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .rotunzi: "Rotunzi"
        case .migdalati: "Migdalati"
        case .ingusti: "Ingusti"
        }
    }
}

enum CuloareOchi: String, CaseIterable, Codable, Identifiable {
    case caprui
    case verzi
    case albastri
    case gri

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .caprui: "Caprui"
        case .verzi: "Verzi"
        case .albastri: "Albastri"
        case .gri: "Gri"
        }
    }
}

enum CuloarePaleta: String, CaseIterable, Codable, Identifiable {
    case ivoriu
    case maro
    case rosu
    case verde
    case albastru
    case auriu

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .ivoriu: "Ivoriu"
        case .maro: "Maro"
        case .rosu: "Rosu"
        case .verde: "Verde"
        case .albastru: "Albastru"
        case .auriu: "Auriu"
        }
    }

    var culoare: Color {
        switch self {
        case .ivoriu: Color(red: 0.91, green: 0.84, blue: 0.70)
        case .maro: Color(red: 0.43, green: 0.27, blue: 0.18)
        case .rosu: Color(red: 0.74, green: 0.20, blue: 0.17)
        case .verde: Color(red: 0.31, green: 0.48, blue: 0.30)
        case .albastru: Color(red: 0.25, green: 0.43, blue: 0.67)
        case .auriu: Color(red: 0.83, green: 0.57, blue: 0.17)
        }
    }
}

struct TrasaturiPersonaj: Codable, Equatable {
    var inaltime = 1.0
    var tonPiele: TonPiele = .deschis
    var coafura: Coafura = .ondulata
    var formaOchi: FormaOchi = .migdalati
    var culoareOchi: CuloareOchi = .caprui
}

struct PaletaPersonaj: Codable, Equatable {
    var primara: CuloarePaleta = .ivoriu
    var secundara: CuloarePaleta = .maro
    var accent: CuloarePaleta = .rosu
}

struct ConfiguratiePersonaj: Equatable {
    let nuantaPar: NuantaPar
    let nuantaLama: NuantaLama
}
