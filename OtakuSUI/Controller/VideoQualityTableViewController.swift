//
//  VideoQualityTableViewController.swift
//  AniLab
//
//  Created by The WORLD on 12/09/23.
//

import UIKit
import AVKit
import AVFoundation


class VideoQualityTableViewController: UITableViewController {

    var videoQuality = [VideoQuality]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if videoQuality.isEmpty {
            Alerts.AccessDeniedAlertOrNoData(title: "Запрещено", message: "К сожалению, в вашей стране это видео недоступно.", viewController: self)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoQuality.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VideoQualityTableViewCell
        cell.title.text = videoQuality[indexPath.row].title
        cell.link.text = videoQuality[indexPath.row].link
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let viewModel = DownloadViewModel()
        let userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.0.0 Safari/537.36 OPR/100.0.0.0"
        let videoURL = URL(string: videoQuality[indexPath.row].link)!
        
        let alert = UIAlertController(title: "Выберете де действие", message: "", preferredStyle: .alert)
        
        let SeeButton = UIAlertAction(title: "Смотреть", style: .default) { [self] alertAction in
            let headers = ["User-Agent": userAgent]
            let asset = AVURLAsset(url: videoURL, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.play()
            }
        }
        
        let DownloadButton = UIAlertAction(title: "Скачать", style: .cancel) { alertAction in
//            viewModel.downloadVideo(url: videoURL, UserAgent: userAgent)
        }
        
        _ = UIAlertAction(title: "OK", style: .cancel) { alertAction in
            
        }
        
        alert.addAction(DownloadButton)
        alert.addAction(SeeButton)
        self.present(alert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

