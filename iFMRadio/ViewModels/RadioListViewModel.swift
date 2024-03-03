//
//  RadioListViewViewModel.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 2/3/24.
//

import Foundation
import SwiftUI
import AVKit
import AudioStreaming
import MediaPlayer

class RadioListViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var playingRadio: RadioListModel = RadioListModel(id: 0, title: "No Radio Playing", url: URL(string: "https://nodo07-cloud01.streaming-pro.com:8005/flaixbac.mp3")!, image: "")
    @Published var radioList: [RadioListModel] = []
    var player = AudioPlayer()
    var nowPlayingInfo = [String : Any]()
    var dateTimer: Timer?

    func setUpMediaPlayerView() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.resume()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            self.pause()
            return .success
        }

        self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 50, height: 50), requestHandler: { (size) -> UIImage in
            return UIImage(imageLiteralResourceName: self.playingRadio.image)
        })
        nowPlayingInfo[MPMediaItemPropertyTitle] = playingRadio.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = playingRadio.title
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    func onAppear() {
        decodeRadioList()
    }
    func decodeRadioList() {
        guard let json = getJSON() else {
            print("JSON file couldn't be obtained.")
            return
        }
        do {
            let radios = try JSONDecoder().decode(Radios.self, from: json)
            radioList = radios.radios
        } catch {
            print(error.localizedDescription)
        }
    }
    func getJSON() -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: "radioList", ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                return try Data(contentsOf: fileUrl)
            }
        
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    func nextRadio() {
        if let currentIndex = radioList.firstIndex(where: { $0.title == playingRadio.title }) {
            var nextIndex = currentIndex + 1
            if currentIndex == 3 {
                nextIndex = 0
            }
            startPlaying(radio: radioList[nextIndex])
        }
    }
    func lastRadio() {
        if let currentIndex = radioList.firstIndex(where: { $0.title == playingRadio.title }) {
            var nextIndex = currentIndex - 1
            if currentIndex == 0 {
                nextIndex = 3
            }
            startPlaying(radio: radioList[nextIndex])
        }
    }

    func onTapGesture(radio: RadioListModel) {
        startPlaying(radio: radio)
    }
    func startPlaying(radio: RadioListModel) {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
            player.pause()
            playingRadio = radio
            player.play(url: radio.url)
            setUpMediaPlayerView()
            isPlaying = true
    }
    func pause() {
        player.pause()
        isPlaying = false
    }
    func resume() {
        player.resume()
        isPlaying = true
    }
    func setTimer(time: Double) {
        dateTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
    }
    func stop() {
        player.stop()
        playingRadio = RadioListModel(id: 0, title: "No Radio Playing", url: URL(string: "https://nodo07-cloud01.streaming-pro.com:8005/flaixbac.mp3")!, image: "")
    }
    @objc func timerFired() {
        stop()
    }
}
