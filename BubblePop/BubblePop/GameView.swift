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
            
            //BACKGROUND
            Color.cyan
                .ignoresSafeArea()
            Color.white
            
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Text("Score: \(viewModel.gameScore)")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.cyan)
                            .padding()
                        Spacer()
                        Text("Time left: \(viewModel.gameTimeLeft)")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.cyan)
                            .padding()
                    }
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
                        viewModel.addToScore(newScore: 1)
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
