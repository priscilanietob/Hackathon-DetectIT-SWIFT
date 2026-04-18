import SwiftUI
import UniformTypeIdentifiers 
#if os(iOS)
import PhotosUI
#endif

struct XRayViewerView: View {
    @ObservedObject var xrayVM: XRayViewModel
    @State private var showImagePicker = false
    @State private var magnifierLocation: CGPoint = .zero
    @State private var showMagnifier = false

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            Divider().background(Color.dtBorder)
            viewer
            if xrayVM.hasImage {
                statusBar
            }
        }
        .cardStyle()
        #if os(iOS)
        .sheet(isPresented: $showImagePicker) {
            IOSImagePicker { img in xrayVM.loadImage(img) }
        }
        #endif
    }

    // MARK: - Toolbar
    var toolbar: some View {
        HStack(spacing: 8) {
            // Upload button
            Button {
                #if os(macOS)
                openMacFilePicker()
                #else
                showImagePicker = true
                #endif
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 13, weight: .semibold))
                    Text("Cargar Rx")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.dtPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)

            if xrayVM.hasImage {
                Divider().frame(height: 24).padding(.horizontal, 4)

                // zoom out
                ToolbarIconButton(icon: "minus.magnifyingglass") { xrayVM.zoomOut() }

                // zoom slider
                Slider(value: Binding(
                    get: { xrayVM.zoom },
                    set: { xrayVM.zoom = $0 }
                ), in: 0.25...3.0, step: 0.05)
                .frame(width: 90)

                // zoom in
                ToolbarIconButton(icon: "plus.magnifyingglass") { xrayVM.zoomIn() }

                Text("\(Int(xrayVM.zoom * 100))%")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Color.dtMutedFg)
                    .frame(width: 42)

                Divider().frame(height: 24).padding(.horizontal, 4)

                ToolbarIconButton(icon: "rotate.right") { xrayVM.rotate() }
                ToolbarIconButton(icon: "arrow.counterclockwise") { xrayVM.reset() }

                Divider().frame(height: 24).padding(.horizontal, 4)

                // lupa toggle
                Button {
                    xrayVM.magnifierEnabled.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15))
                        .foregroundColor(xrayVM.magnifierEnabled ? .white : Color.dtMutedFg)
                        .frame(width: 30, height: 30)
                        .background(xrayVM.magnifierEnabled ? Color.dtPrimary : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
                .help(xrayVM.magnifierEnabled ? "Desactivar lupa" : "Activar lupa")
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.dtSecondary.opacity(0.3))
    }

    // MARK: - Viewer area
    var viewer: some View {
        GeometryReader { geo in
            ZStack {
                Color.dtMuted.opacity(0.3)

                if let image = xrayVM.image {
                    #if os(macOS)
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(xrayVM.zoom)
                        .rotationEffect(xrayVM.rotation)
                        .offset(xrayVM.offset)
                    #else
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(xrayVM.zoom)
                        .rotationEffect(xrayVM.rotation)
                        .offset(xrayVM.offset)
                    #endif

                    if xrayVM.magnifierEnabled && showMagnifier {
                        MagnifierView(
                            image: image,
                            location: magnifierLocation,
                            containerSize: geo.size,
                            zoom: xrayVM.zoom
                        )
                    }

                    if xrayVM.magnifierEnabled {
                        Color.clear
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { v in
                                        magnifierLocation = v.location
                                        showMagnifier = true
                                    }
                                    .onEnded { _ in showMagnifier = false }
                            )
                    }

                    if xrayVM.magnifierEnabled {
                        VStack {
                            Spacer()
                            Label("Lupa activa — mueve el cursor sobre la imagen", systemImage: "magnifyingglass")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Capsule())
                                .padding(.bottom, 12)
                        }
                    }

                } else {
                    emptyState
                }
            }
            .gesture(
                xrayVM.hasImage && !xrayVM.magnifierEnabled
                ? AnyGesture(
                    DragGesture()
                        .onChanged { v in xrayVM.offset = v.translation }
                        .map { _ in () as AnyObject }
                  ).map { _ in () }
                : nil
            )
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .clipped()
    }

    var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle().fill(Color.dtSecondary).frame(width: 80, height: 80)
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 32))
                    .foregroundColor(Color.dtPrimary)
            }
            Text("Cargar imagen de rayos X")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color.dtForeground)
            Text("Selecciona una imagen para comenzar el análisis")
                .font(.system(size: 13))
                .foregroundColor(Color.dtMutedFg)
                .multilineTextAlignment(.center)
            HStack(spacing: 20) {
                Label("Arrastrar para mover", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
                Label("Pellizcar para zoom", systemImage: "arrow.up.left.and.arrow.down.right")
                Label("Lupa circular", systemImage: "magnifyingglass")
            }
            .font(.system(size: 11))
            .foregroundColor(Color.dtMutedFg)
        }
        .padding(40)
    }

    var statusBar: some View {
        HStack {
            HStack(spacing: 16) {
                Text("Zoom: \(Int(xrayVM.zoom * 100))%")
                Text("Rotación: \(Int(xrayVM.rotation.degrees))°")
                if xrayVM.magnifierEnabled {
                    Label("Lupa ×2.8", systemImage: "magnifyingglass")
                        .foregroundColor(Color.dtPrimary)
                }
            }
            .font(.system(size: 11, design: .monospaced))
            .foregroundColor(Color.dtMutedFg)

            Spacer()

            Button {
            } label: {
                Label("Exportar", systemImage: "square.and.arrow.down")
                    .font(.system(size: 11))
                    .foregroundColor(Color.dtMutedFg)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.dtSecondary.opacity(0.2))
    }

    // MARK: - macOS file picker
    #if os(macOS)
    private func openMacFilePicker() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK, let url = panel.url,
           let img = NSImage(contentsOf: url) {
            xrayVM.loadImage(img)
        }
    }
    #endif
}

