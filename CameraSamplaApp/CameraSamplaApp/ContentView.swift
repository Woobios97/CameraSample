//
//  ContentView.swift
//  CameraSamplaApp
//
//  Created by woosub kim  on 7/4/24.
//

//import SwiftUI
//import AVFoundation
//
//struct ContentView: View {
//    @State private var view: UIView?
//
//    var body: some View {
//        ZStack {
//            if view != nil {
//                CameraView(view: $view)
//                    .edgesIgnoringSafeArea(.all)
//            } else {
//                Color.black.edgesIgnoringSafeArea(.all)
//            }
//
//            VStack {
//                Spacer()
//                Button(action: {
//                    if let coordinator = (view?.subviews.first { $0 is AVCaptureVideoPreviewLayer }?.delegate as? CameraView.Coordinator) {
//                        coordinator.capturePhoto()
//                    }
//                }) {
//                    Text("Capture")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .clipShape(Circle())
//                        .padding()
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
