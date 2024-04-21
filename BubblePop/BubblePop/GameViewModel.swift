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
    @Published var maxBubbles: Int
    @Published var bubbles :[Bubble] = []
    @Published var previousBubble :Int = 0
    @Published var username: String = ""
    @Published var highScores :[String : Int]
    @Published var sortedHighScores: [(String, Int)] = []
    
    let userDefaults  = UserDefaults.standard
    
    init(gameTimeLeft :Int, maxBubbles :Int) {
        self.gameTimeLeft = gameTimeLeft
        self.maxBubbles = maxBubbles
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
    
    func removeSomeBubbles() {
        if (bubbles.count == 0) { return }
        let numToRemove = Int.random(in: 0...bubbles.count)
        if (numToRemove == 0) { return }
        for _ in 0...numToRemove {
            if (bubbles.count > 0) { bubbles.removeFirst() }
        }
    }
    
    func generateBubbles() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        let safeAreaInsets = windowScene.windows.first?.safeAreaInsets
        let screenWidth = UIScreen.main.bounds.width - (safeAreaInsets?.left ?? 0) - (safeAreaInsets?.right ?? 0)
        let screenHeight = UIScreen.main.bounds.height - (safeAreaInsets?.top ?? 0) - (safeAreaInsets?.bottom ?? 0)
        
        let numToGenerate = Int.random(in: 0...(maxBubbles - bubbles.count))
        for _ in 0..<numToGenerate {
            let position = CGPoint(
                x: CGFloat.random(in: (-screenWidth / 2 + 60)...(screenWidth / 2)), // Adjust according to bubble width
                y: CGFloat.random(in: 80...(screenHeight - 40)) // Adjust based on top and bottom padding
            )
            let width = CGFloat.random(in: 50...60)
            let points = generateRarity()
            let color = getColor(points: points)
            let bubble = Bubble(position: position, width: width, points: points, color: color)
            bubbles.append(bubble)
        }
    }
    
    func removeAllBubbles() {
        bubbles.removeAll()
    }
    
    func removeBubble(ID: String) {
        bubbles.removeAll { $0.id == ID }
    }
    
    func addToScore(newScore: Int) {
        if (newScore == previousBubble) {
            let newScoreFloat: Float = Float(newScore)
            gameScore += Int(newScoreFloat*1.5)
        } else {
            gameScore += newScore
        }
        previousBubble = newScore
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
