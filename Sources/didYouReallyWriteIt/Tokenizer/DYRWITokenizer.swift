//
//  DYRWITokenizer.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 19/09/2026.
//

import Foundation
import Tokenizers

struct TokenizationData {
    let tokens: [Int]
    let bosTokenID: Int
    let eosTokenID: Int
}

class DYRWITokenizer {
    let tokenizerName: String
    var tokenizer: Tokenizer?

    init(tokenizer tokenizerName: String) async throws {
        self.tokenizerName = tokenizerName
        try await loadTokenizer()
    }

    func encode(normalizedInput: String) throws -> TokenizationData {
        guard let encodedInput = tokenizer?.encode(text: normalizedInput, addSpecialTokens: false) else {
            throw "Couldn't load tokenizer".asError
        }
        guard let bosTokenId = tokenizer?.bosTokenId ?? tokenizer?.convertTokenToId("<s>"),
                let eosTokenId = tokenizer?.eosTokenId ?? tokenizer?.convertTokenToId("</s>") else {
            throw "Couldn't retrieve sentence delimeters".asError
        }

        // swift-transformers' RoBERTa post-processor currently adds BOS/EOS even when
        // addSpecialTokens is false. Detect that behavior with empty input so a
        // literal <s> or </s> in the text is not mistaken for an added delimiter.
        let emptyEncoding = tokenizer?.encode(text: "", addSpecialTokens: false) ?? []
        let contentTokens: [Int]
        if emptyEncoding == [bosTokenId, eosTokenId],
           encodedInput.first == bosTokenId,
           encodedInput.last == eosTokenId {
            contentTokens = Array(encodedInput.dropFirst().dropLast())
        } else {
            contentTokens = encodedInput
        }

        return TokenizationData(tokens: contentTokens,
                                bosTokenID: bosTokenId,
                                eosTokenID: eosTokenId)
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
