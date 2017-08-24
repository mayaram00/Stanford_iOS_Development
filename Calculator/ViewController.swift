//
//  ViewController.swift
//  Calculator
//
//  Created by Maya Ram on 7/22/17.
//  Copyright © 2017 Maya Ram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //implicitly unwrapped optional: !
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
    }
    
    //computed value
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            //value on right hand side of equals
            display.text = String(newValue)
        }
    }
    
    //controller -> model
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        //if you can unwrap the optional
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
}

