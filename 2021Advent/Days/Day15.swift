//
//  Day15.swift
//  2021Advent
//
//  Created by Alex Astilean on 15.12.2021.
//

import Foundation

class Day15: Day {

    struct Point: Hashable, CustomStringConvertible {
        var x: Int
        var y: Int

        var description: String {
            "(\(x),\(y))"
        }

        var adjacents: [Point] {
            [
                Point(x: x + 1, y: y),
                Point(x: x, y: y + 1),
                Point(x: x - 1, y: y),
                Point(x: x, y: y - 1),
            ]
        }
    }

    typealias Matrix = [Point: Int]

    var maxX = 0
    var maxY = 0
    func run() {

        let path = Bundle.main.path(forResource: "inputDay15", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let lines = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .whitespacesAndNewlines) else {
                  print("No components")
                  return
              }

        maxX = lines[0].count - 1
        maxY = lines.count - 1

        let matrix = lines.enumerated().reduce(into: Matrix()) { matrix, tuple in
            let (line, values) = tuple
            values.enumerated().forEach {
                matrix[Point(x: $0.offset, y: line)] = $0.element.wholeNumberValue!
            }
        }

        partOne(matrix: matrix)
        partTwo(matrix: matrix)
    }

    func partOne(matrix: Matrix) {
        let initialPosition = Point(x: 0, y: 0)
        let finalPosition = Point(x: maxX, y: maxY)

        let cost = cost(from: initialPosition, to: finalPosition, in: matrix)

        print("Part 1 | Cost: \(cost)")
    }

    func show(matrix: Matrix, maxX: Int, maxY: Int) {

        for yi in 0...maxY {
            for xi in 0...maxX {

                print(matrix[Point(x: xi, y: yi)]!, terminator: " ")
            }
            print()
        }
    }

    func partTwo(matrix: Matrix) {
        let width = maxX + 1
        let height = maxY + 1

        let modifiedGrid = (0 ..< 5).reduce(into: [Point: Int]()) { newGrid, x in
            (0 ..< 5).forEach { y in
                matrix.forEach { point, cost in
                    let newPoint = Point(
                        x: (width * x) + point.x,
                        y: (height * y) + point.y
                    )
                    let rawCost = cost + x + y
                    let newCost = rawCost > 9 ? rawCost % 9 : rawCost
                    newGrid[newPoint] = newCost
                }
            }
        }

        let initialPosition = Point(x: 0, y: 0)
        let finalPosition = Point(
            x: width * 5 - 1,
            y: height * 5 - 1
        )

//        show(matrix: modifiedGrid, maxX: finalPosition.x, maxY: finalPosition.y)
        let cost = cost(from: initialPosition, to: finalPosition, in: modifiedGrid)
        print("Part 2 | Cost: \(cost)")
    }

    func cost(from initialPosition: Point, to finalPosition: Point, in matrix: Matrix) -> Int {
        var minCosts: [Point: Int] = [:]
        var minCost: Int { minCosts[finalPosition] ?? .max }

        var currentPositions: [Point: Int] = [initialPosition: 0]

        while let (position, cost) = currentPositions.min(by: { $0.value < $1.value }) {
            currentPositions.removeValue(forKey: position)

            guard cost < minCost else { continue }

            var nextPositions = position.adjacents
            if nextPositions.contains(finalPosition) {
                nextPositions.removeAll(where: { $0 == finalPosition })
                minCosts[finalPosition] = min(minCost, cost + matrix[finalPosition]!)
            }

            nextPositions.forEach { nextPosition in
                guard let nextPositionCost = matrix[nextPosition] else { return }
                let totalCost = cost + nextPositionCost
                if let previousCost = minCosts[nextPosition], previousCost <= totalCost { return }
                minCosts[nextPosition] = totalCost
                currentPositions[nextPosition] = totalCost
            }
        }

        return minCost
    }
}
