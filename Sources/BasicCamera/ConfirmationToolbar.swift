import SwiftUI

struct ConfirmationToolbar: View {
    let retake: () -> Void
    let confirm: () -> Void

    var body: some View {
        HStack {
            Button("Retake") {
                withAnimation(.interactiveSpring) {
                    retake()
                }
            }
            .tint(.white)
            
            Spacer()
            
            Button("Use") {
                withAnimation(.interactiveSpring) {
                    confirm()
                }
            }
            .tint(.white)
        }
        .padding(.horizontal)
        .padding(.all)
    }
}

#Preview {
    ConfirmationToolbar(
        retake: { print("retake") },
        confirm: { print("confirmed") }
    )
    .background(.black)
}
