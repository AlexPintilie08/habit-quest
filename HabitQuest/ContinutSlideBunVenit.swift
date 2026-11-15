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
                        .background(CuloriHabitQuest.fundalIlustratie)
                        .padding(.horizontal, -28)
                        .accessibilityHidden(true)

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
                        .padding(.top, 14)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .padding(.top, 4)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CuloriHabitQuest.fundalPrincipal)
    }
}
