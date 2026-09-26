//
//  WindowClassifier.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 25/09/2026.
//

import Foundation
import MLX
import MLXNN

final class TinyTextClassifier: Module {
    @ModuleInfo var embedding: Embedding
    @ModuleInfo var classifier: Linear

    init(embedding: Embedding = Embedding(embeddingCount: 50_265, dimensions: 23),
         classifier: Linear = Linear(23, 2)) {
        self.embedding = embedding
        self.classifier = classifier
        super.init()
    }

    func callAsFunction(_ tokenIdentifiers: MLXArray, _ attentionMask: MLXArray) -> MLXArray {
        // Convert the tokens array into an MLX one
        let tokenIdentifiers = tokenIdentifiers
        // Fill the the matrix with the current tokens
        let tokenEmbeddings = embedding(tokenIdentifiers)
        // Convert the mask array into an MLX one
        let attentionMask = attentionMask
        // Convert the attention mask into a two dimensional array
        let expandedAttentionMask = attentionMask[.ellipsis, .newAxis]
        // Prune the masked token embeddings
        let maskedEmbeddings = tokenEmbeddings * expandedAttentionMask
        // Sume the valid embeddings
        let embeddingSum: MLXArray = maskedEmbeddings.sum(axis: 0)
        // Divide by the valid amount of embeddings
        let validEmbeddingsCount = attentionMask.sum()
        let pooledEmbedding = embeddingSum / validEmbeddingsCount
        // Produce the classification logits
        let logits = classifier(pooledEmbedding)

        return logits
    }

}
