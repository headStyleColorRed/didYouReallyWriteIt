//
//  DYRWITokenizer.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 19/09/2026.
//

import Foundation
import Tokenizers

class DYRWITokenizer {
    let tokenizerName: String
    var tokenizer: Tokenizer?

    init(tokenizer tokenizerName: String) async throws {
        self.tokenizerName = tokenizerName
        try await loadTokenizer()
    }

    func encode(normalizedInput: String) throws -> [Int] {
        guard let encodedInput = tokenizer?.encode(text: normalizedInput) else { throw "Won't happen".asError }
        return encodedInput
    }




    // MARK: -  Private methods
    private func loadTokenizer() async throws {
        tokenizer = try await AutoTokenizer.from(pretrained: tokenizerName)
    }


//    private func addPadding(tokens: [Int], maxLength: Int) throws -> ([Int], [Int]) {
//        guard let paddingTokenIdentifier = tokenizer?.convertTokenToId(SpecialTokens.padding.rawValue) else {
//            throw "Couldn't find padding token identifier".asError
//        }
//
//        var paddedTokenIdentifiers: [Int] = tokens
//        var attentionMask: [Int] = Array(repeating: 1, count: tokens.count)
//
//        guard tokens.count <= maxLength else { throw "Token count exceeds maximum sequence length".asError }
//
//        let padArray: [Int] = Array(repeating: paddingTokenIdentifier, count: maxLength - tokens.count)
//        let maskArray: [Int] = Array(repeating: 0, count: maxLength - tokens.count)
//
//        paddedTokenIdentifiers.append(contentsOf: padArray)
//        attentionMask.append(contentsOf: maskArray)
//
//        return (paddedTokenIdentifiers, attentionMask)
//    }
}
