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

    private var configuratie: ConfiguratiePersonaj {
        ConfiguratiePersonaj(
            nuantaPar: personaj.aspect.nuantaPar,
            nuantaLama: personaj.aspect.nuantaLama
        )
    }

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
                        .frame(height: min(max(geometrie.size.height * 0.48, 300), 440))
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))

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
            .background(Color(uiColor: .systemBackground))
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
            HStack(spacing: 10) {
                ForEach(NuantaPar.allCases) { nuanta in
                    butonVarianta(
                        titlu: nuanta.titlu,
                        swatch: nuanta.culoareSwatch,
                        selectata: configuratie.nuantaPar == nuanta
                    ) {
                        personaj.aspect.nuantaPar = nuanta
                    }
                }
            }
            .frame(maxWidth: .infinity)
        case .echipament:
            HStack(spacing: 10) {
                ForEach(NuantaLama.allCases) { nuanta in
                    butonVarianta(
                        titlu: nuanta.titlu,
                        swatch: nuanta.culoareSwatch,
                        selectata: configuratie.nuantaLama == nuanta
                    ) {
                        personaj.aspect.nuantaLama = nuanta
                    }
                }
            }
            .frame(maxWidth: .infinity)
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

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(SlotEchipament.allCases) { slot in
                    Button {
                        slotSelectat = slot
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Label(slot.titlu, systemImage: slot.simbol)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)

                            Text(numeEchipat(in: slot))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, minHeight: 70, alignment: .leading)
                        .background(
                            Color(uiColor: .secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Deschide obiectele disponibile pentru \(slot.titlu)")
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

    private func butonVarianta(
        titlu: String,
        swatch: Color,
        selectata: Bool,
        actiune: @escaping () -> Void
    ) -> some View {
        Button(action: actiune) {
            HStack(spacing: 8) {
                Circle()
                    .fill(swatch)
                    .frame(width: 22, height: 22)
                    .overlay {
                        Circle().strokeBorder(Color.primary.opacity(0.12), lineWidth: 1)
                    }
                    .overlay {
                        if selectata {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color(uiColor: .systemBackground))
                                .frame(width: 20, height: 20)
                                .background(Color.primary, in: Circle())
                        }
                    }

                Text(titlu)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 12)
            .frame(minHeight: 48)
            .background(
                selectata ? Color.accentColor.opacity(0.12) : Color.secondary.opacity(0.08),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(selectata ? Color.accentColor : .clear, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(titlu)
        .accessibilityAddTraits(selectata ? .isSelected : [])
    }

    private func salveazaNumele() {
        let nume = numeTemporar.trimmingCharacters(in: .whitespacesAndNewlines)
        if !nume.isEmpty {
            personaj.nume = nume
        }
    }
}
