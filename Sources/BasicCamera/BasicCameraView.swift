import SwiftUI
import UIKit

/// Determines how the capture workflow works
public enum BasicCameraPictureCaptureSetting {
    /// Only a single picture can be taken
    case single
    /// Multiple pictures can be taken until the maximum number of images are taken.
    case multi(max: Int)
}

/// Determines the workflow for after the user takes a picture.
public enum BasicCameraConfirmationSetting {
    /// There is no confirmation of a taken picture.
    case none
    /// The user is given the choice to retake a picture or confirm it.
    case confirm
    /// The user is given the choice to retake a picture, edit it by drawing on it, or confirm it without edits.
    case edit
}

/// A struct defining various options for configuring camera.
public struct BasicCameraOptions {
    let confirmation: BasicCameraConfirmationSetting
    let capture: BasicCameraPictureCaptureSetting
    
    /// Creates a new BasicCameraOptions struct. Parameters all have default values allowing for customization.
    /// - Parameters:
    ///   - confirmation: Determines what post image capture workflow the user enters into.
    ///   - capture: Determines if the user is taking one picture or multiple pictures, and the maximum number of pictures that can be taken.
    public init(
        confirmation: BasicCameraConfirmationSetting = .edit,
        capture: BasicCameraPictureCaptureSetting = .multi(max: 10)
    ) {
        self.confirmation = confirmation
        self.capture = capture
        let a = Int?.none
    }
    
    var showConfirmationPage: Bool {
        switch confirmation {
        case .none: false
        case .confirm: true
        case .edit: true
        }
    }
    
    var maxImageCount: Int {
        switch capture {
        case .single: 1
        case .multi(max: let max): max
        }
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
