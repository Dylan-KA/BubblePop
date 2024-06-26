//
//  MenuView.swift
//  BubblePop
//
//  Created by Dylan Archer on 2/4/2024.
//

import Foundation
import SwiftUI

struct MenuView : View {
    
    @StateObject var viewModel = MenuViewModel()
    
    init(gameTimeLimit :Int) {
        
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Bubble Pop")
                .font(.system(size: 50))
                .bold()
                .foregroundStyle(.cyan)
            HStack {
                Spacer(minLength: 50)
                Text("Name: ")
                    .fontWeight(.bold)
                TextField("Enter to save your highscore", text: $viewModel.username)
                    .onChange(of: viewModel.username) { oldValue, newValue in
                        viewModel.saveUsername()
                    }
            }
            Spacer()
            Text("Game Time limit: \(Int(viewModel.gameTimeLimit)) seconds")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
            Slider(value: $viewModel.gameTimeLimit, in: 10.0...90.0, step: 1.0)
                .padding()
                .frame(maxWidth: 325)
            Text("Maximum Bubbles: \(Int(viewModel.maxBubbles))")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
            Slider(value: $viewModel.maxBubbles, in: 5...20, step: 1.0)
                .padding()
                .frame(maxWidth: 325)
            NavigationLink {
                GameView(gameTimeLimit: Int(viewModel.gameTimeLimit), maxBubbles: Int(viewModel.maxBubbles))
            } label : {
                    Text("Play Game")
                    .font(.headline)
                    .frame(maxWidth: 300)
                    .frame(height: 55)
                    .background(.cyan)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .padding(.horizontal)
            }
            Spacer()
            }
        }
    }

#Preview {
    NavigationStack {
        MenuView(gameTimeLimit: 60)
    }
}
