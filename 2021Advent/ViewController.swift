//
//  ViewController.swift
//  2021Advent
//
//  Created by Alex Astilean on 29.11.2021.
//

import Cocoa

enum Days {
    case day1
    case day2
    case day3
    case day4
    case day5
    case day6
    case day7
    case day8
    case day9
    case day10
    case day11
    case day12
    case day13
    case day14
    case day15
    case day16
    case day17
    case day18
    case day19
    case day20
    case day21
    case day22
}

class ViewController: NSViewController {

    class Person {
        private let fo: String
        private let sur: String
        private let age: Int?

        init(_ f: String, s: String, age: Int? = nil) {
            fo = f
            sur = s
            self.age = age

        }
        func write() {
            print("Hello, \(sur) \(fo), and I am \(age!)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        for i in 1...100 {
//            var string = ""
//            string.append(i % 3 == 0 ? "Fan" : "")
//            string.append(i % 5 == 0  ? "Duel" : "")
//            print(string.isEmpty ? i : string)
//        }

        testGet(urlString: "https://jsonplaceholder.typicode.com/todos/1)") { result in
            print(result)
        }
    }

    func runAdvent() {
        let day: Day = Day25()

        print("Start \(type(of: day))\n")
        let startTime = CFAbsoluteTimeGetCurrent()
        day.run()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("\nTime elapsed: \(timeElapsed) s.")
    }

    func testGetUsers() {

        struct User: Codable {
            let name: String
        }
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error: \(error)")
                return
            }

            do {
                let user = try JSONDecoder().decode([User].self, from: data)
                print(user)
            } catch {
                print("Error decode")
            }
        }
        task.resume()
    }

    typealias HttpCallResponse = Result<String, Error>

    enum NetworkError: Error {
        case invalidURL
        case noData
    }

    func testGet(urlString: String, completion: @escaping(HttpCallResponse) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                let stringData  = String(data: data, encoding: .utf8) else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(stringData))
        }
        task.resume()
    }
}

protocol P {
    var a: String { get set }
    func sas() -> Int
}
extension P {
    func sss() -> String {
        return ""
    }
}
extension StringProtocol {

    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
