import SwiftUI

class CameraModel: ObservableObject {
    enum Source {
        case front
        case back
    }
    
    enum Phase {
        case capture
        case confirmation
    }
    
    @Published var source = Source.back
    @Published var phase = Phase.capture
    
    func flipCamera() {
        source = switch source {
        case .back: .front
        case .front: .back
        }
    }
    
    func capture() {
        phase = .confirmation
    }
    
    func retake() {
        phase = .capture
    }
    
    func confirm() {
        phase = .capture
    }
}

struct CameraView: View {
    @StateObject private var model = CameraModel()
    let options: BasicCameraOptions
    let dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            StubbedViewFinder(source: model.source)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            switch model.phase {
            case .capture:
                CameraToolbar(
                    capture: { model.capture() },
                    flipCamera: { model.flipCamera() },
                    dismiss: { dismiss() }
                )
            case .confirmation:
                ConfirmationToolbar(
                    retake: { model.retake() },
                    confirm: { model.confirm() }
                )
            }
        }
    }
}

struct StubbedViewFinder: View {
    let source: CameraModel.Source
    
    var body: some View {
        Rectangle()
            .fill(source == .back ? .red : .blue)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var presented = true
    
    Button("Present") {
        presented.toggle()
    }
    .basicCameraView(isPresented: $presented)
}
