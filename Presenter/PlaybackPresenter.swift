//
//  PlaybackPresenter.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 19/3/22.
//
import AVFoundation
import Foundation
import UIKit


protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

/// THIS NEEDS TO BE RECAPPED
final class PlaybackPresenter{
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty{
            return track
        }
        else if let player = self.queuePlayer, !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    
    var playerVC: PlayerViewController?
    
    var player: AVPlayer?
    var queuePlayer: AVQueuePlayer?
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ){
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        
        player = AVPlayer(url: url)
        queuePlayer = AVQueuePlayer()
        
        player?.volume = 0.5 
        
        self.track = track
        self.tracks = []
        
        let vc = PlayerViewController()
        vc.title = track.name
        
        // Here, Right before presenting the controller, the tracks has been initialized, and the DATA source of the current controller has been set to this class i.e PlayBackPresenter (vc.dataSource = self)
        // In it's turn PlaybackPresenter extended from PlayerDataSource there for it can be used as a dataSource
        
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        
        self.playerVC = vc
        
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ){
        
        self.tracks = tracks
        self.track = nil
        
        
        //Part 19, 31:34
        self.queuePlayer = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "" ) else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.queuePlayer?.volume = 0.5
        self.queuePlayer?.play()
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing{
                player.pause()
            }
            else if player.timeControlStatus == .paused{
                player.play()
            }
        }
        else if let player = queuePlayer {
            if player.timeControlStatus == .playing{
                player.pause()
            }
            else if player.timeControlStatus == .paused{
                player.play()
            }
        }
    }
    
    
    
    func didTapForward() {
        if tracks.isEmpty {
            // No playlist or album
            player?.pause()
        } else if let player = queuePlayer {
            player.advanceToNextItem()
            index += 1
            print(index)
            playerVC?.refreshUI()
        }
    }
    
    
    func didTapBackwards() {
        if tracks.isEmpty {
            // No playlist or album
            player?.pause()
            player?.play()
        } else if let firstItem = queuePlayer?.items().first {
            queuePlayer?.pause()
            queuePlayer?.removeAllItems()
            queuePlayer? = AVQueuePlayer(items: [firstItem])
            queuePlayer?.play()
            queuePlayer?.volume = 0.5
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
}

extension PlaybackPresenter: PlayerDataSource {
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}


// PlayBackPresenter is static class and it can be accessed from anywhere therefore it can kick off the func that will present the "PlayerViewController"
