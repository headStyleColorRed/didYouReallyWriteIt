// The Swift Programming Language
// https://docs.swift.org/swift-book

//import MLX

@main
struct DidYouReallyWriteIt {
    /// **Terms**
	/// parameter = where you are horizontally
	/// loss      = how high up the mountain you are
	/// gradient  = slope beneath your feet
	/// learning rate = size of your step
	/// gradient descent = repeatedly walking downhill
    static func main() {
        let input: Float = 2
        var parameter: Float = 3
        let target: Float = 10
        let learningRate: Float = 0.1

        func powerOfTwo(value: Float) -> Float{
            return value * value
        }

        var loss: Float = 1000
        while loss != 0 {
            let modelPrediction = input * parameter

            loss = powerOfTwo(value: modelPrediction - target)

            // We get now the gradient using the derivative
            let gradient = 2 * (modelPrediction - target) * input

            // Now we correct
            parameter = parameter - learningRate * gradient

            print(parameter)
        }

    }
}
