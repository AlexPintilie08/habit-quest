import SwiftUI

struct EcranPersonaj: View {
    let esteActiv: Bool

    @State private var personaj = StocarePersonaj.incarca()
    @AppStorage("animatiiActive") private var animatiiActive = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var stareAplicatie
    @State private var categorie = CategoriaPersonalizare.par
    @State private var slotSelectat: SlotEchipament?
    @State private var afiseazaEditareNume = false
    @State private var numeTemporar = ""

    private var animatiaEstePermisa: Bool {
        esteActiv && animatiiActive && !reduceMotion && stareAplicatie == .active
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometrie in
                ScrollView {
                    VStack(spacing: 16) {
                        antet

                        RandarePersonaj(
                            personaj: personaj,
                            animatiePermisa: animatiaEstePermisa
                        )
                        .frame(height: min(max(geometrie.size.height * 0.42, 280), 390))
                        .frame(maxWidth: .infinity)

                        Picker("Categorie", selection: $categorie) {
                            ForEach(CategoriaPersonalizare.allCases) { optiune in
                                Text(optiune.titlu).tag(optiune)
                            }
                        }
                        .pickerStyle(.segmented)

                        optiuniCategorii
                        zonaEchipament
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .frame(maxWidth: 520)
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)
            }
            .background(CuloriHabitQuest.fundalPrincipal)
            .navigationTitle("Character")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Editeaza numele eroului", isPresented: $afiseazaEditareNume) {
                TextField("Numele eroului", text: $numeTemporar)
                    .textInputAutocapitalization(.words)
                Button("Anuleaza", role: .cancel) { }
                Button("Salveaza", action: salveazaNumele)
            } message: {
                Text("Alege numele care va aparea pe ecranul Character.")
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
            .onChange(of: personaj) { _, personajActualizat in
                StocarePersonaj.salveaza(personajActualizat)
            }
        }
    }

    private var antet: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 10) {
                Text(personaj.nume)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)

                Button {
                    numeTemporar = personaj.nume
                    afiseazaEditareNume = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Editeaza numele eroului")

                Spacer()
            }

            Label(personaj.clasa.titlu, systemImage: "shield.lefthalf.filled")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var optiuniCategorii: some View {
        switch categorie {
        case .par:
            Picker("Culoarea parului", selection: $personaj.aspect.nuantaPar) {
                ForEach(NuantaPar.allCases) { nuanta in
                    Text(nuanta.titlu).tag(nuanta)
                }
            }
            .pickerStyle(.segmented)
        case .echipament:
            Picker("Culoarea lamei", selection: $personaj.aspect.nuantaLama) {
                ForEach(NuantaLama.allCases) { nuanta in
                    Text(nuanta.titlu).tag(nuanta)
                }
            }
            .pickerStyle(.segmented)
        case .haine, .mantie:
            Label("Momentan indisponibil", systemImage: "lock")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 48)
        }
    }

    private var zonaEchipament: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Echipament")
                .font(.headline)
                .foregroundStyle(.primary)

            VStack(spacing: 0) {
                ForEach(SlotEchipament.allCases) { slot in
                    Button {
                        slotSelectat = slot
                    } label: {
                        HStack(spacing: 12) {
                            Label(slot.titlu, systemImage: slot.simbol)
                                .font(.body)
                                .foregroundStyle(.primary)
                                .lineLimit(1)

                            Spacer(minLength: 8)

                            Text(numeEchipat(in: slot))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)

                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .frame(minHeight: 52)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Deschide obiectele disponibile pentru \(slot.titlu)")

                    if slot != SlotEchipament.allCases.last {
                        Divider()
                            .padding(.leading, 32)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

    private func salveazaNumele() {
        let nume = numeTemporar.trimmingCharacters(in: .whitespacesAndNewlines)
        if !nume.isEmpty {
            personaj.nume = nume
        }
    }
}
