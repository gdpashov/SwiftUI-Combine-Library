//
//  Requestable.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import Foundation

protocol Requestable {
    var error: Error? { get }
    var isRequesting: Bool { get }
}
