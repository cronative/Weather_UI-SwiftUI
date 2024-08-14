//
//  CollectionExtensions.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation
import RealmSwift

extension Collection where Element: Object {
    func toArray() -> [Element] {
        var array = [Element]()
        for item in self {
            array.append(item)
        }
        return array
    }
}
