//
//  GameView.swift
//  BubblePop
//
//  Created by Dylan Archer on 2/4/2024.
//

import Foundation
import SwiftUI

struct GameView: View {
    
    @StateObject var viewModel :GameViewModel
    
    init(gameTimeLimit: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(gameTimeLeft: gameTimeLimit))
    }
        
    var body : some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    Text("Time left: \(viewModel.gameTimeLeft)")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.cyan)
                        .padding()
                    Text("Name: \(viewModel.username)")
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.cyan)
                .onAppear {
                }
            }
            ForEach(viewModel.bubbles) { 
                bubble in Circle()
                    .position(bubble.position)
                    .frame(width: bubble.width)
                    .onTapGesture {
                        print("Bubble Popped")
                        viewModel.addToScore(newScore: 1)
                        print("Score is: \(viewModel.gameScore)")
                    }
            }
            
            
        }.onReceive(viewModel.timer, perform: { _ in
            viewModel.countdown()
            if (viewModel.gameTimeLeft > 0) {
                viewModel.generateBubbles()
            } else {
                viewModel.saveScore()
                //LOAD NEW VIEW HERE
            }
        })
    }
}

#Preview {
    GameView(gameTimeLimit: 10)
}
