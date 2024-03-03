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
    private let adaptiveColumn = [
           GridItem(.adaptive(minimum: 150))
       ]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(radioViewModel.radioList) { radio in
                        RoundedRectangle(cornerRadius: 20.0)
                            .frame(width: 155, height: 160)
                            .overlay {
                                Image(radio.image)
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                    .clipShape(.circle)
                                    .scaledToFit()
                            }
                            .onTapGesture {
                                radioViewModel.onTapGesture(radio: radio)
                            }
                    }
                }
            }
            VStack {
                controls()
            }
                .navigationTitle("iFM Radio")
        }
        .onAppear {
            radioViewModel.onAppear()
        }
        .sheet(isPresented: $isPresenting) {
            MusicPlayerView(radioViewModel: radioViewModel)
        }
        .padding()
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
                                } else {
                                    radioViewModel.resume()
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
