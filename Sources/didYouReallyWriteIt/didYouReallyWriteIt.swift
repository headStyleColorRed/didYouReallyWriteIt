import MLX
import MLXNN
import Foundation
import MLXOptimizers

class SimpleRegressionModel: Module {
    @ParameterInfo var parameter: MLXArray

    override init() {
        _parameter.wrappedValue = MLXArray(3.0)
        super.init()
    }

    var url: URL {
        URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent("model.safetensors")
    }

    func callAsFunction(_ input: MLXArray) -> MLXArray {
        return parameter * input
    }

    func recoverParameters() {
        do {
            let parameters = try loadArrays(url: url)
            update(parameters: ModuleParameters.unflattened(parameters))
        } catch {
            print(error.localizedDescription)
        }
    }
}

@main
struct DidYouReallyWriteIt {
    static func main() {
        // Declare variables
        let model = SimpleRegressionModel()
        model.recoverParameters()

        print("Model loaded parameter: ", model.parameter.item(Float.self))

        let inputValue = MLXArray(2.0)
        let targetValue = MLXArray(10.0)
        let learningRate: Float = 0.001

        // Implement loss method
        func lossMethod(model: SimpleRegressionModel, input: MLXArray, target: MLXArray) -> MLXArray {
            let prediction = model(input)
            let error = prediction - target
            return error * error
        }

        let lossAndGradientMethod = valueAndGrad(model: model, lossMethod)
        let optimizer = SGD(learningRate: learningRate)
        var (loss, _) = lossAndGradientMethod(model, inputValue, targetValue)

        // Update the model's parameter
        while loss.item(Float.self) > 0.001 {
            // Get loss and gradients
            let (loopLoss, loopGradient) = lossAndGradientMethod(model, inputValue, targetValue)

            guard loopLoss.item(Float.self) > 0.001 else { break }
            // Update parameter
            optimizer.update(model: model, gradients: loopGradient)
            // Update loss loop
            loss = loopLoss
        }

        // Save the paremeter
        let parameters = Dictionary(uniqueKeysWithValues: model.parameters().flattened())
        do {
            try save(arrays: parameters,
                     metadata: [:],
                     url: model.url)

            print("Saved model's parameters at \(model.url.absoluteString)")

        } catch {
            print(error.localizedDescription)
        }
    }
}
