//
//  DateExtensions.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}

public extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) { uniqueElements, element in
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}
