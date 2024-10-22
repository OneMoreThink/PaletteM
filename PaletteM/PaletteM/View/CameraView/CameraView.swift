//
//  CameraView.swift
//  PaletteM
//
//  Created by 이종선 on 10/22/24.
//

import SwiftUI
import AVFoundation

// MARK: - Camera View
struct CameraView: View {
    @Binding var isShowView: Bool
    @StateObject private var cameraModel = CameraViewModel()
    @EnvironmentObject var colorExtractor: ColorExtractorViewModel
    @State private var path: [NavigationDestination] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if cameraModel.isTaken {
                    if let image = cameraModel.capturedImage {
                        PreviewView(image: image,
                                  retake: {
                            withAnimation {
                                cameraModel.isTaken = false
                                cameraModel.capturedImage = nil
                                cameraModel.startSession()
                            }
                        }, confirm: {
                            colorExtractor.selectImage(image)
                            path.append(.resultView)
                        })
                    }
                } else {
                    CameraPreview(session: cameraModel.session)
                        .ignoresSafeArea()
                    
                    // Camera UI
                    VStack {
                        HStack {
                            Button {
                                isShowView = false
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Button {
                            cameraModel.capturePhoto()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .resultView:
                    ResultView(path: $path, isShowView: $isShowView)
                }
            }
            .toolbar(.hidden)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            cameraModel.checkPermission()
        }
    }
}
