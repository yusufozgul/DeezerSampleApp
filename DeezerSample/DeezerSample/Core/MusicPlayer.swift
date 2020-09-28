//
//  MusicPlayer.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import MediaPlayer
import AVFoundation

struct NowPlayingProgress {
    var elapsedTime: Double = 0.0
    var duration: Double = 0.0
}

protocol MusicPlayerProtocol {
    var currentPlay: AlbumDetailTrackListData? { get }
    func setTrackList(trackItems: [AlbumDetailTrackListData])
    func togglePlayback()
    func play()
    func pause()
    func previousTrack()
    func nextTrack()
}

class MusicPlayer : MusicPlayerProtocol {
    static var player = MusicPlayer()
    private var avPlayer: AVQueuePlayer!
    private var itemList: [AVPlayerItem: AlbumDetailTrackListData] = [:]
    var currentPlay: AlbumDetailTrackListData?
    
    var nowPlayingProgress: NowPlayingProgress {
        return NowPlayingProgress(
            elapsedTime: avPlayer.currentTime().seconds,
            duration: avPlayer.currentItem?.asset.duration.seconds ?? 0.0
        )
    }
    
    init() { }
    
    func setTrackList(trackItems: [AlbumDetailTrackListData]) {
        var items: [AVPlayerItem] = []
        itemList.removeAll()
        for track in trackItems {
            let item = AVPlayerItem(url: URL(string: track.preview)!)
            items.append(item)
            itemList[item] = track
        }
        avPlayer = AVQueuePlayer(items: items)
        avPlayer.actionAtItemEnd = .advance
        avPlayer.rate = 1
        configureMediaPlayerRemote()
        updateNowPlayingInfo()
    }
    
    func togglePlayback() {
        guard avPlayer.currentItem != nil else { return }
        if avPlayer.rate == 0.0 {
            play()
        } else {
            pause()
        }
    }
    
    func play() {
        avPlayer.play()
        updatePlaybackInfo()
    }
    
    func pause() {
        avPlayer.pause()
        updatePlaybackInfo()
    }
    
    func previousTrack() {
        avPlayer.seek(to: .zero)
        updatePlaybackInfo()
    }
    
    @objc func nextTrack() {
        avPlayer.advanceToNextItem()
        updatePlaybackInfo()
        updateNowPlayingInfo()
    }
    func seek(to time: TimeInterval) {
        avPlayer.seek(to: CMTime(seconds: time, preferredTimescale: 1000)) { [weak self] completed in
            guard completed else { return }
            self?.updateNowPlayingInfo()
        }
    }
    
    private func updateNowPlayingInfo() {
        guard let currentItem = avPlayer.currentItem, let trackDetail = itemList[currentItem]else {
            updatePlaybackInfo()
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLAYER_STATUS"), object: nil, userInfo: ["hide": true])
            return
        }
        let albumImage: UIImage = UIImage(systemName: "music.quarternote.3")!
//        LoadAlbumImage.load(from: trackDetail.albumImage) { (image) in
//            albumImage = image
//        }
        var nowPlayingInfo: [String : Any] = [
            MPNowPlayingInfoPropertyElapsedPlaybackTime: nowPlayingProgress.elapsedTime as NSNumber,
            MPNowPlayingInfoPropertyPlaybackRate: 1,
            MPMediaItemPropertyTitle: trackDetail.title ,
            MPMediaItemPropertyPlaybackDuration: currentItem.asset.duration.seconds,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: albumImage.size) { size in
                return UIGraphicsImageRenderer(size: size).image { _ in
                    albumImage.draw(in: CGRect(origin: .zero, size: size))
                }
            }
        ]
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = trackDetail.albumName
        nowPlayingInfo[MPMediaItemPropertyArtist] = trackDetail.artistName
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLAYER_STATUS"), object: trackDetail, userInfo: ["isPlay": avPlayer.rate != 0])
    }
    
    @objc private func updatePlaybackInfo() {
        guard var info = MPNowPlayingInfoCenter.default().nowPlayingInfo else { return }
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = nowPlayingProgress.elapsedTime
        info[MPNowPlayingInfoPropertyPlaybackRate] = 1
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLAYER_STATUS"), object: nil, userInfo: ["isPlay": avPlayer.rate != 0])
    }
    
    private func configureMediaPlayerRemote() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(nextTrack),
                name: .AVPlayerItemDidPlayToEndTime,
                object: nil)
        } catch {
            print("Failed to activate the AVAudioSession: \(error)")
        }
        
        let remote = MPRemoteCommandCenter.shared()
        remote.togglePlayPauseCommand.addTarget(self) { $0.togglePlayback() }
        remote.playCommand.addTarget(self) { $0.play() }
        remote.pauseCommand.addTarget(self) { $0.pause() }
        remote.previousTrackCommand.addTarget(self) { $0.previousTrack() }
        remote.nextTrackCommand.addTarget(self) { $0.nextTrack() }
    
        remote.changePlaybackPositionCommand.isEnabled = true
        remote.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let _self = self,
                  let event = event as? MPChangePlaybackPositionCommandEvent
            else { return .noSuchContent }
            _self.seek(to: event.positionTime)
            return .success
        }
    }
}

private extension MPRemoteCommand {
    func addTarget(_ player: MusicPlayer, handler: @escaping (MusicPlayer) -> Void) {
        isEnabled = true
        addTarget { [weak player] _ in
            guard let player = player else { return .noSuchContent }
            handler(player)
            return .success
        }
    }
}
