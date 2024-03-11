//
//  RadioListView.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 2/3/24.
//

import SwiftUI


struct RadioSearchView: View {
    @ObservedObject var radioViewModel: RadioListViewModel
    @Environment(\.colorScheme) var colorScheme
    @State public var isPresenting = false
    @State var searchText: String = ""
    @State var isFavoriteList: Bool = false
    @State var haptics: Bool = false
    @State var isGridView: Bool = false
    private let adaptiveColumn = [
           GridItem(.adaptive(minimum: 150))
       ]
    let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
    var body: some View {
            NavigationStack {
                VStack {
                    taskHorizontalList()
                    searchBar()
                    if isGridView {
                        ScrollView {
                            radioGridList()
                        }    
                    } else {
                        exploreList()
                    }
                    controls()
                }
                .padding(.bottom)
                .navigationTitle("iFM Radio")
            }
            .onChange(of: radioViewModel.radioList) {
                radioViewModel.filterRadioList()
            }
            .onAppear {
                radioViewModel.onAppear()
            }
            .sensoryFeedback(.increase, trigger: haptics)
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
            .sheet(isPresented: $isPresenting) {
                MusicPlayerView(radioViewModel: radioViewModel)
            }
    }
    func exploreList() -> some View {
       return NavigationStack {
            ScrollView {
                ForEach(radioViewModel.tagsList, id: \.self) { tag in
                    VStack {
                        HStack {
                            Text(tag)
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                        .padding(.all)
                            ScrollView(.horizontal) {
                                HStack {
                                    
                                ForEach(radioViewModel.radioList) { radio in
                                    if radio.tags.contains(tag) {
                                        RoundedRectangle(cornerRadius: 20.0)
                                            .onAppear {
                                                radioViewModel.loadFavorites()
                                            }
                                            .frame(width: 105, height: 110)
                                            .overlay {
                                                Image(radio.image)
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                    .clipShape(.circle)
                                                    .scaledToFit()
                                                if radio.isFavorite == true {
                                                    Image(systemName: "heart.fill")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 16, height: 16)
                                                        .foregroundStyle(.red)
                                                        .padding(.trailing, 70)
                                                        .padding(.top, 70)
                                                }
                                            }
                                            .onTapGesture {
                                                radioViewModel.onTapGesture(radio: radio)
                                                radioViewModel.loadFavorites()
                                            }
                                    }
                                }
                                .padding(.leading, 40)
                            }
                                .scrollIndicators(.never)
                                .scrollIndicators(.never)
                        }
                            .scrollIndicators(.never)
                    }
                    }
                }
            Spacer()
        }
    }
    fileprivate func radioGridList() -> some View {
        return LazyVGrid(columns: adaptiveColumn, spacing: 20) {
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
                                    .padding(.trailing, 120)
                                    .padding(.top, 120)
                            }
                        }
                        .onTapGesture {
                            radioViewModel.onTapGesture(radio: radio)
                            radioViewModel.loadFavorites()
                            haptics.toggle()
                        }
                }
            }
        
    }
    fileprivate func searchBar() -> some View {
        return HStack {
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
            if isGridView {
                Image(systemName: "square.grid.2x2.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.indigo)
                    .bold()
                    .onTapGesture {
                        isGridView = false
                    }
            } else {
                Image(systemName: "square.grid.2x2")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.indigo)
                    .bold()
                    .onTapGesture {
                        isGridView = true
                    }
            }
        }
    }
    fileprivate func taskHorizontalList() -> some View {
        return VStack {
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
        }
        
    }
    fileprivate func controls() -> some View {
        return VStack {
                        HStack {
                            Image(radioViewModel.playingRadio.image)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(.circle)
                                .padding([.leading, .trailing])
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
                            Button {
                                if radioViewModel.isPlaying {
                                    radioViewModel.pause()
                                    haptics.toggle()
                                } else {
                                    radioViewModel.resume()
                                    haptics.toggle()
                                }
                            } label: {
                                if radioViewModel.isPlaying {
                                        Image(systemName: "pause.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.indigo)
                                    } else {
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .tint(.indigo)
                                }
                            }
                            .padding(.trailing)
                        }
        }
        
    }

}

#Preview {
    RadioSearchView(radioViewModel: RadioListViewModel())
}


