//
//  NSObject + Ex.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import Foundation

extension NSObject {
    static var className: String {
        guard let className = String(describing: self).components(separatedBy: ".").last else {
            print(String(describing: self))
            fatalError("Class name couldn't find.")
        }
        return className
    }
}
