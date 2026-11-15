import SwiftUI

struct PanouEchipamentPersonaj: View {
    @Binding var personaj: Personaj
    @Environment(\.dismiss) private var inchide
    @State private var slotSelectat: SlotEchipament?

    private let grupuri = [
        GrupEchipament(id: "corp", titlu: "Corp si cap", sloturi: [.corp, .par, .casca]),
        GrupEchipament(id: "haine", titlu: "Armura si haine", sloturi: [.armura, .manusi, .pantaloni, .mantie, .incaltaminte]),
        GrupEchipament(id: "arme", titlu: "Arme si accesorii", sloturi: [.armaPrincipala, .armaSecundara, .accesoriu])
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(grupuri) { grup in
                    Section(grup.titlu) {
                        ForEach(grup.sloturi) { slot in
                            Button {
                                slotSelectat = slot
                            } label: {
                                HStack(spacing: 12) {
                                    Label(slot.titlu, systemImage: slot.simbol)
                                        .foregroundStyle(.primary)

                                    Spacer(minLength: 8)

                                    Text(numeEchipat(in: slot))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)

                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.tertiary)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint("Deschide obiectele disponibile pentru \(slot.titlu)")
                        }
                    }
                }
            }
            .navigationTitle("Echipament")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gata") {
                        inchide()
                    }
                }
            }
            .sheet(item: $slotSelectat) { slot in
                SelectorEchipament(
                    slot: slot,
                    personaj: personaj,
                    laEchipare: { obiect in
                        OperatiiEchipare.echipeaza(obiect, pe: &personaj)
                    },
                    laDezechipare: {
                        OperatiiEchipare.dezechipeaza(din: slot, dePe: &personaj)
                    }
                )
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func numeEchipat(in slot: SlotEchipament) -> String {
        if slot == .par {
            return personaj.aspect.nuantaPar.titlu
        }

        if let obiect = personaj.echipament.obiect(in: slot) {
            return CatalogEchipament.obiect(cu: obiect.identificatorObiect)?.nume
                ?? "Obiect indisponibil"
        }

        if slot == .accesoriu || slot == .armaSecundara {
            return "Liber"
        }

        return "Ilustratia de baza"
    }
}

private struct GrupEchipament: Identifiable {
    let id: String
    let titlu: String
    let sloturi: [SlotEchipament]
}
