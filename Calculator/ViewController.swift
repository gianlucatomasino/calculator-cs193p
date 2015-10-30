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
    var operandStack = Array<Double>()
    var brain = CalculatorBrain()
    
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
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        addToHistory("\(sender.currentTitle!)\n")
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                addToHistory("\(result)\n")
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func pi() {
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        
        display.text = "\(M_PI)"
        enter()
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
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        userHasPressedPeriod = false
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
            addToHistory("\(displayValue)\n")
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            formatter.paddingCharacter = ","
            formatter.decimalSeparator = "."
            return formatter.numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    private func addToHistory(value: String) {
        if let actual = history.text {
            history.text = value + actual
        } else {
            history.text = value
        }
    }
}

