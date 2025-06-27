import SwiftUI

public extension View {
    /// Presents a `fullScreenCover` that presents the basic camera view.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the basic camera view.
    ///   - options: Configurable options for the BasicCamera. By default this uses `BasicCameraOptions.default`.
    func basicCameraView(
        isPresented: Binding<Bool>,
        options: BasicCameraOptions = BasicCameraOptions()
    ) -> some View {
        fullScreenCover(isPresented: isPresented) {
            NavigationView {
                CameraView(options: options)
            }
        }
    }
}

/// A struct defining various options for configuring basic camera.
public struct BasicCameraOptions {
    let supportsMultipleCaptures: Bool
    let showPhotoConfirmation: Bool
    
    /// Creates a new BasicCameraOptions struct. Parameters all have default values allowing for customization.
    /// - Parameters:
    ///   - supportsMultipleCaptures: A Boolean argument for allowing the user to take multiple photos within the same camera session.
    public init(
        supportsMultipleCaptures: Bool = false,
        showPhotoConfirmation: Bool = true
    ) {
        self.supportsMultipleCaptures = supportsMultipleCaptures
        self.showPhotoConfirmation = showPhotoConfirmation
    }
}
