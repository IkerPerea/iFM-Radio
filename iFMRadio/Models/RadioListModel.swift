//
//  RadioListModel.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 2/3/24.
//

import Foundation


class Radios: Decodable {
    let radios: [RadioListModel]
}
class RadioListModel: Identifiable, Decodable {
    let id: Int
    let title: String
    let url: URL
    let image: String
    init(id: Int, title: String, url: URL, image: String) {
        self.title = title
        self.url = url
        self.image = image
        self.id = id
    }
}
