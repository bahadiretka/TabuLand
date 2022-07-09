//
//  Taboo.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//

import Foundation

class Taboo{
    static var game: Game = Game(team1: "A", team2: "B")
    static func startGame(team1: String,team2: String){
        game = Game(team1: team1, team2: team2)
    }
    static var tour = 10
    static var passRight = 3
    static var remainingTime = 60
}
