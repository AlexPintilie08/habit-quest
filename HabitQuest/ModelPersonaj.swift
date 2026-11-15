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

struct CodCuloare: Codable, Equatable, Hashable, Identifiable {
    let hex: String

    var id: String { hex }

    init(hex: String) {
        self.hex = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let valoare = try container.decode(String.self)

        if let legacy = CuloarePaleta(rawValue: valoare) {
            hex = legacy.codHex
            return
        }

        let normalizata = valoare
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        guard normalizata.count == 6, UInt32(normalizata, radix: 16) != nil else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Codul de culoare trebuie sa contina 6 cifre hexazecimale."
            )
        }

        hex = normalizata
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hex)
    }
}

struct TrasaturiPersonaj: Codable, Equatable {
    var inaltime: Double
    var tonPiele: TonPiele
    var coafura: Coafura
    var formaOchi: FormaOchi
    var culoareOchi: CuloareOchi
    var nuantaPiele: CodCuloare?
    var culoareOchiPersonalizata: CodCuloare?
    var identificatorTipCorp: String?
    var identificatorFormaFata: String?
    var identificatorCoafura: String?
    var identificatorFormaOchi: String?
    var identificatorSprancene: String?
    var identificatorBarba: String?
    var identificatoriDetalii: [String]

    init(
        inaltime: Double = 1,
        tonPiele: TonPiele = .deschis,
        coafura: Coafura = .ondulata,
        formaOchi: FormaOchi = .migdalati,
        culoareOchi: CuloareOchi = .caprui,
        nuantaPiele: CodCuloare? = nil,
        culoareOchiPersonalizata: CodCuloare? = nil,
        identificatorTipCorp: String? = nil,
        identificatorFormaFata: String? = nil,
        identificatorCoafura: String? = nil,
        identificatorFormaOchi: String? = nil,
        identificatorSprancene: String? = nil,
        identificatorBarba: String? = nil,
        identificatoriDetalii: [String] = []
    ) {
        self.inaltime = inaltime
        self.tonPiele = tonPiele
        self.coafura = coafura
        self.formaOchi = formaOchi
        self.culoareOchi = culoareOchi
        self.nuantaPiele = nuantaPiele
        self.culoareOchiPersonalizata = culoareOchiPersonalizata
        self.identificatorTipCorp = identificatorTipCorp
        self.identificatorFormaFata = identificatorFormaFata
        self.identificatorCoafura = identificatorCoafura
        self.identificatorFormaOchi = identificatorFormaOchi
        self.identificatorSprancene = identificatorSprancene
        self.identificatorBarba = identificatorBarba
        self.identificatoriDetalii = identificatoriDetalii
    }

    private enum CodingKeys: String, CodingKey {
        case inaltime
        case tonPiele
        case coafura
        case formaOchi
        case culoareOchi
        case nuantaPiele
        case culoareOchiPersonalizata
        case identificatorTipCorp
        case identificatorFormaFata
        case identificatorCoafura
        case identificatorFormaOchi
        case identificatorSprancene
        case identificatorBarba
        case identificatoriDetalii
    }

    init(from decoder: Decoder) throws {
        let valori = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            inaltime: try valori.decodeIfPresent(Double.self, forKey: .inaltime) ?? 1,
            tonPiele: try valori.decodeIfPresent(TonPiele.self, forKey: .tonPiele) ?? .deschis,
            coafura: try valori.decodeIfPresent(Coafura.self, forKey: .coafura) ?? .ondulata,
            formaOchi: try valori.decodeIfPresent(FormaOchi.self, forKey: .formaOchi) ?? .migdalati,
            culoareOchi: try valori.decodeIfPresent(CuloareOchi.self, forKey: .culoareOchi) ?? .caprui,
            nuantaPiele: try valori.decodeIfPresent(CodCuloare.self, forKey: .nuantaPiele),
            culoareOchiPersonalizata: try valori.decodeIfPresent(CodCuloare.self, forKey: .culoareOchiPersonalizata),
            identificatorTipCorp: try valori.decodeIfPresent(String.self, forKey: .identificatorTipCorp),
            identificatorFormaFata: try valori.decodeIfPresent(String.self, forKey: .identificatorFormaFata),
            identificatorCoafura: try valori.decodeIfPresent(String.self, forKey: .identificatorCoafura),
            identificatorFormaOchi: try valori.decodeIfPresent(String.self, forKey: .identificatorFormaOchi),
            identificatorSprancene: try valori.decodeIfPresent(String.self, forKey: .identificatorSprancene),
            identificatorBarba: try valori.decodeIfPresent(String.self, forKey: .identificatorBarba),
            identificatoriDetalii: try valori.decodeIfPresent([String].self, forKey: .identificatoriDetalii) ?? []
        )
    }
}

struct PaletaPersonaj: Codable, Equatable {
    var primara: CodCuloare
    var secundara: CodCuloare
    var accent: CodCuloare
    var primaraActiva: Bool
    var secundaraActiva: Bool
    var accentActiva: Bool

    init(
        primara: CodCuloare = CodCuloare(hex: "BFC6CC"),
        secundara: CodCuloare = CodCuloare(hex: "704A35"),
        accent: CodCuloare = CodCuloare(hex: "BD433B"),
        primaraActiva: Bool = false,
        secundaraActiva: Bool = false,
        accentActiva: Bool = false
    ) {
        self.primara = primara
        self.secundara = secundara
        self.accent = accent
        self.primaraActiva = primaraActiva
        self.secundaraActiva = secundaraActiva
        self.accentActiva = accentActiva
    }

