import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) var dismiss  // Allows closing the sheet
    @StateObject private var cameraModel = CameraModel()  // Camera logic
    
    var onImageCaptured: (UIImage) -> Void

    var body: some View {
        ZStack {
            CameraPreview(session: cameraModel.session)
                .ignoresSafeArea()

            VStack {
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
            }
        }
        .onAppear {
            cameraModel.startSession()
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .onChange(of: cameraModel.capturedImage) { _ in
            if let img = cameraModel.capturedImage {
                // Analyze or process the image if needed
                // For now, just pass it back using the closure
                onImageCaptured(img)
                
                dismiss()  // Close camera when image is captured
            }
        }
    }
}
