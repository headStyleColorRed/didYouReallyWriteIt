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
    let padTokenID: Int
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
              let eosTokenId = tokenizer?.eosTokenId ?? tokenizer?.convertTokenToId("</s>"),
              let padTokenId = tokenizer?.convertTokenToId("<pad>") else {
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
                                eosTokenID: eosTokenId,
                                padTokenID: padTokenId)
    }




    // MARK: -  Private methods
    private func loadTokenizer() async throws {
        tokenizer = try await AutoTokenizer.from(pretrained: tokenizerName)
    }

}
