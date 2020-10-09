//
//  ViewController.swift
//  Assignment 2:  Calculator App - Part 2 - Basic Calculator Functions
//
//  Created by Masum Modi on 2020-09-30.
//  Copyright © 2020 Centennial College. All rights reserved.
//  Student Id: 301149321

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    
    var lastOperator: String = ""
    var currentNumber: Double = 0.0
    var previousNumber: Double = 0.0
    var isOperationRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Shared onClicked event for number buttons, clear, backSpace and +/-
    @IBAction func onNumberButtonClicked(_ sender: UIButton) {
        switch sender.titleLabel!.text! {
        case "C": //Clear button
            resultLabel.text! = ""
            inputLabel.text! = ""
            lastOperator = ""
            currentNumber = 0
            previousNumber = 0
            isOperationRunning = false
        case "<": //Backspace button
            resultLabel.text!.popLast()
            inputLabel.text!.popLast()
        case "+/-": //Plus minus button
            if resultLabel.text == "0" || resultLabel.text == "" {
                return
            }
            if !resultLabel.text!.contains("-") {
                resultLabel.text!.insert("-", at: resultLabel.text!.startIndex)
            } else {
                resultLabel.text!.remove(at: resultLabel.text!.startIndex)
            }
        case ".": //Point button
            if resultLabel.text!.isEmpty {
                resultLabel.text! = "0."
                inputLabel.text! += "0."
            } else if !(resultLabel.text?.contains("."))! {
                appendtext(sender)
                inputLabel.text! += sender.titleLabel!.text!
            }
        default: // onPress of any number
            if isOperationRunning {
                setText(sender)
                currentNumber = Double(resultLabel.text!)!
                isOperationRunning = false
            } else {
                if resultLabel.text=="0" {
                    setText(sender)
                } else {
                    appendtext(sender)
                }
                currentNumber = Double(resultLabel.text!)!
            }
            inputLabel.text! += sender.titleLabel!.text!
        }
    }
    
    //Shared onClicked event for operation buttons
    @IBAction func onOperatorButtonClicked(_ sender: UIButton) {
        if resultLabel.text != "" {
            if sender.titleLabel!.text == "=" {
                let result = performCalculation()
                resultLabel.text = result.removeZerosFromEnd()
            } else {
                previousNumber = performCalculation()
                setText(sender)
                lastOperator = sender.titleLabel!.text!
                isOperationRunning = true
                inputLabel.text! += sender.titleLabel!.text!
            }
        }
    }
    
    //Perform Math Operations
    func performCalculation() -> Double {
        var result: Double
        switch lastOperator {
         case "+":
            result = previousNumber + currentNumber
         case "-":
            result = previousNumber - currentNumber
         case "/":
            result = previousNumber / currentNumber
         case "x":
            result = previousNumber * currentNumber
         case "%":
            result = previousNumber.truncatingRemainder(dividingBy: currentNumber)
         default:
            result = Double(resultLabel.text!)!
        }
        print("previousNumber: \(previousNumber) \(lastOperator) currentNumber: \(currentNumber) = \(result)")
        return result
    }
    
    //Append the text in input label
    func appendtext(_ sender: UIButton) {
        resultLabel.text! += (sender.titleLabel?.text)!
    }
    
    //Set the text in input label
    func setText(_ sender: UIButton) {
        resultLabel.text! = (sender.titleLabel?.text)!
    }
    
}

//https://stackoverflow.com/questions/29560743/swift-remove-trailing-zeros-from-double
//Used this code from stackoverflow to remove trailing zero in decimal
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}

