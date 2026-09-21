//
//  DYRWIWindowManager.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 19/09/2026.
//

import Foundation

struct TokenWindow {
    let tokenIdentifiers: [Int]
    let attentionMask: [Int]
}

struct WindowManager {
    private var contentWindowSize: Int {
        ProjectConstants.windowSize - 2
    }
    // We calculate the stride based on the windoSize to overlap relation
    private var stride: Int {
        return Int(Float(ProjectConstants.windowSize) * ProjectConstants.overlap)
    }

    // We need to return an array of arrays that have at maximum
    // the stride length
    func createWindows(data: TokenizationData) -> [TokenWindow] {
        let tokenIdentifiers = data.tokens
        let tokenCount = tokenIdentifiers.count
        let windowsToCreate = windowsNeeded(tokenCount: tokenCount)
        var windows: [TokenWindow] = []

        for windowIndex in 0..<windowsToCreate {
            var window: [Int] = []
            window.reserveCapacity(ProjectConstants.windowSize)
            // Add begining of sentence token
            window.append(data.bosTokenID)
            // Add the tokens
            createWindow(&window, index: windowIndex, tokens: tokenIdentifiers)
            // Add special characters
            window.append(data.eosTokenID)

            let windowLenght: Int = window.count
            var paddingLenght: Int = 0
            // Add padding
            if windowLenght < ProjectConstants.windowSize {
                paddingLenght = ProjectConstants.windowSize - window.count
                let paddingArray = Array(repeating: data.padTokenID, count: paddingLenght)
                window.append(contentsOf: paddingArray)
            }
            // Create masking
            var mask: [Int] = []
            mask.reserveCapacity(ProjectConstants.windowSize)
            mask.append(contentsOf: Array(repeating: 1, count: windowLenght))
            mask.append(contentsOf: Array(repeating: 0, count: paddingLenght))

            windows.append(TokenWindow(tokenIdentifiers: window, attentionMask: mask))
        }

        return windows
    }


    private func createWindow(_ window: inout [Int], index: Int, tokens: [Int]){
        let lowerBound = index * stride
        let upperBound = min(lowerBound + contentWindowSize,tokens.count)
        window.append(contentsOf: tokens[lowerBound..<upperBound])
    }

    private func windowsNeeded(tokenCount: Int) -> Int {
        // If there aren't enough tokens, we create a single window
        guard tokenCount > contentWindowSize else { return 1 }

        let remainingTokens = tokenCount - contentWindowSize

        // We then calculate how many windows are needed
        let maxAmountOfWindows = ((remainingTokens + stride - 1) / stride) + 1

        return maxAmountOfWindows
    }
}
