//
//  Preprocessing.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 25/09/2026.
//

import Foundation

class Preprocessing {
    let input: String
    let normalizer = Normalizer()
    let windowManager = WindowManager()

    init(input: String) {
        self.input = input
    }

    func call() async throws -> [TokenWindow] {
        // Normalizing
        let normalizedInput = normalizer.normalize(input)

        // Tokenize
        let tokenizer = try await DYRWITokenizer(tokenizer: ProjectConstants.tokenizer)
        let tokenData: TokenizationData = try tokenizer.encode(normalizedInput: normalizedInput)

        // Creating windows with bos/eos and padding
        return windowManager.createWindows(data: tokenData)
    }

}
