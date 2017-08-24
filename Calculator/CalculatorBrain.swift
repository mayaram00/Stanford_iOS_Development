//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Maya Ram on 8/22/17.
//  Copyright © 2017 Maya Ram. All rights reserved.
//

//this is the model UI independent

import Foundation

//classes have inheritance, structs do not.
//structs != the heap, value types
//classes = heap, reference

struct CalculatorBrain {
    //no initializer; automatic
    
    //initialize accumulator to not-state, make it a ?
    private var accumulator: Double?
    
    private enum Operation {
        //associated value
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({-$0}),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "−": Operation.binaryOperation({$0 - $1}),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let bfunction):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: bfunction, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
                
            }
            
        }
        
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
        
    }
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        
    }
    
    //read only property
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
