import SwiftUI

struct EcranBunVenit: View {
    let deschideAutentificarea: () -> Void

    @State private var paginaActiva = 0
    @State private var progresActiv = 0.0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $paginaActiva) {
                ForEach(0..<3, id: \.self) { index in
                    Text("Habit Quest - Slide \(index + 1)")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack(alignment: .trailing, spacing: 12) {
                Button(action: treciLaUrmatorulSlide) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                        .background(Color.black, in: Circle())
                }
                .accessibilityLabel("Urmatorul slide")

                IndicatorPaginare(paginaActiva: paginaActiva, progres: progresActiv)
            }
            .padding(.trailing, 24)
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
        if paginaActiva < 2 {
            paginaActiva += 1
        } else {
            deschideAutentificarea()
        }
    }
}