// MARK: - Magnifier
struct MagnifierView: View {
    let image: PlatformImage
    let location: CGPoint
    let containerSize: CGSize
    let zoom: CGFloat

    private let size: CGFloat = 160
    private let magnification: CGFloat = 2.8

    var body: some View {
        ZStack {
            #if os(macOS)
            Image(nsImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: image.size.width * zoom * magnification,
                       height: image.size.height * zoom * magnification)
                .offset(x: -(location.x * magnification) + size/2,
                        y: -(location.y * magnification) + size/2)
                .frame(width: size, height: size)
                .clipShape(Circle())
            #else
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: image.size.width * zoom * magnification,
                       height: image.size.height * zoom * magnification)
                .offset(x: -(location.x * magnification) + size/2,
                        y: -(location.y * magnification) + size/2)
                .frame(width: size, height: size)
                .clipShape(Circle())
            #endif

            Circle()
                .stroke(Color.dtPrimary, lineWidth: 2.5)
                .frame(width: size, height: size)
            Rectangle()
                .fill(Color.white.opacity(0.35))
                .frame(width: 1, height: size * 0.8)
            Rectangle()
                .fill(Color.white.opacity(0.35))
                .frame(width: size * 0.8, height: 1)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.4), radius: 12, y: 4)
        .position(x: location.x, y: location.y)
        .allowsHitTesting(false)
    }
}

// MARK: - Toolbar icon button
struct ToolbarIconButton: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color.dtMutedFg)
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - iOS image picker
#if os(iOS)
struct IOSImagePicker: UIViewControllerRepresentable {
    let onSelect: (UIImage) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onSelect: onSelect) }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ vc: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onSelect: (UIImage) -> Void
        init(onSelect: @escaping (UIImage) -> Void) { self.onSelect = onSelect }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let img = info[.originalImage] as? UIImage { onSelect(img) }
            picker.dismiss(animated: true)
        }
    }
}
#endif
