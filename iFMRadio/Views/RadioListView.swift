//
//  RadioListView.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 2/3/24.
//

import SwiftUI


struct RadioListView: View {
    @ObservedObject var radioViewModel: RadioListViewModel
    @Environment(\.colorScheme) var colorScheme
    @State public var isPresenting = false
    @State var searchText: String = ""
    @State var isFavoriteList: Bool = false
    @State var isPlaying: Bool = false
    private let adaptiveColumn = [
           GridItem(.adaptive(minimum: 150))
       ]
    let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
    var body: some View {
        NavigationStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(radioViewModel.tagsList, id: \.self) { tag in
                            NavigationLink(destination: TagRadioListView(tag: tag, radioViewModel: radioViewModel)) {
                                if tag == "Music" {
                                    Image(systemName: "music.note")
                                } else if tag == "Sports" {
                                    Image(systemName: "soccerball")
                                } else if tag == "English" {
                                    Image(systemName: "person.2.wave.2")
                                } else if tag == "News" {
                                    Image(systemName: "newspaper")
                                }
                                Text(tag)
                            }
                            .buttonStyle(.bordered)
                            .foregroundStyle(.indigo)
                        }
                    
                    }
                    }
                .scrollIndicators(.hidden)
                .padding(.leading)
                .padding(.trailing)
            HStack {
                TextField("Type to Search...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                Image(systemName: "magnifyingglass.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.indigo)
                    .bold()
                    .onTapGesture {
                        radioViewModel.searchRadioResults = radioViewModel.radioList
                        searchText = ""
                    }
                if isFavoriteList {
                    Image(systemName: "star.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.indigo)
                        .bold()
                        .padding(.trailing)
                        .onTapGesture {
                                radioViewModel.searchRadioResults = radioViewModel.radioList
                                isFavoriteList = false
                        }
                } else {
                    Image(systemName: "star.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.indigo)
                        .bold()
                        .padding(.trailing)
                        .onTapGesture {
                                isFavoriteList = true
                                radioViewModel.searchRadioResults = []
                                radioViewModel.radioList.forEach { radio in
                                    if radio.isFavorite {
                                        radioViewModel.searchRadioResults.append(radio)
                                    }
                                }
                        }
                }
            }
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(radioViewModel.searchRadioResults) { radio in
                        RoundedRectangle(cornerRadius: 20.0)
                            .onAppear {
                                radioViewModel.loadFavorites()
                            }
                            .frame(width: 155, height: 160)
                            .overlay {
                                Image(radio.image)
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                    .clipShape(.circle)
                                    .scaledToFit()
                                if radio.isFavorite == true {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.red)
                                        .padding(.trailing, 110)
                                        .padding(.top, 110)
                                }
                            }
                            .onTapGesture {
                                radioViewModel.onTapGesture(radio: radio)
                                radioViewModel.loadFavorites()
                            }
                    }
                }
            }
                controls()
            
                .navigationTitle("iFM Radio")
        }
        .onChange(of: radioViewModel.radioList) {
            radioViewModel.filterRadioList()
        }
        .sensoryFeedback(.start, trigger: isPlaying)
        .onChange(of: searchText) { newValue in
            if newValue.isEmpty {
                radioViewModel.searchRadioResults = radioViewModel.radioList
            } else {
                radioViewModel.searchRadioResults = radioViewModel.radioList.filter { note in
                    note.title.contains(newValue)
                }
            }
        }
        .onDisappear {
            radioViewModel.onDissapear()
        }
        .task {
            await radioViewModel.onAppear()
        }
        .sheet(isPresented: $isPresenting) {
            MusicPlayerView(radioViewModel: radioViewModel)
        }
    }
    fileprivate func controls() -> some View {
        return VStack {
            RoundedRectangle(cornerRadius: 32.0)
                .frame(width: 350, height: 160)
                .overlay {
                    VStack {
                        HStack {
                            Image(radioViewModel.playingRadio.image)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(.circle)
                                .padding(.all)
                            Text("\(radioViewModel.playingRadio.title)")
                                .padding(.all)
                                .foregroundStyle(.indigo)
                                .underline()
                                .bold()
                                .padding(.trailing, 25)
                            Image(systemName: "chevron.up")
                                .resizable()
                                .frame(width: 20, height: 10)
                                .padding(.all)
                                .foregroundStyle(.indigo)
                                .bold()
                                .onTapGesture {
                                    isPresenting = true
                                }
                        }
                        .padding(.top, 20)
                        Spacer()
                        HStack {
                            Button {
                                radioViewModel.lastRadio()
                                isPlaying.toggle()
                            } label: {
                                    if colorScheme == .dark {
                                        Image(systemName: "backward.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.black)
                                    } else {
                                        Image(systemName: "backward.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.white)
                                    }
                            }
                            .padding(.all)
                            Button {
                                if radioViewModel.isPlaying {
                                    radioViewModel.pause()
                                    isPlaying.toggle()
                                } else {
                                    radioViewModel.resume()
                                    isPlaying.toggle()
                                }
                            } label: {
                                if radioViewModel.isPlaying {
                                    if colorScheme == .dark {
                                        Image(systemName: "pause.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.black)
                                    } else {
                                        Image(systemName: "pause.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.white)
                                    }
                                } else {
                                    if colorScheme == .dark {
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.black)
                                    } else {
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.white)
                                    }
                                }
                            }
                            .padding(.all)
                            Button {
                                isPlaying.toggle()
                                radioViewModel.nextRadio()
                            } label: {
                                    if colorScheme == .dark {
                                        Image(systemName: "forward.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.black)
                                    } else {
                                        Image(systemName: "forward.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.white)
                                    }
                            }
                            .padding(.all)
                        }
                        .padding(.bottom, 30)
                        // End Of HStack
                    }
                }
        }
        
    }

}

#Preview {
    RadioListView(radioViewModel: RadioListViewModel())
}
