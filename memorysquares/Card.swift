//
//  Card.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/16/22.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    var id: Int
    var isMatched: Bool = false
    var isChosen: Bool = false
    var hasBeenPressed: Bool = false
    var hasBeenChosenAndPressed: Bool = false
}
