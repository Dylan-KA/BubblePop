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
            VStack {
                HStack {
                    if (!showHighScores) {
                        VStack {
                            Text("High Score: ")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.cyan)
                            Text("\(viewModel.getHighestScore())")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.cyan)
                        }
                        Spacer()
                        VStack {
                            Text("Score:")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.cyan)
                            Text("\(viewModel.gameScore)")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.cyan)
                        }
                        Spacer()
                        VStack {
                            Text("Time left:")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.cyan)
                            Text("\(viewModel.gameTimeLeft)")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.cyan)
                        }
                    }
                }.padding()
                HStack {
                    Text("\(viewModel.newScoreDisplay)")
                        .foregroundStyle(viewModel.newScoreColour)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(-50)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
            }
            
            if (!viewModel.gameStarted) {
                ZStack {
                    Text("\(viewModel.startCountdown)")
                        .font(.system(size: 200))
                        .bold()
                        .foregroundStyle(.cyan)
                }
            }
            
            //Game Area
            ForEach(viewModel.bubbles) {
                bubble in Circle()
                    .position(bubble.position)
                    .frame(width: bubble.width)
                    .foregroundStyle(bubble.color)
                    .scaleEffect(bubble.scale)
                    .animation(.default, value: bubble.scale)
                    .onTapGesture {
                        viewModel.changeScale(ID: bubble.id)
                        viewModel.addToScore(newScore: bubble.points, newColor: bubble.color)
                        //viewModel.removeBubble(ID: bubble.id)
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
            if (viewModel.gameStarted) {
                if (viewModel.gameTimeLeft > 0) {
                    viewModel.removeSomeBubbles()
                    viewModel.generateBubbles()
                    viewModel.newScoreColour=Color.white
                } else {
                    //Timer End
                    viewModel.saveScore()
                    viewModel.sortHighScores()
                    viewModel.removeAllBubbles()
                    print("Timer over")
                    viewModel.timer.upstream.connect().cancel()
                    showHighScores = true
                }
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
                    Text("\(key) : \(value)")
                }
            }
            .listStyle(.insetGrouped)
            NavigationLink {
                GameView(gameTimeLimit: viewModel.gameTimeLeft, maxBubbles: viewModel.maxBubbles)
            } label : {
                    Text("Restart Game")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: 300)
                    .frame(height: 55)
                    .background(.cyan)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .padding()
            }
        }.background(.white)
    }
}


#Preview {
    GameView(gameTimeLimit: 60, maxBubbles: 15)
}
