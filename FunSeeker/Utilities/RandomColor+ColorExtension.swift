//
//  RandomColor+ColorExtension.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-07-01.
//

import Foundation
import SwiftUI

public extension Color {

    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}
