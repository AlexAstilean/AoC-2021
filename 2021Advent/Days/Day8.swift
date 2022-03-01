//
//  Day8.swift
//  2021Advent
//
//  Created by Alex Astilean on 07.12.2021.
//

import Foundation

class Day8: Day {

    func run() {

        let path = Bundle.main.path(forResource: "inputDay8", ofType: "txt")
        guard let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8) else { return }

        let lines = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)

        part1(lines: lines)
        part2(lines: lines)
    }

    func part1(lines: [String]) {
        let outputVals = lines.compactMap { $0.components(separatedBy: " | ").last?.components(separatedBy: .whitespaces) }

        let sum = outputVals.reduce(0) {
            $0 + $1.filter { [2,3,4,7].contains($0.count)}.count
        }
        print("Part 1: Sum: \(sum)")
    }

    func part2(lines: [String]) {
        var total = 0
        for line in lines {
            let components = line.components(separatedBy: " | ")
            let pattern = components.first!.components(separatedBy: .whitespaces).map { $0.compactMap{ String($0)} }
            let outputVal = components.last!.components(separatedBy: .whitespaces).map { $0.compactMap{ String($0)} }

            let one = pattern.first(where: { $0.count == 2 })!
            let seven = pattern.first(where: { $0.count == 3 })!
            let four = pattern.first(where: { $0.count == 4 })!
            let eight = pattern.first(where: { $0.count == 7 })!

//            let aSeg = seven.difference(from: one)
            let six = pattern.first(where: { $0.count == 6 && one.intersection(from: $0).count == 1 })!
            let fSeg = one.intersection(from: six)
            let cSeg = one.difference(from: fSeg)
            let two = pattern.first(where:{ $0.count == 5 && $0.contains(cSeg.first!) && !$0.contains(fSeg.first!) })
            let five = pattern.first(where:{ $0.count == 5 && !$0.contains(cSeg.first!) && $0.contains(fSeg.first!) })
            let three = pattern.first(where:{ $0.count == 5 && $0.contains(cSeg.first!) && $0.contains(fSeg.first!) })

            let eSeg = two!.difference(from: five!).difference(from: cSeg)

            let zero = pattern.first(where: { $0.count == 6 && $0 != six && $0.contains(eSeg.first!) })

            let nine = pattern.first(where: { $0.count == 6 && $0 != six && $0 != zero })

            var lineNumber = 0
            for value in outputVal {

                var current = 0

                switch value.sorted() {
                case one.sorted(): current = 1
                case two!.sorted(): current = 2
                case three!.sorted(): current = 3
                case four.sorted(): current = 4
                case five!.sorted(): current = 5
                case six.sorted(): current = 6
                case seven.sorted(): current = 7
                case eight.sorted(): current = 8
                case nine!.sorted(): current = 9
                default: break
                }

                lineNumber = lineNumber * 10 + current
            }

            total += lineNumber
        }
        print("Part 2: Sum: \(total)")
    }
}

extension Array where Element: Hashable {

    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet)).filter { !otherSet.contains($0)}
    }

    func intersection(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.intersection(otherSet))
    }

    func union(_ other: [Element]) -> [Element] {
        var thisSet = Set(self)
        let otherSet = Set(other)
        thisSet.formUnion(otherSet)

        return Array(thisSet)
    }
}
