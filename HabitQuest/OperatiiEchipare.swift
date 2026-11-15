import Foundation

enum OperatiiEchipare {
    static func obiecteCompatibile(
        cu slot: SlotEchipament,
        pentru personaj: Personaj,
        din catalog: [DefinitieEchipament] = CatalogEchipament.obiecte
    ) -> [DefinitieEchipament] {
        catalog.filter { esteCompatibil($0, cu: slot, pentru: personaj) }
    }

    static func esteCompatibil(
        _ obiect: DefinitieEchipament,
        cu slot: SlotEchipament,
        pentru personaj: Personaj
    ) -> Bool {
        guard obiect.slot == slot,
              slot.tipuriAcceptate.contains(obiect.tip) else {
            return false
        }

        if slot != .corp,
           let corpuri = obiect.compatibilitate.corpuriPermise,
           !corpuri.contains(personaj.idCorp) {
            return false
        }

        if let clase = obiect.compatibilitate.clasePermise,
           !clase.contains(personaj.clasa) {
            return false
        }

        return true
    }

    @discardableResult
    static func echipeaza(
        _ obiect: DefinitieEchipament,
        pe personaj: inout Personaj
    ) -> Bool {
        guard esteCompatibil(obiect, cu: obiect.slot, pentru: personaj) else {
            return false
        }

        personaj.echipament.obiecteEchipate.removeAll { $0.slot == obiect.slot }
        personaj.echipament.obiecteEchipate.append(
            ObiectEchipat(slot: obiect.slot, identificatorObiect: obiect.id)
        )
        personaj.echipament = personaj.echipament.normalizata
        return true
    }

    @discardableResult
    static func dezechipeaza(
        din slot: SlotEchipament,
        dePe personaj: inout Personaj
    ) -> Bool {
        guard slot.permiteDezechipare,
              personaj.echipament.obiect(in: slot) != nil else {
            return false
        }

        personaj.echipament.obiecteEchipate.removeAll { $0.slot == slot }
        return true
    }

    static func obiectEchipat(
        in slot: SlotEchipament,
        pentru personaj: Personaj,
        din catalog: [DefinitieEchipament] = CatalogEchipament.obiecte
    ) -> DefinitieEchipament? {
        guard let id = personaj.echipament.obiect(in: slot)?.identificatorObiect else {
            return nil
        }

        return catalog.first { $0.id == id }
    }

    static func esteVizualCompatibil(
        _ obiect: DefinitieEchipament,
        cu personaj: Personaj
    ) -> Bool {
        esteCompatibil(obiect, cu: obiect.slot, pentru: personaj)
    }
}
