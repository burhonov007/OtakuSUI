//
//  VideoPlayerView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 01/09/24.
//

import SwiftUI
import AVKit


struct VideoPlayerView: View {
    @State private var player: AVPlayer?
    @State var videoURLString: String
    @State private var showAlert: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    
    
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                guard let url = URL(string: videoURLString) else {
                    showAlert.toggle()
                    return
                }
                
                let headers = ["User-Agent": RequestSender.userAgent]
                let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
                
                asset.loadValuesAsynchronously(forKeys: ["playable"]) {
                    var error: NSError? = nil
                    let status = asset.statusOfValue(forKey: "playable", error: &error)
                    
                    switch status {
                    case .loaded:
                        DispatchQueue.main.async {
                            let playerItem = AVPlayerItem(asset: asset)
                            player = AVPlayer(playerItem: playerItem)
                        }
                    case .failed:
                        DispatchQueue.main.async {
                            showAlert.toggle()
                        }
                    case .cancelled:
                        DispatchQueue.main.async {
                            showAlert.toggle()
                        }
                    @unknown default:
                        DispatchQueue.main.async {
                            showAlert.toggle()
                        }
                    }
                }
            }
            .onDisappear {
                player?.pause()
            }
        
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Видео не доступно"),
                    dismissButton: .cancel(Text("Ок")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        
    }
    
}

#Preview {
    VideoPlayerView(videoURLString: "https://example.com/video.mp4")
}
