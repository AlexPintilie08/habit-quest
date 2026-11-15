import SwiftUI

struct EcranBunVenit: View {
    let deschideAutentificarea: () -> Void

    @State private var paginaActiva = 0
    @State private var progresActiv = 0.0

    private let slideuri = [
        SlideBunVenit(
            id: 0,
            titlu: "Bun venit in Habit Quest",
            descriere: "Transforma-ti obiceiurile intr-o aventura. Construieste-ti propria lume si evolueaza in fiecare zi.",
            ilustratie: "IlustratieBunVenit"
        ),
        SlideBunVenit(
            id: 1,
            titlu: "Fiecare zi conteaza",
            descriere: "Completeaza misiuni, castiga XP, avanseaza pe harta si deblocheaza recompense.",
            ilustratie: "IlustratieZi"
        ),
        SlideBunVenit(
            id: 2,
            titlu: "Creeaza-ti eroul",
            descriere: "Personalizeaza-ti personajul, creste in nivel si deblocheaza echipamente si obiecte speciale.",
            ilustratie: "IlustratieErou"
        ),
        SlideBunVenit(
            id: 3,
            titlu: "Construieste-ti satul",
            descriere: "Fiecare obicei bun aduce un nou locuitor. Ajuta-l sa evolueze si transforma satul intr-o lume unica.",
            ilustratie: "IlustratieSat"
        ),
        SlideBunVenit(
            id: 4,
            titlu: "Obiceiurile bune prind viata",
            descriere: "Cititul, sportul sau studiul devin misiuni pentru locuitorii satului tau.",
            ilustratie: "IlustratieObiceiuriBune"
        ),
        SlideBunVenit(
            id: 5,
            titlu: "Invinge obiceiurile rele",
            descriere: "Transforma obiceiurile de care vrei sa scapi in adversari. Progresul tau te ajuta sa ii invingi.",
            ilustratie: "IlustratieObiceiuriRele"
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
                Spacer(minLength: 0)

                HStack(alignment: .bottom) {
                    Button(action: deschideAutentificarea) {
                        Text("Skip")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 22)
                            .frame(minHeight: 48)
                            .background(Color.primary.opacity(0.06), in: Capsule())
                    }
                    .buttonStyle(.plain)

                    Spacer(minLength: 20)

                    VStack(alignment: .trailing, spacing: 14) {
                        Button(action: treciLaUrmatorulSlide) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 21, weight: .medium))
                                .foregroundStyle(Color(uiColor: .systemBackground))
                                .frame(width: 52, height: 52)
                                .background(Color.primary, in: Circle())
                        }
                        .accessibilityLabel("Urmatorul slide")

                        IndicatorPaginare(
                            paginaActiva: paginaActiva,
                            numarPagini: slideuri.count,
                            progres: progresActiv
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
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
