//
//  Day2.swift
//  2021Advent
//
//  Created by Alex Astilean on 01.12.2021.
//

import Foundation

class Day2: Day {

    func run() {
        let path = Bundle.main.path(forResource: "inputDay2", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let stringItems = string?.components(separatedBy: .newlines) else { return }

        let toupleMove = stringItems.compactMap { item -> (String, Int)? in
            let touple = item.components(separatedBy: .whitespaces)

            return touple.count == 2 ? (touple[0], Int(touple[1])!) : nil
        }

        part1(toupleMove: toupleMove)
        part2(toupleMove: toupleMove)

    }

    func part1(toupleMove: [(String, Int)]) {

        var horizontal = 0
        var depth = 0

        for (direction, value) in toupleMove {
            switch direction {
            case "forward": horizontal += value
            case "up": depth -= value
            case "down": depth += value
            default: break
            }
        }

        print("Part 1. Horizontal: \(horizontal), depth: \(depth) Answer: \(horizontal * depth)")
    }

    func part2(toupleMove: [(String, Int)]) {

        var horizontal = 0
        var depth = 0
        var aim = 0

        for (direction, value) in toupleMove {
            switch direction {
            case "forward":
                horizontal += value
                depth += aim * value
            case "up": aim -= value
            case "down": aim += value
            default: break
            }
        }

        print("Part 2. Horizontal: \(horizontal), depth: \(depth) Answer: \(horizontal * depth)")

    }
}
