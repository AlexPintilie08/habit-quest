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
            let dimensiuneImagine = min(
                min(geometrie.size.height * 0.44, 380),
                geometrie.size.width - 56
            )

            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    Image(slide.ilustratie)
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensiuneImagine * 1122 / 1402, height: dimensiuneImagine)
                        .accessibilityHidden(true)

                    VStack(spacing: 12) {
                        Text(slide.titlu)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(CuloriHabitQuest.textPrincipal)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(slide.descriere)
                            .font(.body)
                            .foregroundStyle(CuloriHabitQuest.textSecundar)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(3)
                    }
                    .padding(.top, 12)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .frame(minHeight: geometrie.size.height)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CuloriHabitQuest.fundalPrincipal)
    }
}
