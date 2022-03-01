//
//  Day.swift
//  Day2
//
//  Created by Alex Astilean on 22/12/2020.
//

import Foundation

protocol Day {
    func run()
}

enum Part {
    case part1, part2

    var description: String {
        switch self {
        case .part1: return "Part 1"
        case .part2: return "Part 2"
        }
    }
}
