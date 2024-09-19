import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
  var captureSession: AVCaptureSession!
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  var capturePhotoOutput: AVCapturePhotoOutput!

  override func viewDidLoad() {
    super.viewDidLoad()
    checkCameraPermission()
  }

  func checkCameraPermission() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      setupCaptureSession()
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          DispatchQueue.main.async {
            self.setupCaptureSession()
          }
        } else {
          print("Camera access denied")
        }
      }
    case .denied, .restricted:
      print("Camera access denied or restricted")
    @unknown default:
      print("Unknown camera authorization status")
    }
  }

  func setupCaptureSession() {
    captureSession = AVCaptureSession()
    captureSession.sessionPreset = .photo

    guard let backCamera = AVCaptureDevice.default(for: .video) else {
      print("Unable to access back camera!")
      return
    }

    do {
      let input = try AVCaptureDeviceInput(device: backCamera)
      captureSession.addInput(input)

      capturePhotoOutput = AVCapturePhotoOutput()
      capturePhotoOutput.isHighResolutionCaptureEnabled = true
      captureSession.addOutput(capturePhotoOutput)

      try backCamera.lockForConfiguration()
      if let format = backCamera.formats.first(where: { $0.highResolutionStillImageDimensions.width == 1280 && $0.highResolutionStillImageDimensions.height == 720 }) {
        backCamera.activeFormat = format
      }
      backCamera.unlockForConfiguration()

      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer.videoGravity = .resizeAspectFill
      videoPreviewLayer.frame = view.layer.bounds
      view.layer.addSublayer(videoPreviewLayer)

      captureSession.startRunning()
    } catch {
      print("Error setting up camera: \(error)")
    }
  }

  func capturePhoto() {
    let settings = AVCapturePhotoSettings()
    settings.isHighResolutionPhotoEnabled = true
    capturePhotoOutput.capturePhoto(with: settings, delegate: self)
  }

  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
      print("Error capturing photo: \(error)")
      return
    }

    guard let imageData = photo.fileDataRepresentation() else {
      print("Error converting photo to data")
      return
    }

    if let image = UIImage(data: imageData) {
      print("Attempting to save photo to album")
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    } else {
      print("Error converting data to image")
    }
  }

  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      print("Error saving photo: \(error.localizedDescription)")
    } else {
      print("Photo saved successfully!")
    }
  }
}

import SwiftUI

class CameraViewModel: ObservableObject {
  private var viewController: CameraViewController?

  func setViewController(_ viewController: CameraViewController) {
    self.viewController = viewController
  }

  func capturePhoto() {
    viewController?.capturePhoto()
  }
}

struct CameraView: UIViewControllerRepresentable {
  @ObservedObject var viewModel: CameraViewModel

  func makeUIViewController(context: Context) -> CameraViewController {
    let viewController = CameraViewController()
    viewModel.setViewController(viewController)
    return viewController
  }

  func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

import SwiftUI

struct ContentView: View {
  @StateObject private var cameraViewModel = CameraViewModel()

  var body: some View {
    ZStack {
      CameraView(viewModel: cameraViewModel)
        .edgesIgnoringSafeArea(.all)

      VStack {
        Spacer()
        Button(action: {
          cameraViewModel.capturePhoto()
        }) {
          Text("Capture")
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(Circle())
            .padding()
        }
      }
    }
  }
}

@main
struct CameraApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
