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
            Spacer()
            Text("Game Time limit: \(Int(viewModel.gameTimeLimit)) seconds")
                .font(.headline)
                .foregroundStyle(.cyan)
            Slider(value: $viewModel.gameTimeLimit, in: 30.0...90.0, step: 1.0)
                .padding()
            
            NavigationLink {
                GameView(gameTimeLimit: Int(viewModel.gameTimeLimit))
            } label : {
                    Text("Play Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
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
