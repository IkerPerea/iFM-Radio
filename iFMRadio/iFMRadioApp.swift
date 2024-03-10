//
//  iFMRadioApp.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 2/3/24.
//

import SwiftUI

@main
struct iFMRadioApp: App {
    @ObservedObject var radioListViewModel = RadioListViewModel()
    var body: some Scene {
        WindowGroup {
            ExploreView(radioViewModel: radioListViewModel)
        }
    }
}
