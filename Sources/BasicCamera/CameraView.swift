import SwiftUI
import UIKit

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
    @Published var dismiss = false
    @Published var takenImages = [UIImage]()
    private let options: BasicCameraOptions
    
    init(options: BasicCameraOptions) {
        self.options = options
    }
    
    func flipCamera() {
        source = switch source {
        case .back: .front
        case .front: .back
        }
    }
    
    func capture() {
        if options.showPhotoConfirmation {
            phase = .confirmation
            return
        }
        
        // TODO: Save image
        if canTakeAnotherImage {
            phase = .capture
        } else {
            dismiss = true
        }
    }
    
    func retake() {
        phase = .capture
    }
    
    func confirm() {
        // TODO: save image
        
        if canTakeAnotherImage {
            phase = .capture
        } else {
            dismiss = true
        }
    }
    
    var canTakeAnotherImage: Bool {
        options.supportsMultipleCaptures && takenImages.count < options.maxImageCount
    }
}

struct CameraView: View {
    @StateObject private var model: CameraModel
    let dismiss: () -> Void
    let addImages: ([UIImage]) -> Void
    
    init(
        options: BasicCameraOptions,
        dismiss: @escaping () -> Void,
        addImages: @escaping ([UIImage]) -> Void
    ) {
        self._model = StateObject(wrappedValue: CameraModel(options: options))
        self.dismiss = dismiss
        self.addImages = addImages
    }
    
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
        .onChange(of: model.dismiss) { _ in
            guard model.dismiss else { return }
            addImages(model.takenImages)
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
    @Previewable @State var supportsMultipleCaptures = false
    @Previewable @State var showPhotoConfirmation = true
    @Previewable @State var presented = true
    
    Form {
        Section("Options") {
            Toggle("Multiple Selection", isOn: $supportsMultipleCaptures)
            Toggle("Confirmation", isOn: $showPhotoConfirmation)
        }
        Section {
            Button("Take Picture", systemImage: "camera") {
                presented.toggle()
            }
        }
    }
    .basicCameraView(
        isPresented: $presented,
        options: BasicCameraOptions(
            supportsMultipleCaptures: supportsMultipleCaptures,
            showPhotoConfirmation: showPhotoConfirmation,
            maxImageCount: supportsMultipleCaptures ? 3 : 1
        )
    ) { _ in }
}
