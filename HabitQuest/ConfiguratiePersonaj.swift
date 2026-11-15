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

enum NuantaPar: String, CaseIterable, Identifiable {
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

enum NuantaLama: String, CaseIterable, Identifiable {
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

struct ConfiguratiePersonaj: Equatable {
    let nuantaPar: NuantaPar
    let nuantaLama: NuantaLama
}
