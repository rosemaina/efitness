//
//  String+.swift
//  eFitness
//
//  Created by Rose Maina on 08/11/2021.
//

import Foundation

extension String {
    var removingSpaces: String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
