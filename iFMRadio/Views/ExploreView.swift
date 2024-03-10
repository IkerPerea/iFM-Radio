//
//  ExploreView.swift
//  iFMRadio
//
//  Created by Iker Perea on 10/3/24.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject var radioViewModel: RadioListViewModel
    @State var isPresenting: Bool = false
    @State var haptics: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            TabView {
                NavigationStack {
                    exploreList()
                    controls()
                        .padding(.bottom)
                }
                .tabItem { Label("Explore", systemImage: "binoculars") }
                RadioSearchView(radioViewModel: radioViewModel)
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            }
            .onDisappear {
                radioViewModel.onDissapear()
            }
            .task {
                radioViewModel.onAppear()
            }
                .navigationTitle("iFM Radio")
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
    ExploreView(radioViewModel: RadioListViewModel())
}
