//
//  CalculatorButtons.swift
//  CalculatorSwiftUI
//
//  Created by Siarhei Bardouski on 5/10/20.
//  Copyright © 2020 Siarhei Bardouski. All rights reserved.
//

import UIKit

enum CalculatorButtons {
    
    case digit(Int)
    case decimal
    case operation(Operation)
    case command(Command)
    
    enum Operation: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
        case numberInExponentiation = "xª"
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
        case rootExtraction = "√x"
        case factorial = "X!"
        case tenInExponentiation = "10ª"
        case numberInTenExponentiation = "x10"
    }
}

extension CalculatorButtons: Hashable {
    
    var title: String {
        switch self {
        case .digit(let value): return String(value)
        case .decimal: return "."
        case .operation(let oper): return oper.rawValue
        case .command(let command): return command.rawValue
        }
    }
}