    private enum CodingKeys: String, CodingKey {
        case primara
        case secundara
        case accent
        case primaraActiva
        case secundaraActiva
        case accentActiva
    }

    init(from decoder: Decoder) throws {
        let valori = try decoder.container(keyedBy: CodingKeys.self)
        let primaraSalvata = try valori.decodeIfPresent(CodCuloare.self, forKey: .primara)
        let secundaraSalvata = try valori.decodeIfPresent(CodCuloare.self, forKey: .secundara)
        let accentSalvata = try valori.decodeIfPresent(CodCuloare.self, forKey: .accent)
        let culoareaVecheImplicita = CuloarePaleta.ivoriu.codHex

        self.init(
            primara: primaraSalvata ?? CodCuloare(hex: "BFC6CC"),
            secundara: secundaraSalvata ?? CodCuloare(hex: "704A35"),
            accent: accentSalvata ?? CodCuloare(hex: "BD433B"),
            primaraActiva: try valori.decodeIfPresent(Bool.self, forKey: .primaraActiva)
                ?? (primaraSalvata != nil && primaraSalvata?.hex != culoareaVecheImplicita),
            secundaraActiva: try valori.decodeIfPresent(Bool.self, forKey: .secundaraActiva)
                ?? (secundaraSalvata != nil),
            accentActiva: try valori.decodeIfPresent(Bool.self, forKey: .accentActiva)
                ?? (accentSalvata != nil)
        )
    }
}

struct AspectPersonaj: Codable, Equatable {
    var nuantaPar: NuantaPar
    var nuantaLama: NuantaLama
    var culoarePrincipalaPar: CodCuloare?
    var culoareHighlightsPar: CodCuloare?

    init(
        nuantaPar: NuantaPar = .castaniu,
        nuantaLama: NuantaLama = .otel,
        culoarePrincipalaPar: CodCuloare? = nil,
        culoareHighlightsPar: CodCuloare? = nil
    ) {
        self.nuantaPar = nuantaPar
        self.nuantaLama = nuantaLama
        self.culoarePrincipalaPar = culoarePrincipalaPar
        self.culoareHighlightsPar = culoareHighlightsPar
    }

    static let implicit = AspectPersonaj(
        nuantaPar: .castaniu,
        nuantaLama: .otel
    )

    private enum CodingKeys: String, CodingKey {
        case nuantaPar
        case nuantaLama
        case culoarePrincipalaPar
        case culoareHighlightsPar
    }

    init(from decoder: Decoder) throws {
        let valori = try decoder.container(keyedBy: CodingKeys.self)
        nuantaPar = try valori.decodeIfPresent(NuantaPar.self, forKey: .nuantaPar) ?? .castaniu
        nuantaLama = try valori.decodeIfPresent(NuantaLama.self, forKey: .nuantaLama) ?? .otel
        culoarePrincipalaPar = try valori.decodeIfPresent(CodCuloare.self, forKey: .culoarePrincipalaPar)
        culoareHighlightsPar = try valori.decodeIfPresent(CodCuloare.self, forKey: .culoareHighlightsPar)
    }
}

struct Personaj: Codable, Equatable, Identifiable {
    let id: String
    var nume: String
    var clasa: ClasaPersonaj
    var gen: GenPersonaj
    var trasaturi: TrasaturiPersonaj
    var paleta: PaletaPersonaj
    var aspect: AspectPersonaj
    var echipament: ConfiguratieEchipament

    static let idPrincipal = "erou_principal"

    init(
        id: String = Personaj.idPrincipal,
        nume: String = "Aventurier",
        clasa: ClasaPersonaj = .razboinic,
        gen: GenPersonaj = .masculin,
        trasaturi: TrasaturiPersonaj = .init(),
        paleta: PaletaPersonaj = .init(),
        aspect: AspectPersonaj = .implicit,
        echipament: ConfiguratieEchipament = .initiala
    ) {
        self.id = id
        self.nume = nume
        self.clasa = clasa
        self.gen = gen
        self.trasaturi = trasaturi
        self.paleta = paleta
        self.aspect = aspect
        self.echipament = echipament.normalizata
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case nume
        case clasa
        case gen
        case trasaturi
        case paleta
        case aspect
        case echipament
    }

    init(from decoder: Decoder) throws {
        let valori = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            id: try valori.decodeIfPresent(String.self, forKey: .id) ?? Personaj.idPrincipal,
            nume: try valori.decodeIfPresent(String.self, forKey: .nume) ?? "Aventurier",
            clasa: try valori.decodeIfPresent(ClasaPersonaj.self, forKey: .clasa) ?? .razboinic,
            gen: try valori.decodeIfPresent(GenPersonaj.self, forKey: .gen) ?? .masculin,
            trasaturi: try valori.decodeIfPresent(TrasaturiPersonaj.self, forKey: .trasaturi) ?? .init(),
            paleta: try valori.decodeIfPresent(PaletaPersonaj.self, forKey: .paleta) ?? .init(),
            aspect: try valori.decodeIfPresent(AspectPersonaj.self, forKey: .aspect) ?? .implicit,
            echipament: try valori.decodeIfPresent(ConfiguratieEchipament.self, forKey: .echipament) ?? .initiala
        )
    }

    var idCorp: String {
        echipament.obiect(in: .corp)?.identificatorObiect ?? "corp_aventurier"
    }
}
