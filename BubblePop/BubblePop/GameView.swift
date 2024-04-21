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

    init(gameTimeLimit: Int, maxBubbles: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(
            gameTimeLeft: gameTimeLimit, maxBubbles: maxBubbles))
    }
        
    var body : some View {
        ZStack {
            
            //Background
            Color.cyan
                .ignoresSafeArea()
            Color.white
            
            //Top-Text
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
            
            //Game Area
            ForEach(viewModel.bubbles) {
                bubble in Circle()
                    .position(bubble.position)
                    .frame(width: bubble.width)
                    .foregroundStyle(bubble.color)
                    .onTapGesture {
                        viewModel.addToScore(newScore: bubble.points)
                        viewModel.removeBubble(ID: bubble.id)
                    }
            }
            
            //Load High Score View
            if (showHighScores) {
                highScores
                    .transition(.move(edge: .trailing))
            }
        }
        
        //Countdown Timer
        .onReceive(viewModel.timer, perform: { _ in
            viewModel.countdown()
            if (viewModel.gameTimeLeft > 0) {
                viewModel.removeSomeBubbles()
                viewModel.generateBubbles()
            } else {
                //Timer End
                viewModel.saveScore()
                viewModel.sortHighScores()
                viewModel.removeAllBubbles()
                print("Timer over")
                viewModel.timer.upstream.connect().cancel()
                showHighScores = true
            }
        })
    }
    
    //Highscore View
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
    GameView(gameTimeLimit: 60, maxBubbles: 15)
}
