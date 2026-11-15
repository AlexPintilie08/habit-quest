import SwiftUI

struct EcranPersonaj: View {
    let esteActiv: Bool

    @AppStorage("numeErou") private var numeErou = "Aventurier"
    @AppStorage("nuantaPar") private var nuantaParSalvata = NuantaPar.castaniu.rawValue
    @AppStorage("nuantaLama") private var nuantaLamaSalvata = NuantaLama.otel.rawValue
    @AppStorage("animatiiActive") private var animatiiActive = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var stareAplicatie
    @State private var categorie = CategoriaPersonalizare.par
    @State private var afiseazaEditareNume = false
    @State private var numeTemporar = ""

    private var configuratie: ConfiguratiePersonaj {
        ConfiguratiePersonaj(
            nuantaPar: NuantaPar(rawValue: nuantaParSalvata) ?? .castaniu,
            nuantaLama: NuantaLama(rawValue: nuantaLamaSalvata) ?? .otel
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
                            configuratie: configuratie,
                            numeErou: numeErou,
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
        }
    }

    private var antet: some View {
        HStack(spacing: 10) {
            Text(numeErou)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)

            Button {
                numeTemporar = numeErou
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
                        nuantaParSalvata = nuanta.rawValue
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
                        nuantaLamaSalvata = nuanta.rawValue
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
            numeErou = nume
        }
    }
}

private struct RandarePersonaj: View {
    let configuratie: ConfiguratiePersonaj
    let numeErou: String
    let animatiePermisa: Bool

    var body: some View {
        if animatiePermisa {
            straturi
                .phaseAnimator([false, true]) { continut, faza in
                    continut.offset(y: faza ? -1.5 : 0)
                } animation: { _ in
                    .easeInOut(duration: 2.4)
                }
        } else {
            straturi
        }
    }

    private var straturi: some View {
        ZStack {
            Image("PersonajBaza")
                .resizable()
                .scaledToFit()

            if let culoare = configuratie.nuantaPar.culoareSuprapunere {
                Image("MascaPar")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(culoare)
                    .blendMode(.color)
            }

            if let culoare = configuratie.nuantaLama.culoareSuprapunere {
                Image("MascaLama")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(culoare)
                    .blendMode(.color)
            }
        }
        .compositingGroup()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Personajul \(numeErou)")
    }
}
