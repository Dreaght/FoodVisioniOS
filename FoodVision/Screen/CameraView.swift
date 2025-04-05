import SwiftUI
import _PhotosUI_SwiftUI
import AVFoundation
import Photos

struct CameraView: View {
    @Environment(\.dismiss) var dismiss  // Allows closing the sheet
    @StateObject private var cameraModel = CameraModel()  // Camera logic
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var recentPhoto: UIImage?  // Store the recent photo

    var onImageCaptured: (UIImage) -> Void

    var body: some View {
        ZStack {
            CameraPreview(session: cameraModel.session)
                .ignoresSafeArea()

            VStack {
                Spacer()
                HStack {
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        if let recentPhoto = recentPhoto {
                            Image(uiImage: recentPhoto)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(.bottom, 40)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(.bottom, 40)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    Button(action: {
                        cameraModel.capturePhoto()
                    }) {
                        Circle()
                            .fill(Color.primary.opacity(0))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
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
            fetchRecentPhoto()  // Fetch the most recent photo on view appear
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .onChange(of: cameraModel.capturedImage, initial: false) {
            if let img = cameraModel.capturedImage {
                // Analyze or process the image if needed
                // For now, just pass it back using the closure
                onImageCaptured(img)
            }
        }
        .onChange(of: selectedItem, initial: false) { newItem, oldItem in
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                    let image = UIImage(data: data)
                    self.selectedImage = image
                    onImageCaptured(selectedImage ?? UIImage())
                }
            }
        }
    }

    // Function to fetch the most recent photo from the gallery
    private func fetchRecentPhoto() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let asset = fetchResult.firstObject {
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 100, height: 100)
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
                if let image = image {
                    recentPhoto = image
                }
            }
        }
    }
}
