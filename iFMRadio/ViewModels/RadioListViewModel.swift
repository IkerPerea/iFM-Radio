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
    // MARK: - Variables
    @Published var isPlaying = false
    @Published var playingRadio: RadioListModel = RadioListModel(id: 0, title: "No Radio Playing", url: URL(string: "https://nodo07-cloud01.streaming-pro.com:8005/flaixbac.mp3")!, image: "", isFavorite: false)
    @Published var radioList: [RadioListModel] = []
    @Published var filteredRadioList: [RadioListModel] = []
    @Published var searchRadioResults: [RadioListModel] = []
    var player = AudioPlayer()
    var nowPlayingInfo = [String : Any]()
    var dateTimer: Timer?
    var isFavoriteList: [Bool] = []
    // MARK: - Media Player
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
    // MARK: - Data Download
    func fetchRadioList() async {
        print("Fetching")
        guard let url = URL(string: "https://api.jsonbin.io/v3/b/65e5c9a4dc74654018ada222") else { return }
        fetchData(at: url) { completion in
            switch completion {
            case .success(let finalRadioList):
                self.radioList = finalRadioList
                self.searchRadioResults = self.radioList
                self.loadFavorites()
                print("Sucess")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    func fetchData(at url: URL, completion: @escaping (Result<[RadioListModel], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let list = try JSONDecoder().decode(Record.self, from: data)
                    completion(.success(list.record.radios))
                } catch let decoderError {
                    completion(.failure(decoderError))
                    print(decoderError.localizedDescription)
                }
            }
        }.resume()
    }
    // MARK: - Timer
    func setTimer(time: Double) {
        dateTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
    }
    @objc func timerFired() {
        stop()
    }
    // MARK: - View
    func onAppear() async {
        await fetchRadioList()
    }
    func onTapGesture(radio: RadioListModel) {
        startPlaying(radio: radio)
    }
    func onDissapear() {
        saveFavorites()
    }
    // MARK: - Radio
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
    func nextRadio() {
        if let currentIndex = radioList.firstIndex(where: { $0.title == playingRadio.title }) {
            var nextIndex = currentIndex + 1
            if currentIndex == 4 {
                nextIndex = 0
            }
            startPlaying(radio: radioList[nextIndex])
        }
    }
    func lastRadio() {
        if let currentIndex = radioList.firstIndex(where: { $0.title == playingRadio.title }) {
            var nextIndex = currentIndex - 1
            if currentIndex == 0 {
                nextIndex = 4
            }
            startPlaying(radio: radioList[nextIndex])
        }
    }
    func stop() {
        player.stop()
        playingRadio = RadioListModel(id: 0, title: "No Radio Playing", url: URL(string: "https://nodo07-cloud01.streaming-pro.com:8005/flaixbac.mp3")!, image: "", isFavorite: false)
    }
    func pause() {
        player.pause()
        isPlaying = false
    }
    func resume() {
        player.resume()
        isPlaying = true
    }
    // MARK: - UserDefaults
    func saveFavorites() {
        print("Favorites Saved")
        radioList.forEach { radio in
            if radio.isFavorite == true {
                isFavoriteList[radio.id] = true
            } else {
                isFavoriteList[radio.id] = false
            }
        }
        UserDefaults.standard.setValue(isFavoriteList, forKey: "favoriteList")
    }
    func loadFavorites() {
        print("Favorites Loaded")
        self.isFavoriteList = UserDefaults.standard.array(forKey: "favoriteList") as? [Bool] ?? [false, false, false, false, false]
        if isFavoriteList.isEmpty {
            isFavoriteList = [false, false, false, false, false]
        }
        radioList.forEach { radio in
            let index = radio.id
            print(radio.id)
            radio.isFavorite = isFavoriteList[index]
        }
    }
    func filterRadioList() {
        filteredRadioList = radioList
        filteredRadioList = filteredRadioList.filter { $0.isFavorite == true }
        radioList.forEach { radio in
            if radio.isFavorite == false {
                filteredRadioList.append(radio)
            }
        }
    }
    func setFavorite() {
        if playingRadio.isFavorite == true {
            radioList[playingRadio.id].isFavorite = false
            playingRadio = radioList[playingRadio.id]
        } else {
            radioList[playingRadio.id].isFavorite = true
            playingRadio = radioList[playingRadio.id]
        }
        saveFavorites()
    }
}
