import SwiftUI
import _PhotosUI_SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) var dismiss  // Allows closing the sheet
    @StateObject private var cameraModel = CameraModel()  // Camera logic
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var onImageCaptured: (UIImage) -> Void

    var body: some View {
        ZStack {
            CameraPreview(session: cameraModel.session)
                .ignoresSafeArea()

            VStack {
                Spacer()
                HStack {
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.bottom, 40)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    Button(action: {
                        cameraModel.capturePhoto()
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 3)
                            )
                    }
                    .padding(.bottom, 40)
                    Spacer()
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            cameraModel.startSession()
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .onChange(of: cameraModel.capturedImage, initial: false) {
            if let img = cameraModel.capturedImage {
                // Analyze or process the image if needed
                // For now, just pass it back using the closure
                onImageCaptured(img)
                dismiss()  // Close camera when image is captured
            }
        }
        .onChange(of: selectedItem, initial: false) {
            newItem, oldItem in
            guard let newItem = newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                    let image = UIImage(data: data) {
                    self.selectedImage = image
                    onImageCaptured(selectedImage ?? UIImage())
                    dismiss()
                }
            }
        }
        
    }
}
