import SwiftUI

struct PanouAspectPersonaj: View {
    @Binding var personaj: Personaj
    @Environment(\.dismiss) private var inchide

    var body: some View {
        NavigationStack {
            Form {
                SectiuneIdentitate(personaj: $personaj)
                SectiuneTrasaturi(personaj: $personaj)
                SectiunePaleta(paleta: $personaj.paleta)

                Section {
                    Text("Inaltimea, tonul pielii, coafura, ochii si paleta se salveaza, dar au nevoie de ilustratii dedicate pentru previzualizare.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Aspect")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gata") {
                        inchide()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

private struct SectiuneIdentitate: View {
    @Binding var personaj: Personaj

    var body: some View {
        Section("Identitate") {
            TextField("Numele eroului", text: $personaj.nume)
                .textContentType(.name)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()

            Picker("Gen", selection: $personaj.gen) {
                ForEach(GenPersonaj.allCases) { gen in
                    Text(gen.titlu).tag(gen)
                }
            }
            .pickerStyle(.segmented)

            LabeledContent("Clasa", value: personaj.clasa.titlu)
        }
    }
}

private struct SectiuneTrasaturi: View {
    @Binding var personaj: Personaj

    var body: some View {
        Section("Trasaturi") {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Inaltime")
                    Spacer()
                    Text("\(Int(personaj.trasaturi.inaltime * 100))%")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }

                Slider(value: $personaj.trasaturi.inaltime, in: 0.85...1.15, step: 0.05)
                    .accessibilityLabel("Inaltime")
                    .accessibilityValue("\(Int(personaj.trasaturi.inaltime * 100)) la suta")
            }

            Picker("Tonul pielii", selection: $personaj.trasaturi.tonPiele) {
                ForEach(TonPiele.allCases) { ton in
                    Text(ton.titlu).tag(ton)
                }
            }
            .pickerStyle(.menu)

            Picker("Coafura", selection: $personaj.trasaturi.coafura) {
                ForEach(Coafura.allCases) { coafura in
                    Text(coafura.titlu).tag(coafura)
                }
            }
            .pickerStyle(.menu)

            Picker("Culoarea parului", selection: $personaj.aspect.nuantaPar) {
                ForEach(NuantaPar.allCases) { nuanta in
                    Text(nuanta.titlu).tag(nuanta)
                }
            }
            .pickerStyle(.menu)

            Picker("Forma ochilor", selection: $personaj.trasaturi.formaOchi) {
                ForEach(FormaOchi.allCases) { forma in
                    Text(forma.titlu).tag(forma)
                }
            }
            .pickerStyle(.menu)

            Picker("Culoarea ochilor", selection: $personaj.trasaturi.culoareOchi) {
                ForEach(CuloareOchi.allCases) { culoare in
                    Text(culoare.titlu).tag(culoare)
                }
            }
            .pickerStyle(.menu)

            Picker("Culoarea lamei", selection: $personaj.aspect.nuantaLama) {
                ForEach(NuantaLama.allCases) { nuanta in
                    Text(nuanta.titlu).tag(nuanta)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

private struct SectiunePaleta: View {
    @Binding var paleta: PaletaPersonaj

    var body: some View {
        Section("Paleta") {
            randCulori("Culoare primara", selectata: $paleta.primara)
            randCulori("Culoare secundara", selectata: $paleta.secundara)
            randCulori("Culoare accent", selectata: $paleta.accent)
        }
    }

    private func randCulori(
        _ titlu: String,
        selectata: Binding<CuloarePaleta>
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(titlu): \(selectata.wrappedValue.titlu)")
                .font(.subheadline)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 44), spacing: 10)],
                alignment: .leading,
                spacing: 8
            ) {
                ForEach(CuloarePaleta.allCases) { culoare in
                    ButonSwatchPersonaj(
                        culoare: culoare,
                        esteSelectata: selectata.wrappedValue == culoare
                    ) {
                        selectata.wrappedValue = culoare
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ButonSwatchPersonaj: View {
    let culoare: CuloarePaleta
    let esteSelectata: Bool
    let actiune: () -> Void

    var body: some View {
        Button(action: actiune) {
            Circle()
                .fill(culoare.culoare)
                .frame(width: 28, height: 28)
                .padding(6)
                .overlay {
                    Circle()
                        .strokeBorder(esteSelectata ? Color.primary : .clear, lineWidth: 2)
                }
                .frame(width: 44, height: 44)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(culoare.titlu)
        .accessibilityAddTraits(esteSelectata ? .isSelected : [])
    }
}
