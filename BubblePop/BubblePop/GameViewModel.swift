//
//  GameViewModel.swift
//  BubblePop
//
//  Created by Dylan Archer on 2/4/2024.
//

import Foundation
import SwiftUI

struct Bubble: Identifiable {
    let id :String = UUID().uuidString
    let position : CGPoint
    let width: CGFloat
    let points: Int
    let color: Color
}


class GameViewModel : ObservableObject {
    
    @Published var gameTimeLeft: Int
    @Published var gameScore: Int = 0
    @Published var bubbles :[Bubble] = []
    @Published var username: String = ""
    @Published var highScores :[String : Int]
    @Published var sortedHighScores: [(String, Int)] = []
    
    let userDefaults  = UserDefaults.standard
    
    init(gameTimeLeft :Int) {
        self.gameTimeLeft = gameTimeLeft
        self.username = userDefaults.string(forKey: "username") ?? ""
        self.highScores = userDefaults.object(forKey: "highScores") as? [String : Int] ?? [:]
        sortHighScores()
    }
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    func countdown() {
        if (gameTimeLeft > 0) {
            gameTimeLeft -= 1
        }
    }
    
    func generateRarity() -> Int {
        let rarity = Int.random(in: 0...100)
        if (rarity <= 40) {
            return 1
        } else if (rarity > 40 && rarity <= 70) {
            return 2
        } else if (rarity > 70 && rarity <= 85) {
            return 5
        } else if (rarity > 85 && rarity <= 95) {
            return 8
        } else if (rarity > 95) {
            return 10
        }
        return 0
    }
    
    func getColor(points: Int) -> Color {
        switch points {
        case 1:
            return .red
        case 2:
            return .pink
        case 5:
            return .green
        case 8:
            return .blue
        case 10:
            return .black
        default:
            return.gray
        }
    }
    
    func generateBubbles() {
        for _ in 0...4 {
            let position = CGPoint(x: Int.random(in: -280...280), y: Int.random(in: 100...750))
            let width = CGFloat(Int.random(in: 25...50))
            let points = generateRarity()
            let color = getColor(points: points)
            let bubble = Bubble(position: position, width: width, points: points, color: color)
            bubbles.append(bubble)
        }
    }
    
    func removeAllBubbles() {
        bubbles.removeAll()
    }
    
    func addToScore(newScore: Int) {
        gameScore += newScore
    }
    
    func saveScore() {
        if (highScores["\(username)"] != nil) {
            if (gameScore > highScores["\(username)"]!) {
                highScores["\(username)"] = gameScore
                userDefaults.set(highScores, forKey: "highScores")
            }
        } else {
            highScores["\(username)"] = gameScore
            userDefaults.set(highScores, forKey: "highScores")
        }
    }
    
    func sortHighScores() {
        sortedHighScores = highScores.sorted { $0.value > $1.value }
    }
    
}
