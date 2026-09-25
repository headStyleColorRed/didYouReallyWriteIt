//
//  Normalizer.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 19/09/2026.
//

import Foundation

struct Normalizer {
    func normalize(_ input: String) -> String {
        var normalizedText = input.precomposedStringWithCanonicalMapping
        normalizedText = normalizedText.replacingOccurrences(of: "\r\n", with: "\n")
        normalizedText = normalizedText.replacingOccurrences(of: "\r", with: "\n")
        return normalizedText
    }
}
