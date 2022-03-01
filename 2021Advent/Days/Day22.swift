//
//  Day22.swift
//  2021Advent
//
//  Created by Alex Astilean on 22.12.2021.
//

import Foundation

fileprivate extension StringProtocol {
    var numbers: [Int] {
        split(whereSeparator: { "-0123456789".contains($0) == false })
            .map { Int($0)! }
    }
}

fileprivate extension ClosedRange {
    func isSuperset(of other: Self) -> Bool {
        return lowerBound <= other.lowerBound && upperBound >= other.upperBound
    }
}

fileprivate extension ClosedRange where Bound == Int {
    func split(over other: Self) -> Set<Self> {
        if other.isSuperset(of: self) {
            return [self]
        } else if lowerBound < other.lowerBound, upperBound > other.upperBound {
            return [
                (lowerBound ... other.lowerBound - 1),
                other,
                (other.upperBound + 1 ... upperBound)
            ]
        } else if other.lowerBound <= lowerBound {
            return [(lowerBound ... other.upperBound), (other.upperBound + 1 ... upperBound)]
        } else {
            return [(lowerBound ... other.lowerBound - 1), (other.lowerBound ... upperBound)]
        }
    }

    var magnitude: Int { abs(upperBound - lowerBound + 1) }
}

class Day22: Day {

    struct Cuboid: Hashable {
        var x: ClosedRange<Int>
        var y: ClosedRange<Int>
        var z: ClosedRange<Int>

        init(x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>) {
            self.x = x
            self.y = y
            self.z = z
        }

        init(line: Substring) {
            let numbers = line.numbers
            x = numbers[0] ... numbers[1]
            y = numbers[2] ... numbers[3]
            z = numbers[4] ... numbers[5]
        }

        var points: Int { x.magnitude * y.magnitude * z.magnitude }

        static let small = Cuboid(x: -50 ... 50, y: -50 ... 50, z: -50 ... 50)
        var isSmall: Bool { Cuboid.small.isSuperset(of: self) }

        func isSuperset(of other: Cuboid) -> Bool {
            x.isSuperset(of: other.x)
            && y.isSuperset(of: other.y)
            && z.isSuperset(of: other.z)
        }

        func intersects(with other: Cuboid) -> Bool {
            x.overlaps(other.x)
            && y.overlaps(other.y)
            && z.overlaps(other.z)
        }

        func union(with other: Cuboid) -> Set<Cuboid> {
            guard intersects(with: other) else { return [self, other] }

            if other.isSuperset(of: self) { return [other] }

            var sets: Set<Cuboid> = []
            sets.insert(other)

            let xRanges = x.split(over: other.x)
            let yRanges = y.split(over: other.y)
            let zRanges = z.split(over: other.z)

            xRanges.forEach { xRange in
                yRanges.forEach { yRange in
                    zRanges.forEach { zRange in
                        let new = Cuboid(x: xRange, y: yRange, z: zRange)
                        if other.isSuperset(of: new) { return }
                        sets.insert(new)
                    }
                }
            }

            return sets
        }
    }

    fileprivate struct Point: Hashable {
        var x: Int
        var y: Int
        var z: Int
    }

    func run() {

        let path = Bundle.main.path(forResource: "inputDay22", ofType: "txt")
        let string = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        parse(input: string, part: .part1)
        parse(input: string, part: .part2)

    }

    func parse(input: String, part: Part) {
        var cuboids: Set<Cuboid> = []

        for line in input.split(separator: "\n") {
            let on = line.starts(with: "on")
            let new = Cuboid(line: line)

            if part == .part1 {
                guard new.isSmall else { continue }
            }

            if on {
                if cuboids.isEmpty {
                    cuboids = [new]
                } else {
                    cuboids = Set(cuboids.lazy.flatMap { $0.union(with: new) })
                }
            } else {
                cuboids = Set(cuboids.lazy.flatMap { $0.union(with: new) })
                cuboids.remove(new)
            }
        }

        let sum = cuboids.map(\.points).reduce(0, +)
        print("\(part.description) | Sum: \(sum)")
    }

    func part1A(input: String) {
        let inputLines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)


        var data: [Point: Bool] = [:]
        inputLines.forEach { line in
            let components = line.components(separatedBy: .whitespaces)
            let value = components.first == "on" ? true : false
            let ranges = components.last?.components(separatedBy: ",")
            let xNum = ranges?.first?.numbers
            let xRange = xNum![0] ... xNum![1]

            let yNum = ranges?[1].numbers
            let yRange = yNum![0] ... yNum![1]

            let zNum = ranges?[2].numbers
            let zRange = zNum![0] ... zNum![1]

            for x in xRange {
                guard -50...50 ~= x else { return }
                for y in yRange {
                    guard -50...50 ~= y else { return }

                    for z in zRange {
                        guard -50...50 ~= z else { return }

                        data[Point(x: x+50, y: y+50, z: z+50)] = value
                    }
                }
            }

        }
        let sum = data.values.reduce(into: 0) { partialResult, val in
            partialResult += val ? 1 : 0
        }
        print(sum)
    }
}
