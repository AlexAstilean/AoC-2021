//
//  Day7.swift
//  2021Advent
//
//  Created by Alex Astilean on 07.12.2021.
//

import Foundation

class Day7: Day {

    var fuelCost: [Int: Int] = [:]
    func run() {

        let path = Bundle.main.path(forResource: "inputDay7", ofType: "txt")
        guard let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8) else { return }

        let crabPositions = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .compactMap { Int($0) }
        findBestPosition(for: crabPositions, part: .part1)
        findBestPosition(for: crabPositions, part: .part2)
    }

    func findBestPosition(for crabPositions: [Int], part: Part) {

        var totalFuel = Int(INT_MAX)
        var position = 0

        for crab1 in 1...crabPositions.max()! {
            var fuel = 0
            for crab in crabPositions {
                if part == .part1 {
                    fuel += abs(crab - crab1)
                } else {
                    let movesRequired = abs(crab - crab1)
                    fuel += part2FuelConsumedFor(steps: movesRequired)
                }
            }

            if fuel < totalFuel {
                totalFuel = fuel
                position = crab1
            }
        }
        print("\(part.description) Best position: \(position) Fuel consumed: \(totalFuel)")
    }

    func part2FuelConsumedFor(steps: Int) -> Int {

        if let cost = fuelCost[steps] {
            return cost
        } else {
            for i in 0...steps {
                fuelCost[steps, default: 0] += i
            }
            return fuelCost[steps]!
        }
    }
}
