//
//  TagRadioListView.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 9/3/24.
//

import SwiftUI

struct TagRadioListView: View {
    @State var tag: String
    @ObservedObject var radioViewModel: RadioListViewModel
    private let adaptiveColumn = [
           GridItem(.adaptive(minimum: 150))
       ]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(radioViewModel.searchRadioResults) { radio in
                        if radio.tags.contains(tag) {
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
                                }
                        }
                    }
                }
            }
            .navigationTitle("\(tag.capitalized)")
        }
    }
}

#Preview {
    TagRadioListView(tag: "Music", radioViewModel: RadioListViewModel())
}
