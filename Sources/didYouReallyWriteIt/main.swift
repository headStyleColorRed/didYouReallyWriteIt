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

        // Small clasifier for a single window
        let classifier = WindowClassifier()
        for window in windows {
            classifier(window)


            // We exit the loop because we just want to classify
            // the first window for learning purposes
            break
        }
    }
}
