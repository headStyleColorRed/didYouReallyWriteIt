//
//  File.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 19/09/2026.
//

import Foundation

//text
//↓
//normalize
//↓
//tokenize / content IDs
//↓
//split content IDs into windows
//↓
//add special tokens to EACH window
//↓
//pad last window
//↓
//create mask

@main
struct DidYouReallyWriteIt {
    static func main() async throws {
        let input = "We need to tackle the subtle part we postponed: how to get the content IDs without <s> and </s>, and then add the special tokens independently to every window."

        // Normalizing
        let normalizer = Normalizer()
        let normalizedInput = normalizer.normalize(input)

        // Encoding
        let tokenizer = try await DYRWITokenizer(tokenizer: ProjectConstants.tokenizer)
        let tokenData: TokenizationData = try tokenizer.encode(normalizedInput: normalizedInput)

        // Creating windows
        let windowManager = WindowManager()
        let windows = windowManager.createWindows(data: tokenData)

        for (index, window) in windows.enumerated() {
            print("---")
            print("Window: \(index)")
            for item in window {
                print("  - \(item)")
            }
        }
    }
}
