/*
 --- Day 6: Custom Customs ---

 As your flight approaches the regional airport where you'll switch to a much larger plane, customs declaration forms are distributed to the passengers.

 The form asks a series of 26 yes-or-no questions marked a through z. All you need to do is identify the questions for which anyone in your group answers "yes". Since your group is just you, this doesn't take very long.

 However, the person sitting next to you seems to be experiencing a language barrier and asks if you can help. For each of the people in their group, you write down the questions for which they answer "yes", one per line. For example:

 abcx
 abcy
 abcz
 In this group, there are 6 questions to which anyone answered "yes": a, b, c, x, y, and z. (Duplicate answers to the same question don't count extra; each question counts at most once.)

 Another group asks for your help, then another, and eventually you've collected answers from every group on the plane (your puzzle input). Each group's answers are separated by a blank line, and within each group, each person's answers are on a single line. For example:

 abc

 a
 b
 c

 ab
 ac

 a
 a
 a
 a

 b
 
 This list represents answers from five groups:

 The first group contains one person who answered "yes" to 3 questions: a, b, and c.
 The second group contains three people; combined, they answered "yes" to 3 questions: a, b, and c.
 The third group contains two people; combined, they answered "yes" to 3 questions: a, b, and c.
 The fourth group contains four people; combined, they answered "yes" to only 1 question, a.
 The last group contains one person who answered "yes" to only 1 question, b.
 In this example, the sum of these counts is 3 + 3 + 3 + 1 + 1 = 11.

 For each group, count the number of questions to which anyone answered "yes". What is the sum of those counts?
 
 Answer:
 
 Success: 6443
 
 */
import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let rawText = try String(contentsOf: file!, encoding: .utf8)
let list = rawText.lines

extension String {
    var lines: [String] { components(separatedBy: .newlines) }
    
    var characters: [Character] {
        return Array(self)
    }
    
    func allUnqiues() -> String {
        return String(Set(self.characters))
    }
}

extension Array where Element == String {
    func allUniques() -> String {
        var set = Set(self[0].characters)
        
        for i in 1..<self.count {
            set.formUnion(Set(self[i].characters))
        }
        
        return String(set)
    }
    
    func sumOfCharacters() -> Int {
        var sum = 0
        
        self.forEach { sum += $0.count }
        
        return sum
    }
    
    func allContains(_ char: Character) -> Bool {
        for element in self {
            if !element.contains(char) {
                return false
            }
        }
        
        return true
    }
}

struct Group {
    var groupAnswers: [String]
    
    init(_ group: [String]) {
        self.groupAnswers = group
    }
    
    func numberOfAnswers() -> Int {
        let unqiueAnswers = groupAnswers.allUniques()
        return unqiueAnswers.count
    }
    
    func numberOfSimilarAnswers() -> Int {
        var numberOfSimilarities = 0
        
        if groupAnswers.count > 1 {
            let orderedAnswers = groupAnswers.sorted()
            
            for char in orderedAnswers.first! {
                numberOfSimilarities += orderedAnswers.allContains(char) ? 1 : 0
            }
        } else {
            numberOfSimilarities += groupAnswers.first!.count
        }
        
        return numberOfSimilarities
    }
}

struct Questionnaire {
    var groups: [Group]
    
    init(_ input: [[String]]) {
        self.groups = input.map { Group($0) }
    }
    
    static func generateGroupArray(_ input: [String]) -> [[String]] {
        var output: [[String]] = []
        var tempArray: [String] = []
        
        for element in input {
            if element == "" {
                output.append(tempArray)
                tempArray = []
            } else {
                tempArray.append(element)
            }
        }
        
        if tempArray.count > 0 {
            output.append(tempArray)
        }
        
        return output
    }
    
    func sumOfGroupsAnswers() -> Int {
        var numberOfAnswers = 0
        
        groups.forEach { numberOfAnswers += $0.numberOfAnswers() }
        
        return numberOfAnswers
    }
    
    func sumOfSimilarAnswers() -> Int {
        var numberOfAnswers = 0
        
        groups.forEach { numberOfAnswers += $0.numberOfSimilarAnswers() }
        
        return numberOfAnswers
    }
}

let testData = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""

func test() {
    let list = testData.lines
    let input = Questionnaire.generateGroupArray(list)
    let questionnaire = Questionnaire(input)
    
    print(questionnaire.sumOfGroupsAnswers())
}

func processDataForPart1() {
    let input = Questionnaire.generateGroupArray(list)
    let questionnaire = Questionnaire(input)
    
    print(questionnaire.sumOfGroupsAnswers())
}

test()
processDataForPart1()

/*
 --- Part Two ---

 As you finish the last group's customs declaration, you notice that you misread one word in the instructions:

 You don't need to identify the questions to which anyone answered "yes"; you need to identify the questions to which everyone answered "yes"!

 Using the same example as above:

 abc

 a
 b
 c

 ab
 ac

 a
 a
 a
 a

 b
 
 This list represents answers from five groups:

 In the first group, everyone (all 1 person) answered "yes" to 3 questions: a, b, and c.
 In the second group, there is no question to which everyone answered "yes".
 In the third group, everyone answered yes to only 1 question, a. Since some people did not answer "yes" to b or c, they don't count.
 In the fourth group, everyone answered yes to only 1 question, a.
 In the fifth group, everyone (all 1 person) answered "yes" to 1 question, b.
 In this example, the sum of these counts is 3 + 0 + 1 + 1 + 1 = 6.

 For each group, count the number of questions to which everyone answered "yes". What is the sum of those counts?
 
 Answer:
 
 
 
 */

func test2() {
    let list = testData.lines
    let input = Questionnaire.generateGroupArray(list)
    let questionnaire = Questionnaire(input)
    
    print(questionnaire.sumOfSimilarAnswers())
}

func processDataForPart2() {
    let input = Questionnaire.generateGroupArray(list)
    let questionnaire = Questionnaire(input)
    
    print(questionnaire.sumOfSimilarAnswers())
}

test2()
processDataForPart2()
