//
//  Team.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//

import Foundation

class Team{
    var name: String
    var trueAnswer: Int = 0
    var score: Int{ trueAnswer - 2 * taboo }
    var taboo: Int = 0
    init(name: String){
        self.name = name
    }
}
