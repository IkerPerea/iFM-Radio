//
//  MusicPlayerView.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 3/3/24.
//

import SwiftUI

struct MusicPlayerView: View {
    @ObservedObject var radioViewModel: RadioListViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var isFavorite = false
    @State var isPresented: Bool = false
    @State var isPlaying: Bool = true
    var body: some View {
        NavigationStack {
            VStack {
                Text(radioViewModel.playingRadio.title)
                    .bold()
                    .font(.title)
                    .padding(.all)
                Image(radioViewModel.playingRadio.image)
                    .resizable()
                    .frame(width: 300, height: 300)
                Spacer()
                controls()
                    .padding(.all)
                extraControls()
                    .padding(.all)
            }
        }
        .onAppear {
            if radioViewModel.playingRadio.isFavorite == true {
                isFavorite = true
            }
        }
        .onDisappear {
            radioViewModel.onDissapear()
        }
        .sheet(isPresented: $isPresented) {
            TimerSheetView(radioViewModel: radioViewModel)
                .presentationDetents([.fraction(0.45)])
        }
        
    }
    fileprivate func extraControls() -> some View {
        return VStack {
            HStack {
                Image(systemName: "timer")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        isPresented = true
                    }
                if isFavorite == true {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundStyle(.red)
                        .scaledToFill()
                        .frame(width: 25, height: 25)
                        .padding(.all)
                        .onTapGesture {
                            print("Favorited")
                            radioViewModel.setFavorite()
                            radioViewModel.saveFavorites()
                            isFavorite = false
                        }
                } else {
                    Image(systemName: "heart")
                        .resizable()
                        .foregroundStyle(.red)
                        .scaledToFill()
                        .frame(width: 25, height: 25)
                        .padding(.all)
                        .onTapGesture {
                            print("Favorited")
                            radioViewModel.setFavorite()
                            radioViewModel.saveFavorites()
                            isFavorite = true
                        }
                }
            }
        }
    }
    fileprivate func controls() -> some View {
        return VStack {
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                radioViewModel.lastRadio()
                            } label: {
                                    if colorScheme == .dark {
                                        Image(systemName: "backward.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "backward.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.black)
                                    }
                            }
                            .padding(.all)
                            Button {
                                if radioViewModel.isPlaying {
                                    radioViewModel.pause()
                                    isPlaying = false
                                } else {
                                    radioViewModel.resume()
                                    isPlaying = true
                                }
                            } label: {
                                if radioViewModel.isPlaying {
                                    if colorScheme == .dark {
                                        Image(systemName: "pause.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "pause.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.black)
                                    }
                                } else {
                                    if colorScheme == .dark {
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.black)
                                    }
                                }
                            }
                            .sensoryFeedback(.success, trigger: isPlaying)
                            .padding(.all)
                            Button {
                                radioViewModel.nextRadio()
                            } label: {
                                    if colorScheme == .dark {
                                        Image(systemName: "forward.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "forward.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.black)
                                    }
                            }
                            .padding(.all)
                        }
                        Spacer()
                        // End Of HStack
                    
                }
        }
        
    }

}

#Preview {
    MusicPlayerView(radioViewModel: RadioListViewModel())
}


