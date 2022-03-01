//
//  Day11.swift
//  2021Advent
//
//  Created by Alex Astilean on 11.12.2021.
//

import Foundation

class Day11: Day {

    struct Point: Hashable, CustomStringConvertible {
        let x: Int
        let y: Int

        var description: String {
            "(\(x),\(y))"
        }

        var adjacents: [Point] {
            [
                Point(x: x, y: y + 1),
                Point(x: x, y: y - 1),
                Point(x: x + 1, y: y),
                Point(x: x - 1, y: y),
                Point(x: x - 1, y: y - 1),
                Point(x: x - 1, y: y + 1),
                Point(x: x + 1, y: y - 1),
                Point(x: x + 1, y: y + 1)
            ]
        }
        var neighbours: Set<Point> {
            var all = Set(
                ((x - 1)...(x + 1)).flatMap { x in
                    ((y - 1)...(y + 1)).map { y in
                        Point(x: x, y: y)
                    }
                }
            )
            all.remove(self)
            return all
        }
    }
    
    typealias Matrix = [Point: Int]

    func run() {

        let path = Bundle.main.path(forResource: "inputDay11", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let lines = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines) else {
            print("No components")
            return
        }

        let matrix = lines.enumerated().reduce(into: Matrix()) { matrix, tuple in
            let (line, values) = tuple
            values.enumerated().forEach {
                matrix[Point(x: line, y: $0.offset)] = $0.element.wholeNumberValue!
            }
        }

        part1(matrix: matrix)
        part2(matrix: matrix)
    }

    func iterate(_ octopuses: inout Matrix) {

        octopuses = octopuses.mapValues { $0 + 1}

        var thatFlashed = Array(octopuses.filter { $0.value > 9 }.keys)
        var flashed = thatFlashed

        while !thatFlashed.isEmpty {
            thatFlashed.forEach {
                $0.adjacents.forEach { octopuses[$0]? += 1 }
            }
            thatFlashed = Array(octopuses.filter { $0.value > 9 }.keys).difference(from: flashed)
            flashed = flashed.union(thatFlashed)
        }

        flashed.forEach { octopuses[$0] = 0 }
    }

    func part1(matrix: Matrix) {

        var octopuses = matrix
        var score = 0

        for _ in 0 ..< 10 {
            iterate(&octopuses)
            score += octopuses.filter { $0.value == 0 }.count
        }

        print("Part 1 | Number of flashes: \(score)")
    }

    func part2(matrix: Matrix) {

        var octopuses = matrix
        var stepWon: Int?
        for step in 1... {
            iterate(&octopuses)
            let score = octopuses.filter { $0.value == 0 }.count
            if score == 100 {
                stepWon = step
                break
            }
        }
        print("Part 2 | Step won: \(stepWon!)")

    }
}
