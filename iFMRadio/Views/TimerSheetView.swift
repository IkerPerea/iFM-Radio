//
//  TimerSheetView.swift
//  iFMRadio
//
//  Created by Iker Perea Trejo on 3/3/24.
//

import SwiftUI

struct TimerSheetView: View {
    @ObservedObject var radioViewModel: RadioListViewModel
    var body: some View {
        VStack {
            Text("Set a Timer")
                .padding(.all)
                .bold()
                .font(.title2)
            List {
                Button {
                    radioViewModel.setTimer(time: 6.0)
                } label: {
                 Text("6 segundos")
                }
                .bold()
                .foregroundStyle(.indigo)
                Button {
                    radioViewModel.setTimer(time: 900.0)
                } label: {
                 Text("15 minutos")
                }
                .bold()
                .foregroundStyle(.indigo)
                Button {
                    radioViewModel.setTimer(time: 1800.0)
                } label: {
                 Text("30 minutos")
                }
                .bold()
                .foregroundStyle(.indigo)
                Button {
                    radioViewModel.setTimer(time: 2700.0)
                } label: {
                 Text("45 minutos")
                }
                .bold()
                .foregroundStyle(.indigo)
                Button {
                    radioViewModel.setTimer(time: 3600.0)
                } label: {
                 Text("60 minutos")
                }
                .bold()
                .foregroundStyle(.indigo)
            }
        }
    }
}

#Preview {
    TimerSheetView(radioViewModel: RadioListViewModel())
}
