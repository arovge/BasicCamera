import SwiftUI

public extension View {
    /// Presents a `fullScreenCover` that presents the basic camera view.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the basic camera view.
    ///   - options: Configurable options for the BasicCamera. By default this uses `BasicCameraOptions.default`.
    func basicCameraView(
        isPresented: Binding<Bool>,
        options: BasicCameraOptions = .default
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
    public init() {}
    
    public static var `default`: BasicCameraOptions {
        BasicCameraOptions()
    }
}
