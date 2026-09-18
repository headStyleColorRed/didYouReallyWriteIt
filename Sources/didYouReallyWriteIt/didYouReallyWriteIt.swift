import MLX

@main
struct DidYouReallyWriteIt {
    static func main() {
        let inputValue = MLXArray(2.0)
        let targetValue = MLXArray(10.0)
        var parameter = MLXArray(3.0)
        let learningRate: Float = 0.01

        let tolerance: Float = 0.001
        let maxIterations: Int = 5

        let lossMethod: (MLXArray) -> MLXArray = { parameter in
            let prediction = inputValue * parameter
            let error = prediction - targetValue
            let loss = error * error
            return loss
        }

        var loss: MLXArray = lossMethod(parameter)
        let gradientMethod = grad(lossMethod)

        var iteration: Int = 0
        while loss.item(Float.self) > tolerance && iteration < maxIterations {
            iteration += 1

            let gradient = gradientMethod(parameter)

            parameter = parameter - learningRate * gradient
            loss = lossMethod(parameter)
        }
    }
}
