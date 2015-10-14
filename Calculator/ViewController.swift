//
//  ViewController.swift
//  Calculator
//
//  Created by Gianluca Tomasino on 04/02/15.
//  Copyright (c) 2015 Gianluca Tomasino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false;
    var userHasPressedPeriod = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        addToHistory("\(sender.currentTitle!)\n")
        
        switch operation {
            case "×": performOperation { $0 * $1 }
            case "−": performOperation { $1 - $0 }
            case "+": performOperation { $0 + $1 }
            case "÷": performOperation { $1 / $0 }
            case "√": performOperation {sqrt($0)}
            case "sin" : performOperation {sin($0)}
            case "cos": performOperation {cos($0)}
            default: break
        }
    }
    
    @IBAction func pi() {
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        
        display.text = "3.14"
        enter()
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func period() {
        if !userHasPressedPeriod {
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + "."
            } else {
                display.text = "0."
            }
            userHasPressedPeriod = true
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        userHasPressedPeriod = false
        operandStack.append(displayValue)
        
        addToHistory("\(displayValue)\n")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    private func addToHistory(value: String) {
        history.text!.insertContentsOf(value.characters, at: history.text!.startIndex)
    }
}

