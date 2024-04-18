//
//  MenuViewModel.swift
//  BubblePop
//
//  Created by Dylan Archer on 2/4/2024.
//

import Foundation

class MenuViewModel : ObservableObject {
    
    @Published var gameTimeLimit: Double = 60.0
    
    let userDefaults  = UserDefaults.standard
    @Published var username: String = ""
    
    init() {
        self.username = userDefaults.string(forKey: "username") ?? ""
    }
    
    func saveUsername() {
        userDefaults.setValue(username, forKey: "username")
    }
    
}
