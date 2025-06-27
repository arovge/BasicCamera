import SwiftUI

public extension View {
    /// Presents a `fullScreenCover` that presents the basic camera view.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the basic camera view.
    func basicCameraView(isPresented: Binding<Bool>) -> some View {
        fullScreenCover(isPresented: isPresented) {
            NavigationView {
                CameraView()
            }
        }
    }
}

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
