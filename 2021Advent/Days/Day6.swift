//
//  Day6.swift
//  2021Advent
//
//  Created by Alex Astilean on 05.12.2021.
//

import Foundation

class Day6: Day {

    func run() {

        let path = Bundle.main.path(forResource: "inputDay6", ofType: "txt")
        guard let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8) else { return }

        let currentDay = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .compactMap { Int($0) }

        let daysCount = 256
        var part1Result = 0

        var schoolfish = [Int](repeating: 0, count: 9)

        for fish in currentDay {
            schoolfish[fish] += 1
        }

        for i in 0 ..< daysCount {
            var nextDaySchoolfish = [Int](repeating: 0, count: 9)
            for (daysLeft, fishNumber) in schoolfish.enumerated() {

                if daysLeft == 0 {
                    nextDaySchoolfish[6] += fishNumber
                    nextDaySchoolfish[8] += fishNumber
                } else {
                    nextDaySchoolfish[daysLeft-1] += fishNumber
                }
            }
            schoolfish = nextDaySchoolfish
            if i == 79 {
                part1Result = schoolfish.reduce(0, +)
            }
        }
        print("Part 1: Number of fish after 80 days: \(part1Result)")
        print("Part 2: Number of fish after 256 days: \(schoolfish.reduce(0, +))")
    }
}
