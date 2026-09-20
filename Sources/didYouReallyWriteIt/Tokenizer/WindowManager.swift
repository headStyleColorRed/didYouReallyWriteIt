//
//  DYRWIWindowManager.swift
//  didYouReallyWriteIt
//
//  Created by Rodrigo Labrador Serrano on 19/09/2026.
//

import Foundation

struct WindowManager {
    // We calculate the stride based on the windoSize to overlap relation
    private var stride: Int {
        return Int(Float(ProjectConstants.windowSize) * ProjectConstants.overlap)
    }

    // We need to return an array of arrays that have at maximum
    // the stride length
    func createWindows(data: TokenizationData) -> [[Int]] {
        let tokenIdentifiers = data.tokens
        let tokenCount = tokenIdentifiers.count
        let windowsToCreate = windowsNeeded(tokenCount: tokenCount)
        var windowArray: [ArraySlice<Int>] = []

        for windowIndex in 0..<windowsToCreate {
            let lowerBound = windowIndex * stride
            let upperBound = min(lowerBound + ProjectConstants.windowSize,
                                 tokenIdentifiers.count)
            let window = tokenIdentifiers[lowerBound..<upperBound]
            windowArray.append(window)
        }

        let windowArrayWithDelimeterTokens = addSpecialTokens(windowArray.map({ Array($0) }), data)
        return windowArrayWithDelimeterTokens
    }


    private func addSpecialTokens(_ windowArray: [[Int]], _ data: TokenizationData) -> [[Int]] {
        return windowArray.map({ [data.bosTokenID] + $0 + [data.eosTokenID] })
    }

    private func windowsNeeded(tokenCount: Int) -> Int {
        // If there aren't enough tokens, we create a single windoow
        guard tokenCount > ProjectConstants.windowSize else { return 1 }

        let remainingTokens = tokenCount - ProjectConstants.windowSize

        // We then calculate how many windows are needed
        let maxAmountOfWindows = ((remainingTokens + stride - 1) / stride) + 1

        return maxAmountOfWindows
    }
}
