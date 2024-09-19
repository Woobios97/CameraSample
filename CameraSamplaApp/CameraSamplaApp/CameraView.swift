//
//  CameraView.swift
//  CameraSamplaApp
//
//  Created by woosub kim  on 7/4/24.
//

//import SwiftUI
//import AVFoundation
//
//struct CameraView: UIViewControllerRepresentable {
//    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
//        var parent: CameraView
//        var capturePhotoOutput: AVCapturePhotoOutput!
//
//        init(parent: CameraView) {
//            self.parent = parent
//            super.init()
//            setupCaptureSession()
//        }
//
//        func setupCaptureSession() {
//            let captureSession = AVCaptureSession()
//            captureSession.sessionPreset = .photo
//
//            guard let backCamera = AVCaptureDevice.default(for: .video) else {
//                print("Unable to access back camera!")
//                return
//            }
//
//            do {
//                let input = try AVCaptureDeviceInput(device: backCamera)
//                if captureSession.canAddInput(input) {
//                    captureSession.addInput(input)
//                }
//
//                capturePhotoOutput = AVCapturePhotoOutput()
//                capturePhotoOutput.isHighResolutionCaptureEnabled = true
//                if captureSession.canAddOutput(capturePhotoOutput) {
//                    captureSession.addOutput(capturePhotoOutput)
//                }
//
//                try backCamera.lockForConfiguration()
//                if let format = backCamera.formats.first(where: { $0.highResolutionStillImageDimensions.width == 1280 && $0.highResolutionStillImageDimensions.height == 720 }) {
//                    backCamera.activeFormat = format
//                }
//                backCamera.unlockForConfiguration()
//
//                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//                previewLayer.videoGravity = .resizeAspectFill
//                DispatchQueue.main.async {
//                    if let view = self.parent.view {
//                        previewLayer.frame = view.layer.bounds
//                        view.layer.addSublayer(previewLayer)
//                    }
//                }
//
//                captureSession.startRunning()
//
//            } catch {
//                print("Error setting up camera: \(error)")
//            }
//        }
//
//        func capturePhoto() {
//            let settings = AVCapturePhotoSettings()
//            settings.isHighResolutionPhotoEnabled = true
//            capturePhotoOutput.capturePhoto(with: settings, delegate: self)
//        }
//
//        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//            if let error = error {
//                print("Error capturing photo: \(error)")
//                return
//            }
//
//            guard let imageData = photo.fileDataRepresentation() else { return }
//            if let image = UIImage(data: imageData) {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            }
//        }
//    }
//
//    @Binding var view: UIView?
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        DispatchQueue.main.async {
//            self.view = viewController.view
//        }
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//}
