//
//  Day13.swift
//  2021Advent
//
//  Created by Alex Astilean on 13.12.2021.
//

import Foundation

class Day13: Day {

    enum Axis: String {
        case x, y
    }
    struct Instruction {
        let axis: Axis
        let value: Int
    }

    struct Point: Hashable, CustomStringConvertible {
        let x: Int
        let y: Int

        var description: String {
            "(\(x),\(y))"
        }
    }

    typealias Matrix = [Point: Bool]

    var maxX = 0
    var maxY = 0

    func run() {
        let path = Bundle.main.path(forResource: "inputDay13", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        guard let lines = string?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "\n\n") else {
                  print("No components")
                  return
              }
        let instructions = lines[1]
            .components(separatedBy: .newlines)
            .map { instructionLine -> Instruction in
                let instr = instructionLine.components(separatedBy: .whitespaces).last?.components(separatedBy: "=")
                let axis = instr![0]
                let value = instr![1]
                return Instruction(axis: Axis(rawValue: axis)!, value: Int(value)!)
            }

        var matrix: Matrix = [:]

        lines[0].components(separatedBy: .newlines).forEach {
            let instr = $0.components(separatedBy: ",")
            let x = Int(instr[0])!
            let y = Int(instr[1])!
            if x > maxX {
                maxX = x
            }
            if y > maxY {
                maxY = y
            }
            matrix[Point(x: x, y: y)] = true
        }

        instructions.enumerated().forEach { index, instruction in

            fold(instruction: instruction, matrix: &matrix)
            if index == 0 {
                print("Part 1 | visible dots: \(matrix.filter { $0.value }.count)")
            }
        }

        print("Part 2 | code:")
        for yi in 0...maxY {
            for xi in 0...maxX {

                print(matrix[Point(x: xi, y: yi), default: false] ? "X" : " ", terminator: "")
            }
            print()
        }
    }

    func fold(instruction: Instruction, matrix: inout Matrix) {

        var newMatrix: Matrix = [:]

        let foldValue = instruction.value
        switch instruction.axis {
        case .x:
            for xi in 1...foldValue {

                for yi in 0...maxY {
                    let foldedOnto = Point(x: foldValue - xi, y: yi)
                    let folded = Point(x: foldValue + xi, y: yi)
                    newMatrix[foldedOnto, default: false] = matrix[foldedOnto, default: false] || matrix[folded, default: false]
                }
            }
            maxX = foldValue - 1
        case .y:
            for yi in 1...foldValue {

                for xi in 0...maxX {
                    let foldedOnto = Point(x: xi, y: foldValue - yi)
                    let folded = Point(x: xi, y: foldValue + yi)
                    newMatrix[foldedOnto, default: false] = matrix[foldedOnto, default: false] || matrix[folded, default: false]
                }

            }
            maxY = foldValue - 1
        }
        matrix = newMatrix
    }
}
