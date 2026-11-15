import SwiftUI

struct PanouAspectPersonaj: View {
    @Binding private var personaj: Personaj
    @State private var ciorna: Personaj
    @State private var categorie = CategoriaPersonalizare.corp
    @State private var subtonPiele = SubtonPiele.neutru
    @State private var familiePar = FamilieCuloarePar.naturale
    @State private var familieOchi = FamilieCuloareOchi.naturale
    @State private var familieEchipament = FamilieCuloareEchipament.metale
    @State private var canalEchipament = CanalCuloareEchipament.primara

    let animatiePermisa: Bool

    @Environment(\.dismiss) private var inchide

    init(personaj: Binding<Personaj>, animatiePermisa: Bool) {
        _personaj = personaj
        _ciorna = State(initialValue: personaj.wrappedValue)
        self.animatiePermisa = animatiePermisa
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometrie in
                VStack(spacing: 0) {
                    RandarePersonaj(
                        personaj: ciorna,
                        animatiePermisa: animatiePermisa,
                        incadrare: categorie.incadrare
                    )
                    .frame(height: min(max(geometrie.size.height * 0.31, 170), 270))
                    .frame(maxWidth: .infinity)

                    categorii

                    Divider()

                    ScrollView {
                        continutCategorie
                            .frame(maxWidth: 600, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                    }
                    .scrollIndicators(.hidden)
                }
                .background(CuloriHabitQuest.fundalPrincipal)
            }
            .navigationTitle("Personalizare")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuleaza") {
                        inchide()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Gata") {
                        personaj = ciorna
                        inchide()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var categorii: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(CategoriaPersonalizare.allCases) { optiune in
                    Button {
                        categorie = optiune
                    } label: {
                        Text(optiune.titlu)
                            .font(.subheadline.weight(categorie == optiune ? .semibold : .regular))
                            .foregroundStyle(categorie == optiune ? .primary : .secondary)
                            .padding(.vertical, 13)
                            .overlay(alignment: .bottom) {
                                if categorie == optiune {
                                    Capsule()
                                        .fill(CuloriHabitQuest.albastruInteractiune)
                                        .frame(height: 3)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(categorie == optiune ? .isSelected : [])
                }
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
        .background(CuloriHabitQuest.fundalPrincipal)
    }

    @ViewBuilder
    private var continutCategorie: some View {
        switch categorie {
        case .corp:
            continutCorp
        case .piele:
            continutPiele
        case .fata:
            continutIndisponibil(
                titlu: "Formele fetei nu au inca variante grafice.",
                detalii: "Catalogul va putea primi asseturi separate pentru fiecare forma."
            )
        case .par:
            continutPar
        case .ochi:
            continutOchi
        case .sprancene:
            continutIndisponibil(
                titlu: "Nu exista asseturi separate pentru sprancene.",
                detalii: "Optiunile raman ascunse pana cand sunt disponibile variante compatibile."
            )
        case .barba:
            continutIndisponibil(
                titlu: "Nu exista asseturi separate pentru barba.",
                detalii: "Catalogul de barba este pregatit pentru sprite-uri cu identificatori stabili."
            )
        case .detalii:
            continutIndisponibil(
                titlu: "Nu exista variante grafice pentru detalii.",
                detalii: "Pistruii, cicatricile si semnele distinctive necesita layere dedicate."
            )
        case .culoriEchipament:
            continutCuloriEchipament
        }
    }

    private var continutCorp: some View {
        VStack(alignment: .leading, spacing: 18) {
            stare(
                .pregatitaPentruViitor,
                mesaj: "Prezentarea si inaltimea se salveaza. Ilustratia actuala nu poate schimba corpul sau proportiile fara sa fie deformata."
            )

            VStack(alignment: .leading, spacing: 10) {
                Text("Prezentare")
                    .font(.headline)

                Picker("Prezentare", selection: $ciorna.gen) {
                    Text("Baiat").tag(GenPersonaj.masculin)
                    Text("Fata").tag(GenPersonaj.feminin)
                }
                .pickerStyle(.segmented)
            }

            LabeledContent("Tip de corp", value: "Ilustratia actuala")

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Inaltime")
                    Spacer()
                    Text("\(Int(ciorna.trasaturi.inaltime * 100))%")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }

                Slider(value: $ciorna.trasaturi.inaltime, in: 0.85...1.15, step: 0.05)
                    .accessibilityLabel("Inaltime")
                    .accessibilityValue("\(Int(ciorna.trasaturi.inaltime * 100)) la suta")
            }
        }
    }

    private var continutPiele: some View {
        VStack(alignment: .leading, spacing: 16) {
            stare(
                .pregatitaPentruViitor,
                mesaj: "Nuanta aleasa se salveaza, dar pielea din PNG este pictata in ilustratie. Pentru previzualizare este necesara o masca separata pentru piele."
            )

            Picker("Subton", selection: $subtonPiele) {
                ForEach(SubtonPiele.allCases) { subton in
                    Text(subton.titlu).tag(subton)
                }
            }
            .pickerStyle(.segmented)

            Text("\(CatalogPersonalizare.culoriPiele(pentru: subtonPiele).count) nuante · \(subtonPiele.titlu)")
                .font(.subheadline.weight(.medium))

            grila(
                CatalogPersonalizare.culoriPiele(pentru: subtonPiele),
                selectata: ciorna.trasaturi.nuantaPiele
            ) { culoare in
                ciorna.trasaturi.nuantaPiele = culoare
            }

            ColorPicker("Reglaj fin", selection: bindingPentruPiele, supportsOpacity: false)
        }
    }

    private var continutPar: some View {
        VStack(alignment: .leading, spacing: 16) {
            stare(
                .functionala,
                mesaj: "Cele 64 de nuante recoloreaza doar zona mastii MascaPar. Forma parului ramane cea inclusa in ilustratia actuala."
            )

            VStack(alignment: .leading, spacing: 6) {
                Text("Coafuri")
                    .font(.headline)

                Text("Nu exista miniaturi sau sprite-uri separate pentru coafuri. Optiunile de stil nu sunt afisate pana cand sunt create asseturi compatibile.")
                    .foregroundStyle(.secondary)
            }

            Picker("Familie de culori", selection: $familiePar) {
                ForEach(FamilieCuloarePar.allCases) { familie in
                    Text(familie.titlu).tag(familie)
                }
            }
            .pickerStyle(.menu)

            Text("\(CatalogPersonalizare.culoriPar(pentru: familiePar).count) nuante · \(familiePar.titlu)")
                .font(.subheadline.weight(.medium))

            grila(
                CatalogPersonalizare.culoriPar(pentru: familiePar),
                selectata: culoareParSelectata
            ) { culoare in
                ciorna.aspect.culoarePrincipalaPar = culoare
            }

            ColorPicker("Reglaj fin", selection: bindingPentruPar, supportsOpacity: false)

            stare(
                .pregatitaPentruViitor,
                mesaj: "Highlights au nevoie de o masca separata. Nu sunt aplicate peste fata sau corp."
            )
        }
    }

    private var continutOchi: some View {
        VStack(alignment: .leading, spacing: 16) {
            stare(
                .pregatitaPentruViitor,
                mesaj: "Culoarea se salveaza, dar ilustratia nu are masca pentru iris. Formele ochilor raman ascunse pana exista miniaturi reale."
            )

            Text("Forma ochilor")
                .font(.headline)

            Text("Catalogul nu contine variante grafice pentru forma ochilor.")
                .foregroundStyle(.secondary)

            Picker("Paleta", selection: $familieOchi) {
                ForEach(FamilieCuloareOchi.allCases) { familie in
                    Text(familie.titlu).tag(familie)
                }
            }
            .pickerStyle(.segmented)

            Text("\(CatalogPersonalizare.culoriOchi(pentru: familieOchi).count) culori · \(familieOchi.titlu)")
                .font(.subheadline.weight(.medium))

            grila(
                CatalogPersonalizare.culoriOchi(pentru: familieOchi),
                selectata: culoareOchiSelectata
            ) { culoare in
                ciorna.trasaturi.culoareOchiPersonalizata = culoare
            }

            ColorPicker("Reglaj fin", selection: bindingPentruOchi, supportsOpacity: false)
        }
    }

    private var continutCuloriEchipament: some View {
        VStack(alignment: .leading, spacing: 16) {
            stare(
                .functionala,
                mesaj: "Culoarea primara se aplica mastii lamei sabiei. Culorile secundara si accent se salveaza, dar necesita masti pentru armura si ornamente."
            )

            Picker("Canal", selection: $canalEchipament) {
                ForEach(CanalCuloareEchipament.allCases) { canal in
                    Text(canal.titlu).tag(canal)
                }
            }
            .pickerStyle(.segmented)

            if canalEchipament != .primara {
                stare(
                    .pregatitaPentruViitor,
                    mesaj: "Acest canal nu modifica ilustratia pana cand sunt adaugate masti de material compatibile."
                )
            }

            Picker("Familie de culori", selection: $familieEchipament) {
                ForEach(FamilieCuloareEchipament.allCases) { familie in
                    Text(familie.titlu).tag(familie)
                }
            }
            .pickerStyle(.menu)

            Text("\(CatalogPersonalizare.culoriEchipament(pentru: familieEchipament).count) preseturi · \(familieEchipament.titlu)")
                .font(.subheadline.weight(.medium))

            grila(
                CatalogPersonalizare.culoriEchipament(pentru: familieEchipament),
                selectata: culoareEchipamentSelectata
            ) { culoare in
                seteazaCuloareEchipament(culoare)
            }

            ColorPicker("Reglaj fin", selection: bindingPentruEchipament, supportsOpacity: false)

            Text("Paleta este comuna. Pe viitor, fiecare piesa poate primi propria paleta.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var culoareParSelectata: CodCuloare? {
        if let culoare = ciorna.aspect.culoarePrincipalaPar {
            return culoare
        }

        if ciorna.aspect.nuantaPar == .auriu {
            return CatalogPersonalizare.culoriPar(pentru: .blond).first { $0.id == "par-blond-06" }?.culoare
        }

        return nil
    }

    private var culoareOchiSelectata: CodCuloare? {
        ciorna.trasaturi.culoareOchiPersonalizata
    }

    private var culoareEchipamentSelectata: CodCuloare {
        switch canalEchipament {
        case .primara: ciorna.paleta.primara
        case .secundara: ciorna.paleta.secundara
        case .accent: ciorna.paleta.accent
        }
    }

    private var bindingPentruPiele: Binding<Color> {
        Binding(
            get: {
                ciorna.trasaturi.nuantaPiele?.culoareSwiftUI
                    ?? CatalogPersonalizare.culoriPiele(pentru: subtonPiele)[8].culoare.culoareSwiftUI
            },
            set: { ciorna.trasaturi.nuantaPiele = CodCuloare(culoare: $0) }
        )
    }

    private var bindingPentruPar: Binding<Color> {
        Binding(
            get: {
                culoareParSelectata?.culoareSwiftUI
                    ?? CatalogPersonalizare.culoriPar(pentru: .naturale)[3].culoare.culoareSwiftUI
            },
            set: { ciorna.aspect.culoarePrincipalaPar = CodCuloare(culoare: $0) }
        )
    }

    private var bindingPentruOchi: Binding<Color> {
        Binding(
            get: {
                culoareOchiSelectata?.culoareSwiftUI
                    ?? CatalogPersonalizare.culoriOchi(pentru: .naturale)[6].culoare.culoareSwiftUI
            },
            set: { ciorna.trasaturi.culoareOchiPersonalizata = CodCuloare(culoare: $0) }
        )
    }

    private var bindingPentruEchipament: Binding<Color> {
        Binding(
            get: { culoareEchipamentSelectata.culoareSwiftUI },
            set: { seteazaCuloareEchipament(CodCuloare(culoare: $0)) }
        )
    }

    private func seteazaCuloareEchipament(_ culoare: CodCuloare) {
        switch canalEchipament {
        case .primara:
            ciorna.paleta.primara = culoare
            ciorna.paleta.primaraActiva = true
        case .secundara:
            ciorna.paleta.secundara = culoare
            ciorna.paleta.secundaraActiva = true
        case .accent:
            ciorna.paleta.accent = culoare
            ciorna.paleta.accentActiva = true
        }
    }

    private func stare(_ stare: StarePersonalizare, mesaj: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(stare.titlu, systemImage: stare.simbol)
                .font(.subheadline.weight(.semibold))

            Text(mesaj)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func continutIndisponibil(titlu: String, detalii: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            stare(.indisponibila, mesaj: titlu)
            Text(detalii)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }

    private func grila(
        _ optiuni: [OptiuneCuloarePersonaj],
        selectata: CodCuloare?,
        laSelectie: @escaping (CodCuloare) -> Void
    ) -> some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 44), spacing: 8)],
            alignment: .leading,
            spacing: 8
        ) {
            ForEach(optiuni) { optiune in
                ButonCuloarePersonaj(
                    optiune: optiune,
                    esteSelectata: optiune.culoare == selectata
                ) {
                    laSelectie(optiune.culoare)
                }
            }
        }
    }
}

private enum CanalCuloareEchipament: String, CaseIterable, Identifiable {
    case primara
    case secundara
    case accent

    var id: String { rawValue }

    var titlu: String {
        switch self {
        case .primara: "Primara"
        case .secundara: "Secundara"
        case .accent: "Accent"
        }
    }
}

private struct ButonCuloarePersonaj: View {
    let optiune: OptiuneCuloarePersonaj
    let esteSelectata: Bool
    let actiune: () -> Void

    var body: some View {
        Button(action: actiune) {
            Circle()
                .fill(optiune.culoare.culoareSwiftUI)
                .frame(width: 30, height: 30)
                .overlay {
                    if esteSelectata {
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary)
                            .shadow(color: .white.opacity(0.8), radius: 1)
                    }
                }
                .padding(7)
                .overlay {
                    Circle()
                        .strokeBorder(esteSelectata ? Color.primary : Color.secondary.opacity(0.35), lineWidth: esteSelectata ? 2 : 1)
                }
                .frame(width: 44, height: 44)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(optiune.nume)
        .accessibilityValue(esteSelectata ? "Selectata" : "Neselectata")
        .accessibilityAddTraits(esteSelectata ? .isSelected : [])
    }
}
