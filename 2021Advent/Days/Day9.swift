//
//  Day9.swift
//  2021Advent
//
//  Created by Alex Astilean on 09.12.2021.
//

import Foundation

class Day9: Day {


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
                Point(x: x - 1, y: y)
            ]
        }
    }
    typealias Matrix = [Point: Int]

    func run() {

        let path = Bundle.main.path(forResource: "inputDay9", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let lines = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines) else {
            print("No components")
            return
        }
        //        part1Old(lines: lines)

        let matrix = lines.enumerated().reduce(into: Matrix()) { matrix, tuple in
            let (line, values) = tuple
            values.enumerated().forEach {
                matrix[Point(x: line, y: $0.offset)] = $0.element.wholeNumberValue!
            }
        }
        let lowPoints = part1(matrix: matrix)

        part2(matrix: matrix, lowPoints: lowPoints)
    }

    func part1(matrix: Matrix) -> Matrix {
        let lowPoints = matrix.filter { point, value in
            point.adjacents.allSatisfy {
                guard let adjacent = matrix[$0] else { return true }
                return adjacent > value
            }
        }
        let lowPointsValues = lowPoints.map { $0.value + 1 }
        print("Part 1 | Sum of risk levels: \(lowPointsValues.reduce(0, +))")
        return lowPoints
    }

    func part2(matrix: Matrix, lowPoints: Matrix) {

        let basinSizes = lowPoints.map { point, value -> Int in

            var basin = [point]
            var pointsToExplore = [point]
//            print("From \(basin)")

            while !pointsToExplore.isEmpty {
                pointsToExplore = pointsToExplore.map { point in
                    point.adjacents.filter { adjacent in
                        guard let value = matrix[adjacent],
                              !basin.contains(adjacent) else { return false }
                        return value != 9
                    }
                }.reduce([Point]()) { partialResult, points in
                    return partialResult.union(points)
                }

//                print("To explore \(pointsToExplore)")
                basin = basin.union(pointsToExplore)
            }
//            print("Basin \(basin)")

            return basin.count
        }

        let product = basinSizes.sorted(by: >).prefix(3).reduce(1, * )
        print("Part 2 | Product of largest basins: \(product)")

    }
}

extension Day9 {
    func part1Old(lines: [String]) {

        var matrix = [[Int]]()

        for line in lines {

            matrix.append(line.map { Int(String($0)) ?? 2 })
        }

        var lowPoints: [Point: Int] = [:]
        var rowIndex = 0
        while rowIndex < matrix.count {
            var colIndex = 0
            while colIndex < matrix[rowIndex].count {
                defer { colIndex += 1 }

                if matrix.indices.contains(rowIndex - 1),
                   matrix[rowIndex][colIndex] >= matrix[rowIndex - 1][colIndex] {
                        continue
                }
                if matrix.indices.contains(rowIndex + 1),
                   matrix[rowIndex][colIndex] >= matrix[rowIndex + 1][colIndex] {
                        continue
                }
                if matrix[rowIndex].indices.contains(colIndex - 1),
                   matrix[rowIndex][colIndex] >= matrix[rowIndex][colIndex - 1] {
                        continue
                }
                if matrix[rowIndex].indices.contains(colIndex + 1),
                   matrix[rowIndex][colIndex] >= matrix[rowIndex][colIndex + 1] {
                        continue
                }
                lowPoints[Point(x: rowIndex, y: colIndex)] = matrix[rowIndex][colIndex]
            }
            rowIndex += 1
        }
        print(lowPoints)
        let lowPointsValues = lowPoints.map { $0.value + 1 }
        print("Part 1 | Sum of risk levels: \(lowPointsValues.reduce(0, +))")
    }

}
