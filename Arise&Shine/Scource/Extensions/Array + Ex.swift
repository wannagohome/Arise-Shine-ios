//
//  Array + Ex.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/02/23.
//

extension Array where Element: Equatable {
    func index(of compare: Element) -> Int? {
        for (index, item) in self.enumerated() {
            if item == compare { return index }
        }
        return nil
    }
}
