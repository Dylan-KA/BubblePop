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
                    print(geometry.size.width)
                    print(geometry.size.height)
                }
            }
            ForEach(viewModel.bubbles) { 
                bubble in Circle()
                    .position(bubble.position)
                    .frame(width: bubble.width)
                    .onTapGesture {
                        print("Bubble Popped")
                    }
            }
            
            
        }.onReceive(viewModel.timer, perform: { _ in
            viewModel.countdown()
            viewModel.generateBubbles()
        })
    }
}

#Preview {
    GameView(gameTimeLimit: 60)
}
