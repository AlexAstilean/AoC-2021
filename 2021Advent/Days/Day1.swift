//
//  Day1.swift
//  2021Advent
//
//  Created by Alex Astilean on 29.11.2021.
//

import Foundation

class Day1: Day {

    func run() {

        let path = Bundle.main.path(forResource: "inputDay1", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        let items = string?.components(separatedBy: .newlines).compactMap { Int($0) } ?? []

        compareIncreased(items: items, part: "Part 1")


        // Part 2
        var triplets: [Int] = []
        for index in 0..<items.count - 2 {
            triplets.append(items[index] + items[index + 1] + items[index + 2])
        }
        compareIncreased(items: triplets, part: "Part 2")
    }

    func compareIncreased(items: [Int], part: String) {

        var timesIncreased = 0
        var previous = items[0]
        items.forEach {
            timesIncreased += $0 > previous ? 1: 0
            previous = $0
        }
        print("\(part) Times increased: \(timesIncreased)")
    }
}
