//
//  String+Extension.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import Foundation

extension String {
    /// Localized string.
    ///
    /// - Returns: Localized string.
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Localized string.
    ///
    /// - Parameters:
    ///   - arguments: Positional arguments in string.
    /// - Returns: Localized string.
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
