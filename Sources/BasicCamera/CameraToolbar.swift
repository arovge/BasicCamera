import SwiftUI

struct CameraToolbar: View {
    let capture: () -> Void
    let flipOutput: () -> Void
    let dismiss: () -> Void

    var body: some View {
        VStack {
            CaptureButton {
                capture()
            }
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .tint(.white)
                
                Spacer()
                
                Button {
                    flipOutput()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                        .foregroundStyle(.white)
                        .padding(15)
                        .background(.ultraThinMaterial)
                        .clipShape(.circle)
                }
            }
        }
        .padding(.horizontal)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        VStack(spacing: 0) {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .safeAreaInset(edge: .bottom) {
            CameraToolbar(
                capture: { print("image captured") },
                flipOutput: { print("output flipped") },
                dismiss: { print("dimissed") }
            )
        }
    }
}
