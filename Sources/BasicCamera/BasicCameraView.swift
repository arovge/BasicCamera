import SwiftUI
import UIKit

/// A struct defining various options for configuring camera.
public struct BasicCameraOptions {
    let showPhotoConfirmation: Bool
    let supportsMultipleCaptures: Bool
    let maxImageCount: Int
    
    /// Creates a new BasicCameraOptions struct. Parameters all have default values allowing for customization.
    /// - Parameters:
    ///   - showPhotoConfirmation: Flag that determines if the user should be shown the photo confirmation screen after taking a photo. Defaults to `true`.
    ///   - supportsMultipleCaptures: Flag that determines if the user can take multiple photos within the same camera session. Defaults to `false`.
    ///   - maxImageCount: The maximum number of photos the user can take in a single session. Only relevant when `supportsMultipleCaptures` is `true`.
    public init(
        supportsMultipleCaptures: Bool = false,
        showPhotoConfirmation: Bool = true,
        maxImageCount: Int = 10
    ) {
        self.supportsMultipleCaptures = supportsMultipleCaptures
        self.showPhotoConfirmation = showPhotoConfirmation
        self.maxImageCount = maxImageCount
    }
}

public extension View {
    /// Presents a `fullScreenCover` that presents the basic camera view.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the basic camera view.
    ///   - options: Configurable options for the BasicCamera. By default this uses the argumentless initializer for `BasicCameraOptions`.
    ///   - addImages: Closure that is called when the photo session is finished. If the user has taken any images and hits the cancel button, no images will be passed. If the user reaches the max number of images, this closure will be called. Otherwise it is triggered when the user hits the done button.
    func basicCameraView(
        isPresented: Binding<Bool>,
        options: BasicCameraOptions = BasicCameraOptions(),
        addImages: @escaping ([UIImage]) -> Void
    ) -> some View {
        fullScreenCover(isPresented: isPresented) {
            BasicCameraView(
                options: options,
                addImages: addImages
            )
        }
    }
}

struct BasicCameraView: View {
    @Environment(\.dismiss) private var dismiss
    let options: BasicCameraOptions
    let addImages: ([UIImage]) -> Void
    
    var body: some View {
        NavigationView {
            CameraView(
                options: options,
                dismiss: dismiss.callAsFunction
            ) { images in
                if !images.isEmpty {
                    addImages(images)
                }
                dismiss()
            }
        }
    }
}
