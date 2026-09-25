//
//  File.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 19/09/2026.
//

import Foundation

// PREPROCESSING
//
// text
// ↓
// normalize
// ↓
// tokenize / content IDs
// ↓
// split content IDs into windows
// ↓
// add special tokens to EACH window
// ↓
// pad each window
// ↓
// create attention mask
//
// MODEL
//
// each window
// ↓
// embeddings
// ↓
// masked pooling
// ↓
// classification
// ↓
// window logits

@main
struct DidYouReallyWriteIt {
    static func main() async throws {
        let input = "Hello world"

        // Preprocessing
        let preprocessor = Preprocessing(input: input)
        let windows = try await preprocessor.call()

        for (index, window) in windows.enumerated() {
            print("---")
            print("Window: \(index)")
            for (index, item) in window.tokenIdentifiers.enumerated() {
                print("   item - \(item)")
                print("   mask - \(window.attentionMask[index])")
            }
        }
    }
}
