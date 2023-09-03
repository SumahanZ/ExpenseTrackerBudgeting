import SwiftUI


struct HorizontalDivider: View {
    
    let color: Color
    let height: CGFloat
    let width: CGFloat
    
    init(color: Color, height: CGFloat = 0.5, width: CGFloat) {
        self.color = color
        self.height = height
        self.width = width
    }
    
    var body: some View {
        color
            .frame(width: width, height: height)
    }
}
