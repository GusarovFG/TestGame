//
//  Model.swift
//  TestGame
//
//  Created by Фаддей Гусаров on 02.04.2022.
//

import Foundation

struct Drinks: Codable {
    let drinks: [Drink]
}

struct Drink: Codable {
    let strDrink: String
}
