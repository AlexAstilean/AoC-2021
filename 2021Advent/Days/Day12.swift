//
//  Day12.swift
//  2021Advent
//
//  Created by Alex Astilean on 12.12.2021.
//

import Foundation

class Day12: Day {

    var part: Part = .part1

    func run() {
        let path = Bundle.main.path(forResource: "inputDay12", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let lines = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines) else {
            print("No components")
            return
        }

        var map: [String: [String]] = [:]
        lines.forEach {
            let components = $0.components(separatedBy: "-")
            map[components.first!, default: []].append(components[1])
            map[components[1], default: []].append(components[0])
        }

        var result = part2(map: map, current: "start", seen: Set<String>())
        print("Part 1 | Number of paths: \(result)")
        part = .part2
        result = part2(map: map, current: "start", seen: Set<String>())
        print("Part 2 | Number of paths: \(result)")
    }

    func part2(map: [String: [String]], current: String, seen: Set<String>, duplicate: String? = nil) -> Int {

        if current == "end" {
            return 1
        }
        if current == "start", seen.contains(current) {
            return 0
        }
        var dup = duplicate
        if current.isAllLowercase, seen.contains(current) {
            switch part {
            case .part1:
                // Part 1 doesn't allow duplicate
                return 0
            case .part2:
                // Part 2 allows one duplicate
                if duplicate != nil {
                    return 0
                } else {
                    dup = current
                }
            }
        }

        var seenNew = seen
        seenNew.insert(current)
        var paths = 0
        map[current]?.forEach {
            paths += part2(map: map, current: $0, seen: seenNew, duplicate: dup)
        }
        return paths
    }
}

extension String {

    var isAllLowercase: Bool {
        lowercased() == self
    }

    var isAllUppercased: Bool {
        uppercased() == self
    }
}
