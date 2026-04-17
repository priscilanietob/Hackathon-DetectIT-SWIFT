import SwiftUI
import Combine

#if os(macOS)
typealias PlatformImage = NSImage
#else
typealias PlatformImage = UIImage
#endif

class XRayViewModel: ObservableObject {
    @Published var image: PlatformImage? = nil
    @Published var zoom: CGFloat = 1.0
    @Published var rotation: Angle = .zero
    @Published var offset: CGSize = .zero
    @Published var magnifierEnabled: Bool = false
    
    var hasImage: Bool { image != nil }
    
    func loadImage(_ img: PlatformImage) {
        self.image = img
        reset()
    }
    
    func zoomIn() { zoom = min(zoom + 0.1, 3.0) }
    func zoomOut() { zoom = max(zoom - 0.1, 0.25) }
    
    func rotate() { rotation += .degrees(90) }
    
    func reset() {
        zoom = 1.0
        rotation = .zero
        offset = .zero
    }
}
