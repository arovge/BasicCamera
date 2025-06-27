import SwiftUI

public extension View {
    func cameraView(isPresented: Binding<Bool>) -> some View {
        fullScreenCover(isPresented: isPresented) {
            NavigationView {
                CameraView()
            }
        }
    }
}

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            StubbedViewFinder()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CameraToolbar(
                capture: { print("image captured") },
                flipOutput: { print("output flipped") },
                dismiss: { dismiss() }
            )
        }
    }
}

struct StubbedViewFinder: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(.red)
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var presented = false
    
    Button("Present") {
        presented.toggle()
    }
    .cameraView(isPresented: $presented)
}
