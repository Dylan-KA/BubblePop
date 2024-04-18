//
//  HighScoreView.swift
//  BubblePop
//
//  Created by Dylan Archer on 9/4/2024.
//

import Foundation
import SwiftUI

struct HighScoreView: View {
    
    @StateObject var viewModel :HighScoreViewModel
    
    var body: some View {
        Text("High Score")
    }
}

#Preview {
    HighScoreView(viewModel: HighScoreViewModel())
}
