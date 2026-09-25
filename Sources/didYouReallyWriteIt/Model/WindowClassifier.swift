//
//  WindowClassifier.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 25/09/2026.
//

import Foundation
import MLX
import MLXNN

struct WindowClassifier {


    func callAsFunction(_ window: TokenWindow) {
        // Convert the tokens array into an MLX one
        let tokenIndentifiers = MLXArray(window.tokenIdentifiers)
        // Create empty matrix
        let embedding = Embedding(embeddingCount: 50_265, dimensions: 23)
        // Fill the the matrix with the current tokens
        let tokenEmbeddings = embedding(tokenIndentifiers)
        // Convert the mask array into an MLX one
        let attentionMask = MLXArray(window.attentionMask)
        // Convert the attention mask into a two dimensional array
        let expandedAttentionMask = attentionMask[.ellipsis, .newAxis]
        // Prune the masked token embeddings
        let maskedEmbeddings = tokenEmbeddings * expandedAttentionMask
        // Add embeddings and do.. pooling?
        let embeddingSum: MLXArray = maskedEmbeddings.sum(axis: 0)
        // Divide by the valid amount of embeddings
        let validEmbeddingsCount = window.attentionMask.filter({ $0 == 1}).count
        let pooledEmbedding = embeddingSum / validEmbeddingsCount
        // Create classifier
        let classifier = Linear(23, 2)
        // Run our result through the classifier
        let logits = classifier(pooledEmbedding)

        let targetLabel = MLXArray(1)
        let loss = crossEntropy(logits: logits,
                                targets: targetLabel,
                                reduction: .mean)



        print("Token embeddings:", tokenEmbeddings.shape)
        print("Masked embeddings:", maskedEmbeddings.shape)
        print("Embedding sum:", embeddingSum.shape)
        print("Pooled result:", pooledEmbedding.shape)
        print("Embedding: ", pooledEmbedding)
        print("Logits shape: ", logits.shape)
        print("Logits:", logits)
        print("Loss: ", loss)
    }

}
