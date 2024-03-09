//
//  RadioListModel.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 2/3/24.
//

import Foundation

class Record: Decodable {
    let record: Radios
}
class Radios: Decodable {
    let radios: [RadioListModel]
}
class RadioListModel: Identifiable, Decodable, Equatable {
    static func == (lhs: RadioListModel, rhs: RadioListModel) -> Bool {
        return true
    }
    
    let id: Int
    let title: String
    let url: URL
    let image: String
    var isFavorite: Bool
    init(id: Int, title: String, url: URL, image: String, isFavorite: Bool) {
        self.title = title
        self.url = url
        self.image = image
        self.id = id
        self.isFavorite = isFavorite
    }
}
