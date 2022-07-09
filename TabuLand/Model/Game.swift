//
//  Game.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//
import Foundation


class Game{
    var team1: Team
    var team2: Team
    var currentTeam: Team
    var isThereWinner: Bool{team1.score != team2.score}
    var teamName: String{ currentTeam.name}
    var winner: String {team1.score > team2.score ? team1.name : team2.name}
    
    init(team1: String, team2: String){
        self.team1 = Team(name: team1)
        self.team2 = Team(name: team2)
        currentTeam = self.team1
    }
    func changeTeam(){ // fix the team change
        currentTeam = currentTeam.name == team1.name ? team2 : team1
    }
    func incrementScore(){
        currentTeam.trueAnswer += 1
    }
    func taboo(){
        currentTeam.taboo += 1
    }
    
}
