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

// Temporary imports
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
        let classifier = TinyTextClassifier()
        for window in windows {
            // Create gradient method pasing the model, the input and target
            let lossAndGradientMethod = valueAndGrad(model: classifier) { (model: TinyTextClassifier, input: MLXArray, target: MLXArray)  in
                classifierLoss(
                    model: model,
                    tokenIdentifiers: input,
                    attentionMask: window.attentionMask,
                    targetLabel: target
                )
            }

            let (loss, gradients) = lossAndGradientMethod(classifier, window.tokenIdentifiers, MLXArray(1))

            print("Loss =", loss)
            print("Gradients =", gradients)

            for (parameterName, gradient) in gradients.flattened() {
                print(parameterName, gradient.shape)
            }


            // We exit the loop because we just want to classify
            // the first window for learning purposes
            break
        }
    }

    static func classifierLoss(model: TinyTextClassifier,
                               tokenIdentifiers: MLXArray,
                               attentionMask: MLXArray,
                               targetLabel: MLXArray) -> MLXArray {
        let logits = model(tokenIdentifiers, attentionMask)
        print("Logits = ", logits)
        let loss = crossEntropy(logits: logits,
                                targets: targetLabel,
                                reduction: .mean)
        return loss
    }
}
