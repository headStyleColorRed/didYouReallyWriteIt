// The Swift Programming Language
// https://docs.swift.org/swift-book

import MLX

@main
struct DidYouReallyWriteIt {
    /// **Terms**
	/// parameter = where you are horizontally
	/// loss      = how high up the mountain you are
	/// gradient  = slope beneath your feet
	/// learning rate = size of your step
	/// gradient descent = repeatedly walking downhill
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

            print("Iteration:", iteration)
            print("Parameter:", parameter.item(Float.self))
            print("Gradient:", gradient.item(Float.self))
            print("Loss:", loss.item(Float.self))
            print("----------")
        }

        print(parameter)
    }
}
