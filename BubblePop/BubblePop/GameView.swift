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
    @State private var showHighScores = false

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
                        if (!showHighScores) {
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
                        
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            if (showHighScores) {
                highScores
                    .transition(.move(edge: .trailing))
            }
            
        }.onReceive(viewModel.timer, perform: { _ in
            viewModel.countdown()
            if (viewModel.gameTimeLeft > 0) {
                viewModel.generateBubbles()
            } else {
                viewModel.saveScore()
                viewModel.sortHighScores()
                viewModel.removeAllBubbles()
                print("Timer over")
                viewModel.timer.upstream.connect().cancel()
                showHighScores = true
            }
        })
    }
    
    var highScores : some View {
        VStack {
            Spacer()
            Text("HighScores")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.cyan)
                .padding()
            List {
                    ForEach(viewModel.sortedHighScores, id: \.0) { key, value in
                            Section {
                                Text("\(key) : \(value)")
                            }
                    }
            }
        }
    }
    
}

#Preview {
    GameView(gameTimeLimit: 10)
}
