//
//  Day24.swift
//  2021Advent
//
//  Created by Alex Astilean on 24.12.2021.
//

import Foundation

class Day25: Day {

    struct Point: Hashable {
        var x: Int
        var y: Int
    }

    func run() {

        let path = Bundle.main.path(forResource: "inputDay25", ofType: "txt")
        let input = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        let xCount = input.split(separator: "\n")[0].count
        let yCount = input.split(separator: "\n").count
        var south: Set<Point> = []
        var east: Set<Point> = []

        input.split(separator: "\n").enumerated().forEach { y, line in
            line.enumerated().forEach { x, char in
                if char == ">" {
                    east.insert(Point(x: x, y: y))
                } else if char == "v" {
                    south.insert(Point(x: x, y: y))
                }
            }
        }

        for step in (1...) {
            var didMove = false

            func isAvailable(_ point: Point) -> Bool {
                east.contains(point) == false
                && south.contains(point) == false
            }

            let newEast = Set(
                east.map { point -> Point in
                    let potentialNextLocation = Point(x: (point.x + 1) % xCount, y: point.y)
                    guard isAvailable(potentialNextLocation) else { return point }
                    return potentialNextLocation
                }
            )

            if newEast != east {
                didMove = true
                east = newEast
            }

            let newSouth = Set(
                south.map { point -> Point in
                    let potentialNextLocation = Point(x: point.x, y: (point.y + 1) % yCount)
                    guard isAvailable(potentialNextLocation) else { return point }
                    return potentialNextLocation
                }
            )

            if newSouth != south {
                didMove = true
                south = newSouth
            }

            if !didMove {
                print("Part 1: | No moves: \(step.description)")
                break
            }
        }
        
    }
}
