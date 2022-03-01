//
//  Day14.swift
//  2021Advent
//
//  Created by Alex Astilean on 14.12.2021.
//

import Foundation

class Day14: Day {

    typealias Rules = [[Character]: Character]

    struct Pairing: Hashable {
        let first: Character
        let second: Character
        let isStarting: Bool
        let isEnding: Bool

        var isEdge: Bool { isStarting || isEnding }

        var ruleText: [Character] { [first, second] }
    }

    func run() {
        let path = Bundle.main.path(forResource: "inputDay14", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let lines = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "\n\n") else {
                  print("No components")
                  return
              }

        let template = lines[0]
        var rules: Rules = [:]
        
        lines[1].components(separatedBy: .newlines).forEach {
            let component = $0.components(separatedBy: " -> ")
            rules[Array(component[0])] = component[1].first!
        }

        let pairChars = Array(zip(template, template.dropFirst()).enumerated())
        var initialPairs = pairChars.reduce(into: [Pairing: Int]()) { partialResult, touple in
            let (index, (first, second)) = touple
            let pair = Pairing(first: first,
                               second: second,
                               isStarting: index == 0,
                               isEnding: index == pairChars.count - 1)
            partialResult[pair, default: 0] += 1
        }

        for i in 1...40 {
            advance(rules: rules, pairings: &initialPairs)
            if i == 10 {
                // Part 1
                print("Part 1 | Result: \(score(for: initialPairs))")
            }
        }
        print("Part 2 | Result: \(score(for: initialPairs))")

    }

    func advance(rules: Rules, pairings: inout [Pairing: Int]) {

        var newPairings: [Pairing: Int] = [:]

        pairings.forEach { pairing, count in
            guard let evaluated = rules[pairing.ruleText] else {
                newPairings[pairing, default: 0] += count
                return
            }

            let new = [
                Pairing(first: pairing.first, second: evaluated, isStarting: pairing.isStarting, isEnding: false),
                Pairing(first: evaluated, second: pairing.second, isStarting: false, isEnding: pairing.isEnding)
            ]
            new.forEach { newPairings[$0, default: 0] += count }
        }
        pairings = newPairings
    }

    func score(for pairings: [Pairing: Int]) -> Int {

        var counts = pairings.reduce(into: [Character: Int]()) { partialResult, touple in
            let (key, value) = touple
            guard key.isEdge == false else { return }
            partialResult[key.first, default: 0] += value
            partialResult[key.second, default: 0] += value
        }

        /// Non-terminal values are counted twice, as part of two pariings
        counts = counts.mapValues { $0 / 2 }

        pairings.forEach { key, value in
            guard key.isEdge else { return }
            counts[key.first, default: 0] += value
            counts[key.second, default: 0] += value
        }
        return counts.values.max()! - counts.values.min()!
    }

}
