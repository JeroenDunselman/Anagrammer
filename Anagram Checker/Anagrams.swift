//
//  Anagrams.swift
//  Anagram Checker
//
//  Created by Jeroen Dunselman on 24/11/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation

extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}

//  Permutations based on https://www.objc.io/blog/2014/12/08/functional-snippet-10-permutations/
class Permutation {
    
    func between<T>(x: T, _ ys: [T]) -> [[T]] {
        guard let (head, tail) = ys.decompose() else { return [[x]] }
        return [[x] + ys] + between(x: x, tail).map { [head] + $0 }
    }
    
    func permutations<T>(xs: [T]) -> [[T]] {
        guard let (head, tail) = xs.decompose() else { return [[]] }
        return permutations(xs: tail).flatMap { between(x: head, $0) }
    }
    
    func xsRange(len: Int) -> [Int] {
        let range:[Int] = (0..<len).enumerated().compactMap {$0.element}
        return range
    }
}

class PermutationService {
    let q = Permutation()
    var permutations:[[Int]] = []
    
    init(length: Int){
        //all index variations
        permutations = createPermutation(length: length)
    }
    
    func createPermutation(length: Int) -> [[Int]] {
        let result: [[Int]] = q.permutations(xs: q.xsRange(len: length))
        return result
    }
}

class AnagramService {
    var _word:String = ""
    var anagrams:[String] = []
    
    func translate(permutation:[Int]) -> String {
        //restring _word using permutation
        let string = permutation.reduce("") { $0 + String(_word[_word.index(_word.startIndex, offsetBy: $1)]) }
        return string
    }
    
    init(word: String){
        _word = word
        let permutations:[[Int]] = PermutationService(length: _word.count).permutations
        
        //get restring for each permutation
        let translations = permutations.map { translate(permutation: $0) }
        
        //prevent string doubles (caused by non-unique chars in input)
        anagrams = translations.unique
        //prevent word
        anagrams = anagrams.filter { $0 != _word }
        
    }
    
    func isAnagram(check: String) -> Bool{
        
        func checkForAnagram(check firstStr: String, against secondStr: String) -> Bool {
            return firstStr.lowercased().sorted() == secondStr.lowercased().sorted()
        }
        
        if check == _word {
            return false
        } else {
            return anagrams.contains(where: { checkForAnagram(check: $0, against: check)})
        }
    }
    
}
