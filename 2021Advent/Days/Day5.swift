//
//  Day5.swift
//  2021Advent
//
//  Created by Alex Astilean on 05.12.2021.
//

import Foundation

class Day5: Day {

    struct Line {
        let a: Point
        let b: Point

        var isHorizontalOrVertical: Bool {
            return a.x == b.x || a.y == b.y
        }

        var points: [Point] {

            if a.x == b.x {
                return (min(a.y, b.y) ... max(a.y, b.y)).map { Point(x: a.x, y: $0) }
            } else if a.y == b.y {
                return (min(a.x, b.x) ... max(a.x, b.x)).map { Point(x: $0, y: a.y) }
            } else {
                let diff = abs(a.x - b.x)
                let xIncrease = b.x > a.x
                let yIncrease = b.y > a.y
                return (0 ... diff).map {
                    Point(x: a.x + (xIncrease ? $0 : -$0),
                          y: a.y + (yIncrease ? $0 : -$0))
                }
            }
        }
    }

    struct Point: Hashable {
        let x: Int
        let y: Int
    }

    func run() {

        let path = Bundle.main.path(forResource: "inputDay5", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let input = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines) else {
            print("No components")
            return
        }

        let lines = input.map { item -> Line in

            let lineEnds = item.components(separatedBy: " -> ").map { item -> Point in
                let position = item.components(separatedBy: ",")
                return Point(x: Int(position[0])!, y: Int(position[1])!)
            }
            return Line(a: lineEnds[0],
                        b: lineEnds[1])
        }

        // Part 1
        print("Part 1: Number of points: \(numberOfOverlaps(lines: lines.filter(\.isHorizontalOrVertical)))")

        //Part 2
        print("Part 2: Number of points: \(numberOfOverlaps(lines: lines))")

    }

    func numberOfOverlaps(lines: [Line]) -> Int {

        var points: [Point: Int] = [:]

        lines.forEach { line in

            line.points.forEach {
                points[$0, default: 0] += 1
            }
        }

        return points.filter { $0.value >= 2 }.count
    }
}
