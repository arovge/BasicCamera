import SwiftUI

class CameraModel: ObservableObject {
    enum Source {
        case front
        case back
        
        mutating func flip() {
            self = switch self {
            case .back: .front
            case .front: .back
            }
        }
    }
    
    @Published var source = Source.back
}

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var model = CameraModel()
    let options: BasicCameraOptions
    
    var body: some View {
        VStack(spacing: 0) {
            StubbedViewFinder(source: model.source)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CameraToolbar(
                capture: { print("image captured") },
                flipCamera: { model.source.flip() },
                dismiss: { dismiss() }
            )
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
    @Previewable @State var presented = false
    
    Button("Present") {
        presented.toggle()
    }
    .basicCameraView(isPresented: $presented)
}
