import SwiftUI
import UIKit

struct SelectorEchipament: View {
    let slot: SlotEchipament
    let personaj: Personaj
    let laEchipare: (DefinitieEchipament) -> Void
    let laDezechipare: () -> Void

    @Environment(\.dismiss) private var inchide

    private var obiecteDisponibile: [DefinitieEchipament] {
        OperatiiEchipare.obiecteCompatibile(cu: slot, pentru: personaj)
    }

    private var obiectEchipat: ObiectEchipat? {
        personaj.echipament.obiect(in: slot)
    }

    var body: some View {
        NavigationStack {
            List {
                if let obiectEchipat {
                    SectiuneEchipat(obiect: obiectEchipat)
                }

                Section("Obiecte disponibile") {
                    if obiecteDisponibile.isEmpty {
                        ContentUnavailableView(
                            "Niciun obiect disponibil",
                            systemImage: slot.simbol,
                            description: Text(mesajGol)
                        )
                    } else {
                        ForEach(obiecteDisponibile) { obiect in
                            butonObiect(obiect)
                        }
                    }
                }

                if slot.permiteDezechipare, obiectEchipat != nil {
                    Section {
                        Button("Dezechipeaza", role: .destructive) {
                            laDezechipare()
                            inchide()
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(CuloriHabitQuest.fundalPrincipal)
            .navigationTitle(slot.titlu)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Inchide") {
                        inchide()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var mesajGol: String {
        if slot == .par {
            return "Nu sunt coafuri disponibile. Poti schimba nuanta parului din panoul Aspect."
        }

        return "Obiectele pentru acest slot vor aparea aici cand vor fi adaugate in catalog."
    }

    private func butonObiect(_ obiect: DefinitieEchipament) -> some View {
        let selectat = obiectEchipat?.identificatorObiect == obiect.id

        return Button {
            laEchipare(obiect)
            inchide()
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(obiect.nume)
                        .foregroundStyle(.primary)

                    if !arePrevizualizare(obiect) {
                        Label("Previzualizare indisponibila", systemImage: "eye.slash")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if selectat {
                    Image(systemName: "checkmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(.tint)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selectat ? .isSelected : [])
    }

    private func arePrevizualizare(_ obiect: DefinitieEchipament) -> Bool {
        obiect.asseturiVizuale.contains {
            UIImage(named: $0.identificator) != nil
        }
    }
}

private struct SectiuneEchipat: View {
    let obiect: ObiectEchipat

    private var definitie: DefinitieEchipament? {
        CatalogEchipament.obiect(cu: obiect.identificatorObiect)
    }

    var body: some View {
        Section("Echipat acum") {
            VStack(alignment: .leading, spacing: 5) {
                Text(definitie?.nume ?? "Obiect indisponibil")

                if let definitie,
                   !definitie.asseturiVizuale.contains(where: { UIImage(named: $0.identificator) != nil }) {
                    Label("Previzualizare indisponibila", systemImage: "eye.slash")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
