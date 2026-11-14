import SwiftUI

struct SlideBunVenit: Identifiable {
    let id: Int
    let titlu: String
    let descriere: String
    let ilustratie: String
}

struct ContinutSlideBunVenit: View {
    let slide: SlideBunVenit

    var body: some View {
        GeometryReader { geometrie in
            ScrollView {
                VStack(spacing: 0) {
                    Image(slide.ilustratie)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: min(max(geometrie.size.height * 0.52, 260), 440))
                        .accessibilityHidden(true)

                    Text(slide.titlu)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(slide.descriere)
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(3)
                        .padding(.top, 14)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .padding(.top, 4)
                .padding(.bottom, 144)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
