import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.dtCard)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.dtBorder, lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .background(Color.dtCard)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.dtBorder, lineWidth: 1)
            )
    }
}

extension Color {
    static let dtPrimary = Color.blue
    static let dtCard = Color(white: 1.0)
    static let dtBorder = Color.gray.opacity(0.2)
    static let dtMuted = Color.gray.opacity(0.1)
    static let dtMutedFg = Color.gray
    static let dtForeground = Color.black
    static let dtSecondary = Color.gray.opacity(0.2)
    static let dtBackground = Color(white: 0.95) 
    static let dtDestructive = Color.red 
    
}
