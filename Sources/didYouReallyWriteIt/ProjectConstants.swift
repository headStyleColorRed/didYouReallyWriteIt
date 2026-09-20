//
//  ProjectConstants.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 19/09/2026.
//

import Foundation

struct ProjectConstants {
    static let tokenizer: String = "FacebookAI/roberta-base"

    // We are substracting 2 because we don't want
    // to count the start/end of the input
    static let windowSize: Int = 512 - 2
    static let overlap: Float = 0.5
}
