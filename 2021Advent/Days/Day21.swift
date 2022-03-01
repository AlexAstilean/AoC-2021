//
//  Day21.swift
//  2021Advent
//
//  Created by Alex Astilean on 21.12.2021.
//

import Foundation

class Day21: Day {

    struct Player: Hashable {
        var score = 0
        var position: Int

        mutating func move(by steps: Int) {
            position += steps
            if position > 10 {
                if position % 10 == 0 {
                    position = 10
                } else {
                    position = position % 10
                }
            }
            score += position
        }
    }

    func run() {

        let p1 = Player(position: 4)
        let p2 = Player(position: 2)
        part1(player1: p1, player2: p2)
        part2(player1: p1, player2: p2)
    }


    func part1(player1: Player, player2: Player) {

        var die = 1
        var rolls = 0

        var one = player1
        var two = player2

        func next() -> Int {
            defer {
                die += 3
                die %= 10
                rolls += 3
            }
            return 3 * (die + 1)
        }

        var isPlayerOnesTurn = true

        while one.score < 1000 && two.score < 1000 {
            let score = next()
            if isPlayerOnesTurn {
                one.move(by: score)
            } else {
                two.move(by: score)
            }
            isPlayerOnesTurn.toggle()
        }

        print("P1 score: \(one.score), P2 score: \(two.score), rolls: \(rolls) , die \(die)")

        print("Part 1 | Result: \(min(one.score, two.score) * rolls)")
    }

    func part2(player1: Player, player2: Player) {
        struct Game: Hashable {
            var one: Player
            var two: Player
            var isPlayerOnesTurn = true

            var aWins: Bool? {
                if one.score >= 21 { return true }
                if two.score >= 21 { return false }
                return nil
            }

            func next() -> [Game: Int] {
                var games: [Game: Int] = [:]
                [1, 2, 3].forEach { first in
                    [1, 2, 3].forEach { second in
                        [1, 2, 3].forEach { third in
                            let score = first + second + third
                            var copy = self
                            if copy.isPlayerOnesTurn {
                                copy.one.move(by: score)
                            } else {
                                copy.two.move(by: score)
                            }
                            copy.isPlayerOnesTurn.toggle()
                            games[copy, default: 0] += 1
                        }
                    }
                }
                return games
            }
        }

        var seenGames: [Game: Bool] = [:]
        var aWins = 0
        var bWins = 0
        var games = [Game(one: Player(position: 8), two: Player(position: 7)): 1]

        while let (game, instances) = games.popFirst() {
            if let existing = seenGames[game] {
                if existing { aWins += instances }
                else { bWins += instances }
                continue
            }

            for (newGame, c) in game.next() {
                let newGameInstances = instances * c

                if let existing = seenGames[newGame] {
                    if existing { aWins += newGameInstances }
                    else { bWins += newGameInstances }
                    continue
                }

                if let winner = newGame.aWins {
                    seenGames[newGame] = winner
                    if winner { aWins += newGameInstances }
                    else { bWins += newGameInstances }
                    continue
                }

                games[newGame, default: 0] += newGameInstances
            }
        }

        print("Part 2 | Result: \(max(aWins, bWins))")
    }
}
