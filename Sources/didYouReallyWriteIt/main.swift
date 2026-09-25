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

// Temporary import
import MLX
import MLXNN

@main
struct DidYouReallyWriteIt {
    static func main() async throws {
        let input = "Hello world"

        // Preprocessing
        let preprocessor = Preprocessing(input: input)
        let windows = try await preprocessor.call()

        // Small clasifier for a single window
        guard let firstWindow = windows.first else { throw "Couldn't get first window".asError }

        let tokenIndentifiers = MLXArray(firstWindow.tokenIdentifiers)
        let embedding = Embedding(embeddingCount: 50_265, dimensions: 23)
        let tokenEmbeddings = embedding(tokenIndentifiers)

        print(tokenEmbeddings)
    }
}
