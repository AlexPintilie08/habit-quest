import SwiftUI

struct EcranBunVenit: View {
    let deschideAutentificarea: () -> Void

    @State private var paginaActiva = 0
    @State private var progresActiv = 0.0

    private let slideuri = [
        SlideBunVenit(
            id: 0,
            titlu: "Bun venit in Habit Quest",
            descriere: "Transforma-ti obiceiurile intr-o aventura. Construieste-ti propria lume si evolueaza in fiecare zi."
        ),
        SlideBunVenit(
            id: 1,
            titlu: "Fiecare zi conteaza",
            descriere: "Completeaza misiuni, castiga XP, avanseaza pe harta si deblocheaza recompense."
        ),
        SlideBunVenit(
            id: 2,
            titlu: "Creeaza-ti eroul",
            descriere: "Personalizeaza-ti personajul, creste in nivel si deblocheaza echipamente si obiecte speciale."
        ),
        SlideBunVenit(
            id: 3,
            titlu: "Construieste-ti satul",
            descriere: "Fiecare obicei bun aduce un nou locuitor. Ajuta-l sa evolueze si transforma satul intr-o lume unica."
        ),
        SlideBunVenit(
            id: 4,
            titlu: "Obiceiurile bune prind viata",
            descriere: "Cititul, sportul sau studiul devin misiuni pentru locuitorii satului tau."
        ),
        SlideBunVenit(
            id: 5,
            titlu: "Invinge obiceiurile rele",
            descriere: "Transforma obiceiurile de care vrei sa scapi in adversari. Progresul tau te ajuta sa ii invingi."
        )
    ]

    var body: some View {
        ZStack {
            TabView(selection: $paginaActiva) {
                ForEach(slideuri) { slide in
                    ContinutSlideBunVenit(slide: slide)
                        .tag(slide.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack {
                HStack {
                    Spacer()
                    Button(action: deschideAutentificarea) {
                        Text("Omite")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .frame(minWidth: 44, minHeight: 44, alignment: .trailing)
                    }
                    .buttonStyle(.plain)
                }

                Spacer(minLength: 0)

                VStack(alignment: .trailing, spacing: 12) {
                    Button(action: treciLaUrmatorulSlide) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.black, in: Circle())
                    }
                    .accessibilityLabel("Urmatorul slide")

                    IndicatorPaginare(
                        paginaActiva: paginaActiva,
                        numarPagini: slideuri.count,
                        progres: progresActiv
                    )
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .task(id: paginaActiva) {
            progresActiv = 0
            withAnimation(.linear(duration: 5)) {
                progresActiv = 1
            }

            do {
                try await Task.sleep(nanoseconds: 5_000_000_000)
            } catch {
                return
            }

            guard !Task.isCancelled else { return }
            treciLaUrmatorulSlide()
        }
    }

    private func treciLaUrmatorulSlide() {
        if paginaActiva < slideuri.count - 1 {
            paginaActiva += 1
        } else {
            deschideAutentificarea()
        }
    }
}
