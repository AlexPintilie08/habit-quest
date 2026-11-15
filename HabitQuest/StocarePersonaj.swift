import Foundation

enum StocarePersonaj {
    static let cheieConfiguratie = "personajCodificat"

    static func incarca(din defaults: UserDefaults = .standard) -> Personaj {
        if let date = defaults.data(forKey: cheieConfiguratie),
           let personaj = try? JSONDecoder().decode(Personaj.self, from: date) {
            var restaurat = personaj
            restaurat.echipament = restaurat.echipament.normalizata
            return restaurat
        }

        let nuantaPar = defaults.string(forKey: "nuantaPar")
            .flatMap(NuantaPar.init(rawValue:)) ?? .castaniu
        let nuantaLama = defaults.string(forKey: "nuantaLama")
            .flatMap(NuantaLama.init(rawValue:)) ?? .otel

        return Personaj(
            nume: defaults.string(forKey: "numeErou") ?? "Aventurier",
            aspect: AspectPersonaj(
                nuantaPar: nuantaPar,
                nuantaLama: nuantaLama
            )
        )
    }

    static func salveaza(
        _ personaj: Personaj,
        in defaults: UserDefaults = .standard
    ) {
        guard let date = try? JSONEncoder().encode(personaj) else {
            return
        }

        defaults.set(date, forKey: cheieConfiguratie)
        defaults.set(personaj.nume, forKey: "numeErou")
        defaults.set(personaj.aspect.nuantaPar.rawValue, forKey: "nuantaPar")
        defaults.set(personaj.aspect.nuantaLama.rawValue, forKey: "nuantaLama")
    }
}
