//
//  Day10.swift
//  2021Advent
//
//  Created by Alex Astilean on 10.12.2021.
//

import Foundation

class Day10: Day {

    let pairs: [Character: Character] = [
        "(": ")",
        "[": "]",
        "{": "}",
        "<": ">"
    ]

    func run() {

        let path = Bundle.main.path(forResource: "inputDay10", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let lines = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines) else {
            print("No components")
            return
        }

        part1(inputLines: lines)
        part2(inputLines: lines)

    }

    func part1(inputLines lines: [String]) {

        let errorScore: [Character: Int] = [
            ")": 3,
            "]": 57,
            "}": 1197,
            ">": 25137
        ]
        let score = lines.map { line in
            var stack: [Character] = []
            for char in line {
                if ["(", "[", "{", "<"].contains(char) {
                    stack.append(char)
                } else if pairs[stack.removeLast()] != char {
                    return errorScore[char]!
                }
            }
            return 0
        }.reduce(0, +)
        print("Part 1 | Error score: \(score)")
    }

    func part2(inputLines lines: [String]) {

        let fixScore: [Character: Int] = [
            ")": 1,
            "]": 2,
            "}": 3,
            ">": 4
        ]
        let scores = lines.compactMap { line -> Int? in
            var stack: [Character] = []
            for char in line {
                if ["(", "[", "{", "<"].contains(char) {
                    stack.append(char)
                } else if pairs[stack.removeLast()] != char {
                    return nil
                }
            }
            return stack.reversed().map { pairs[$0]! }.map { fixScore[$0]! }.reduce(0, { $0 * 5 + $1 })
        }.sorted()

        let middle = scores.count / 2
        print("Part 1 | Fix score: \(scores[middle])")

    }
}
