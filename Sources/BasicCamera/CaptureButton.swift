import SwiftUI

struct CaptureButton: View {
    let capture: () -> Void
    
    var body: some View {
        Button {
            capture()
        } label: {
            Circle()
                .fill(.white)
                .frame(width: 75, height: 75)
        }
        .buttonStyle(CaptureButtonStyle())
        .transition(.scale)
        .padding(5)
        .background(.ultraThinMaterial)
        .clipShape(.circle)
    }
}

private struct CaptureButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

#Preview {
    NavigationView {
        HStack {
            CaptureButton {
                print("image captured")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}
