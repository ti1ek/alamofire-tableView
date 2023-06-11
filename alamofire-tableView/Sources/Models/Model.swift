//
//  Model.swift
//  alamofire-tableView-mvvm
//
//  Created by Zhuldyz Bukeshova on 28.05.2023.
//

import Foundation

struct Cards: Decodable {
    let cards: [Card]
}

struct Card: Decodable {
    let name: String
    let type: String?
    let imageUrl: String?
}
