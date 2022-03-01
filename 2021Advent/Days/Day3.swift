//
//  Day3.swift
//  2021Advent
//
//  Created by Alex Astilean on 03.12.2021.
//

import Foundation

class Day3: Day {

    func run() {

        let path = Bundle.main.path(forResource: "inputDay3", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let lines = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines) else {
            print("No components")
            return
        }

        var matrix = [[Int]]()

        for line in lines {

            matrix.append(line.map { Int(String($0)) ?? 2 })
        }
        part1(matrix: matrix)
        part2(inputMatrix: matrix)
    }

    func part1(matrix: [[Int]]) {
        var gammaRate: String = ""
        var epsilonRate: String = ""

        var colIndex = 0

        while colIndex < matrix[0].count {
            var lineIndex = 0
            var zeros = 0
            var ones = 0
            while lineIndex < matrix.count {

                zeros += matrix[lineIndex][colIndex] == 0 ? 1 : 0
                ones += matrix[lineIndex][colIndex] == 1 ? 1 : 0
                lineIndex += 1
            }

            gammaRate.append(zeros > ones ? "0" : "1")
            epsilonRate.append(zeros > ones ? "1" : "0")
            colIndex += 1
        }

        guard let gammaRateN = Int(gammaRate, radix: 2),
              let epsilonRateN = Int(epsilonRate, radix: 2) else {
                  return
              }
        print("Part 1. Power Consumption: \(gammaRateN*epsilonRateN)")
    }

    func part2(inputMatrix: [[Int]]) {

        var matrix = inputMatrix
        var colIndex = 0

        while colIndex < matrix[0].count {
            var lineIndex = 0
            var zeros = 0
            var ones = 0
            while lineIndex < matrix.count {

                zeros += matrix[lineIndex][colIndex] == 0 ? 1 : 0
                ones += matrix[lineIndex][colIndex] == 1 ? 1 : 0
                lineIndex += 1
            }

            if zeros > ones {
                matrix.removeAll(where: { $0[colIndex] == 1 })
            } else {
                matrix.removeAll(where: { $0[colIndex] == 0 })
            }
            if matrix.count == 1 {
                break
            }
            colIndex += 1
        }
        let oxygenGen = matrix.flatMap { $0 }.reduce("") { $0.appending($1.description)}

        matrix = inputMatrix
        colIndex = 0

        while colIndex < matrix[0].count {
            var lineIndex = 0
            var zeros = 0
            var ones = 0
            while lineIndex < matrix.count {

                zeros += matrix[lineIndex][colIndex] == 0 ? 1 : 0
                ones += matrix[lineIndex][colIndex] == 1 ? 1 : 0
                lineIndex += 1
            }

            if zeros > ones {
                matrix.removeAll(where: { $0[colIndex] == 0 })
            } else {
                matrix.removeAll(where: { $0[colIndex] == 1 })
            }
            if matrix.count == 1 {
                break
            }
            colIndex += 1
        }
        let co2Scrubber = matrix.flatMap { $0 }.reduce("") { $0.appending($1.description)}

        guard let oxygen = Int(oxygenGen, radix: 2),
              let co2 = Int(co2Scrubber, radix: 2) else {
                  return
              }
        print("Part 2. Life support: \(oxygen * co2)")
    }
}
