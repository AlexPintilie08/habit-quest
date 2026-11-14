import SwiftUI

struct SlideBunVenit: Identifiable {
    let id: Int
    let titlu: String
    let descriere: String
}

struct ContinutSlideBunVenit: View {
    let slide: SlideBunVenit

    var body: some View {
        GeometryReader { geometrie in
            ScrollView {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(maxWidth: .infinity)
                        .frame(height: min(max(geometrie.size.height * 0.36, 180), 300))
                        .accessibilityHidden(true)

                    Text(slide.titlu)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(slide.descriere)
                        .font(.body)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 12)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .padding(.top, 64)
                .padding(.bottom, 132)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
