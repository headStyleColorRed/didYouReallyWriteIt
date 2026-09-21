import Testing
@testable import didYouReallyWriteIt

@Suite("Tokenizer and windowing golden tests")
struct TokenizerWindowingTests {
    private let bos = 0
    private let eos = 2
    private let pad = 1

    private func tokenData(count: Int) -> TokenizationData {
        TokenizationData(
            tokens: Array(10_000..<(10_000 + count)),
            bosTokenID: bos,
            eosTokenID: eos,
            padTokenID: pad
        )
    }

    @Test func normalizesNFCAndLineEndings() {
        let input = "e\u{301}\r\na\rb\nc"
        let normalized = Normalizer().normalize(input)

        // Compare scalars: Swift String equality also considers decomposed and
        // precomposed spellings of the same character equal.
        #expect(Array(normalized.unicodeScalars.map(\.value)) == [0xE9, 10, 97, 10, 98, 10, 99])
    }

    @Test func encodesDeterministicRoBERTaContentIDs() async throws {
        let tokenizer = try await DYRWITokenizer(tokenizer: ProjectConstants.tokenizer)
        let data = try tokenizer.encode(normalizedInput: "Who are you?")

        #expect(data.tokens == [12375, 32, 47, 116])
        #expect(data.bosTokenID == bos)
        #expect(data.eosTokenID == eos)
        #expect(data.padTokenID == pad)
    }

    @Test func keepsLiteralSpecialTokensInContent() async throws {
        let tokenizer = try await DYRWITokenizer(tokenizer: ProjectConstants.tokenizer)

        #expect(try tokenizer.encode(normalizedInput: "<s>").tokens == [bos])
        #expect(try tokenizer.encode(normalizedInput: "</s>").tokens == [eos])
        #expect(try tokenizer.encode(normalizedInput: "<s>Who are you?</s>").tokens
                == [bos, 12375, 32, 47, 116, eos])
    }

    @Test func uses512TokenWindows() {
        #expect(ProjectConstants.windowSize == 512)
    }

    @Test func countsWindowsAtContentBoundaries() {
        let cases: [(contentCount: Int, expectedWindows: Int)] = [
            (0, 1), (1, 1), (509, 1), (510, 1),
            (511, 2), (512, 2), (766, 2),
            (767, 3), (768, 3), (769, 3)
        ]

        for (contentCount, expectedWindows) in cases {
            let windows = WindowManager().createWindows(data: tokenData(count: contentCount))
            #expect(windows.count == expectedWindows, "Content token count: \(contentCount)")
        }
    }

    @Test func overlapsContentAndWrapsEveryWindow() throws {
        let data = tokenData(count: 768)
        let windows = WindowManager().createWindows(data: data)
        try #require(windows.count == 3)

        // Each window holds at most 510 content IDs. A 256-ID stride makes
        // windows 0 and 1 share IDs 256...509, and windows 1 and 2 share
        // IDs 512...765.
        let expectedContent = [
            Array(data.tokens[0..<510]),
            Array(data.tokens[256..<766]),
            Array(data.tokens[512..<768])
        ]

        for (index, window) in windows.enumerated() {
            let content = expectedContent[index]
            let realIDs = [bos] + content + [eos]
            let paddingCount = 512 - realIDs.count

            #expect(window.tokenIdentifiers == realIDs + Array(repeating: pad, count: paddingCount))
            #expect(window.tokenIdentifiers.count == 512)
            #expect(window.attentionMask == Array(repeating: 1, count: realIDs.count)
                    + Array(repeating: 0, count: paddingCount))
            #expect(window.attentionMask.count == 512)
        }
    }

    @Test func shortSingleWindowPadsWithRoBERTaPadAndMasksIt() async throws {
        let tokenizer = try await DYRWITokenizer(tokenizer: ProjectConstants.tokenizer)
        let data = try tokenizer.encode(normalizedInput: "Who are you?")
        let windows = WindowManager().createWindows(data: data)
        try #require(windows.count == 1)

        let window = windows[0]
        #expect(window.tokenIdentifiers == [bos, 12375, 32, 47, 116, eos]
                + Array(repeating: data.padTokenID, count: 506))
        #expect(window.tokenIdentifiers.count == 512)
        #expect(window.attentionMask == Array(repeating: 1, count: 6)
                + Array(repeating: 0, count: 506))
        #expect(window.attentionMask.count == 512)
    }

    @Test func literalPadTokenInContentIsStillAttended() throws {
        let data = TokenizationData(
            tokens: [pad],
            bosTokenID: bos,
            eosTokenID: eos,
            padTokenID: pad
        )
        let windows = WindowManager().createWindows(data: data)
        try #require(windows.count == 1)

        let window = windows[0]
        #expect(window.tokenIdentifiers == [bos, pad, eos]
                + Array(repeating: pad, count: 509))
        #expect(window.attentionMask == [1, 1, 1]
                + Array(repeating: 0, count: 509))
    }

    @Test func exactly510ContentTokensFillOneWindowWithoutPadding() throws {
        let data = tokenData(count: 510)
        let windows = WindowManager().createWindows(data: data)
        try #require(windows.count == 1)

        let window = windows[0]
        #expect(window.tokenIdentifiers == [bos] + data.tokens + [eos])
        #expect(window.tokenIdentifiers.count == 512)
        #expect(window.attentionMask == Array(repeating: 1, count: 512))
        #expect(window.attentionMask.count == 512)
    }
}
