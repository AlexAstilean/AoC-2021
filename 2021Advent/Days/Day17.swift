//
//  Day17.swift
//  2021Advent
//
//  Created by Alex Astilean on 17.12.2021.
//

import Foundation

class Day17: Day {
    
    struct Point: Hashable, CustomStringConvertible {
        var x: Int
        var y: Int

        var description: String {
            "(\(x),\(y))"
        }

        static var zero = Point(x: 0, y: 0)
    }


    func run() {

        let path = Bundle.main.path(forResource: "inputDay17", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        guard let line = string?
                .trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("No components")
            return
        }
        let numbers = line.split(whereSeparator: { !"-0123456789".contains($0) })
            .compactMap { Int($0) }

        let xRange = numbers[0] ... numbers[1]
        let yRange = numbers[2] ... numbers[3]

        var maxY = Int.min
        var count = 0

        for xVelocity in 1 ... xRange.upperBound {
            for yVelocity in yRange.lowerBound ... 1000 {
                var position = Point.zero
                var velocity = Point(x: xVelocity, y: yVelocity)

                var localMaxY = Int.min

                while position.x <= xRange.upperBound, position.y >= yRange.lowerBound {
                    position.x += velocity.x
                    position.y += velocity.y

                    velocity.x -= velocity.x.signum()
                    velocity.y -= 1

                    localMaxY = max(localMaxY, position.y)

                    if xRange.contains(position.x) && yRange.contains(position.y) {
                        maxY = max(maxY, localMaxY)
                        count += 1
                        break
                    }
                }
            }
        }

        print("Part 1 | Max y positions reached: \(maxY)")
        print("Part 2 | No. initital velocity values: \(count)")
    }
}
