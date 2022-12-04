//
//  AssignmentViewModel.swift
//  AdventOfCode22Assignment3
//
//  Created by David van Erkelens on 04/12/2022.
//

import Foundation

class AssignmentViewModel: ObservableObject {
    @Published var input: String = "paste input here"
    @Published var output: String = "output will be shown here"
    @Published var result: String = ""

    func executeAssignmentOne() {
        output = ""
        var totalScore = 0
        let lines = input.components(separatedBy: "\n")
        for line in lines {

            let compartmentSize = line.count / 2
            let firstIndex = line.index(line.startIndex, offsetBy: compartmentSize)
            let firstCompartment = String(line[..<firstIndex])
            let secondCompartment = String(line[firstIndex...])

            let firstArray = Array(firstCompartment)
            let secondArray = Array(secondCompartment)

            let firstSet: Set<Character> = Set(firstArray)
            let secondSet: Set<Character> = Set(secondArray)

            var intersection = firstSet.intersection(secondSet)

            let character = intersection.removeFirst()
            let score = getScoreForChar(char: character)

            output += "Duplicate is \(character) with a score of \(score)\n"
            totalScore += Int(score)
        }

        result = "\(totalScore)"
    }

    func executeAssignmentTwo() {
        output = ""
        var totalScore = 0
        var lines = input.components(separatedBy: "\n")

        repeat {

            let lineOne = Array(lines.removeFirst())
            let lineTwo = Array(lines.removeFirst())
            let lineThree = Array(lines.removeFirst())

            let setOne = Set(lineOne)
            let setTwo = Set(lineTwo)
            let setThree = Set(lineThree)

            var intersection = setOne.intersection(setTwo).intersection(setThree)

            let character = intersection.removeFirst()
            let score = getScoreForChar(char: character)

            output += "Duplicate is \(character) with a score of \(score)\n"
            totalScore += Int(score)


        } while (lines.count > 0)

        result = "\(totalScore)"

    }

    private func getScoreForChar(char: Character) -> UInt8 {
        if (char.isUppercase) {
            return char.asciiValue! - Character("A").asciiValue! + 27;
        }

        return char.asciiValue! - Character("a").asciiValue! + 1;
    }
}
