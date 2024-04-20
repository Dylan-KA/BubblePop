//
//  GameViewModel.swift
//  BubblePop
//
//  Created by Dylan Archer on 2/4/2024.
//

import Foundation

struct Bubble: Identifiable {
    let id :String = UUID().uuidString
    let position : CGPoint
    let width: CGFloat
    //rarity
}


class GameViewModel : ObservableObject {
    
    @Published var gameTimeLeft: Int
    @Published var gameScore: Int = 0
    @Published var bubbles :[Bubble] = []
    @Published var username: String = ""
    @Published var highScores :[String : Int]
    let userDefaults  = UserDefaults.standard
    
    init(gameTimeLeft :Int) {
        self.gameTimeLeft = gameTimeLeft
        self.username = userDefaults.string(forKey: "username") ?? ""
        self.highScores = userDefaults.object(forKey: "highScores") as? [String : Int] ?? [:]
    }
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    func countdown() {
        if (gameTimeLeft > 0) {
            gameTimeLeft -= 1
        } else {
            saveScore()
        }
    }
    
    func generateBubbles() {
        for _ in 0...4 {
            let position = CGPoint(x: Int.random(in: -280...280), y: Int.random(in: 100...750))
            let width = CGFloat(Int.random(in: 25...50))
            let bubble = Bubble(position: position, width: width)
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
    
}
