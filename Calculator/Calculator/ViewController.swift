//
//  ViewController.swift
//  Calculator
//
//  Created by Derek Stengel on 1/26/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var calcNumberLabel: UILabel!
    var currentNumber: String = ""
    var previousNumber: String = ""
    var currentOperator: String = ""
    var isNegativeNumber: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calcNumberLabel.text = "0"
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        currentNumber = currentNumber.count == 1 ? "" : String(currentNumber.dropLast())
        calcNumberLabel.text = currentNumber.isEmpty ? "0" : currentNumber
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        if let number = sender.titleLabel?.text {
            if calcNumberLabel.text == "0" || calcNumberLabel.text == previousNumber {
                calcNumberLabel.text = ""
            }
            currentNumber.append(number)
            calcNumberLabel.text?.append(number)
        }
    }
    
    @IBAction func positiveNegativeButtonPressed(_ sender: UIButton) {
        isNegativeNumber.toggle()
        currentNumber = isNegativeNumber ? "-" + currentNumber : String(currentNumber.dropFirst())
        calcNumberLabel.text = currentNumber
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        currentNumber = ""
        previousNumber = ""
        calcNumberLabel.text = "0"
        currentOperator = ""
        isNegativeNumber = false
    }
    
    @IBAction func equalButtonPressed(_ sender: UIButton) {
        guard let mathResult = mathOperations() else { return }
        
        if mathResult.contains(".0") {
            currentNumber = mathResult.replacingOccurrences(of: ".0", with: "")
            calcNumberLabel.text = mathResult.replacingOccurrences(of: ".0", with: "")
        } else if currentNumber == "" {
            calcNumberLabel.text = "0"
        } else {
            calcNumberLabel.text = mathResult
            currentNumber = mathResult
        }
        previousNumber = ""
    }
    
    @IBAction func operatorButtonPressed(_ sender: UIButton) {
        equalButtonPressed(UIButton())
        currentOperator = sender.titleLabel?.text ?? ""
        previousNumber = currentNumber
        currentNumber = ""
        calcNumberLabel.text = previousNumber == "" ? "0" : previousNumber
    }
    
    @IBAction func percentageButtonPressed(_ sender: UIButton) {
        guard currentNumber.contains("0.") else {
            currentNumber = "0." + currentNumber
            calcNumberLabel.text = currentNumber
            return
        }
    }
    
    func mathOperations() -> String? {
        guard let currentNum = Double(currentNumber), let previousNum = Double(previousNumber) else { return nil }
        var numberResult: Double
        
        switch currentOperator {
        case "+": numberResult = currentNum + previousNum
        case "-": numberResult = previousNum - currentNum
        case "÷":
            if previousNum == 0 { return "Error" }
            else if currentNum == 0 { return "Error"}
            numberResult = previousNum / currentNum
        case "x": numberResult = currentNum * previousNum
        default: return "Error"
        }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 8
        return formatter.string(from: NSNumber(value: numberResult))
    }
}
