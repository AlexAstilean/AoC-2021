//
//  Day4.swift
//  2021Advent
//
//  Created by Alex Astilean on 04.12.2021.
//

import Foundation

class Day4: Day {

    typealias BingoBoard = [[(Int,Bool)]]
    var extractedNumbers: [Int] = []
    func run() {

        let path = Bundle.main.path(forResource: "inputDay4", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        var boards: [BingoBoard] = []

        guard var lines = string?.components(separatedBy: "\n\n") else {
            print("No components")
            return
        }
        
        extractedNumbers = lines.removeFirst().components(separatedBy: ",").compactMap { Int($0) }

        boards = lines.compactMap { item -> BingoBoard in

            let lines = item.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

            let board = lines.reduce(BingoBoard()) { result, item in
                var res = result
                let row = item.components(separatedBy: .whitespaces).compactMap { item -> (Int, Bool)? in
                    if let number = Int(item) {
                        return (number, false)
                    } else {
                        return nil
                    }
                }
                res.append(row)
                return res
            }
            return board
        }

        part1(boards: boards)
        part2(boards: boards)
    }

    func part1(boards: [BingoBoard]) {

        var boards = boards
        var winningNumber: Int?
        var winningBoard = BingoBoard()

        extractedNumbers.forEach { number in
            if winningNumber != nil {
                return
            }
            for i in 0..<boards.count {

                for line in 0..<boards[i].count {

                    for col in 0..<boards[i][line].count {
                        if boards[i][line][col].0 == number {
                            boards[i][line][col].1 = true

                            var isWinner = true
                            for l in 0..<boards[i].count {
                                if !boards[i][l][col].1 {
                                    isWinner = false
                                }
                            }
                            if isWinner == true {
                                winningNumber = number
                                winningBoard = boards[i]
                                return
                            }
                            isWinner = true
                            for c in 0..<boards[i][line].count {
                                if !boards[i][line][c].1 {
                                    isWinner = false
                                }
                            }
                            if isWinner == true {
                                winningNumber = number
                                winningBoard = boards[i]
                                return
                            }
                        }
                    }
                }
            }
        }

        var sum = 0
        winningBoard.forEach {
            $0.forEach {
                if !$0.1 {
                    sum += $0.0
                }
            }
        }
        print("Part 1 Winner number: \(winningNumber!) sum: \(sum) result: \(sum * winningNumber!)")
    }

    func part2(boards: [BingoBoard]) {
        var boards = boards
        var winningNumber: Int?
        var winningBoard: BingoBoard?

        extractedNumbers.forEach { number in
            if winningBoard != nil {
                return
            }
            for (i, _) in boards.enumerated().reversed() {

            boardLoop: for line in 0..<boards[i].count {

                    for col in 0..<boards[i][line].count {
                        if boards[i][line][col].0 == number {
                            boards[i][line][col].1 = true

                            var isWinner = true
                            for l in 0..<boards[i].count {
                                if !boards[i][l][col].1 {
                                    isWinner = false
                                }
                            }
                            if isWinner == true {
                                winningNumber = number
                                guard boards.count > 1 else {
//                                    print("Board got to 1")
                                    winningBoard = boards[0]
                                    return
                                }
//                                print("removing \(i) left \(boards.count) numberWon \(number)")
//                                printBoard(board: boards[i])
                                boards.remove(at: i)

                                break boardLoop
                            }
                            isWinner = true
                            for c in 0..<boards[i][line].count {
                                if !boards[i][line][c].1 {
                                    isWinner = false
                                }
                            }
                            if isWinner == true {
                                winningNumber = number
                                guard boards.count > 1 else {
                                    print("Board got to 1")
                                    winningBoard = boards[0]
                                    return
                                }
//                                print("removing \(i) left \(boards.count) numberWon \(number)")
//                                printBoard(board: boards[i])
                                boards.remove(at: i)

                                break boardLoop
                            }
                        }
                    }
                }
            }
        }
        var sum = 0
        winningBoard?.forEach {
            $0.forEach {
                if !$0.1 {
                    sum += $0.0
                }
            }
        }
        print("Part 2 Winner number: \(winningNumber!) sum: \(sum) result: \(sum * winningNumber!)")
        printBoard(board: winningBoard!)
    }

    func printBoard(board: BingoBoard) {

        board.forEach {
            $0.forEach {
                print("\($0.0)\($0.1 ? "*" : "")", terminator: $0.1 ? "   " : "    ")
            }
            print("")
        }
    }
}
