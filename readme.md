# DidYouReallyWriteIt

A local-first AI text detector built in **Swift** and **MLX**.

This is an experimental machine-learning project for identifying AI-like patterns in written text. The goal is to build and train our own detector rather than rely on third-party detection APIs.

The project focuses on:

- Low false-positive rates
- Calibrated uncertainty
- Robust evaluation across different models and writing styles
- Local and private inference
- Reproducible training and evaluation

## Tech Stack

- Swift
- MLX Swift
- Swift Package Manager
- Apple silicon

## Philosophy

AI-text detection is inherently uncertain. A detector score should be treated as a signal, not as proof of authorship.

When the evidence is weak, the system should prefer uncertainty over false confidence.

## License

MIT

