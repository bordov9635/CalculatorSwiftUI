//
//  CalculatorActions.swift
//  CalculatorSwiftUI
//
//  Created by Siarhei Bardouski on 5/10/20.
//  Copyright © 2020 Siarhei Bardouski. All rights reserved.
//

import UIKit

enum CalculatorActions {
    case first(String)
    case firstOperation(first: String, oper: CalculatorButtons.Operation)
    case firstOperationSecond(first: String, oper: CalculatorButtons.Operation, second: String)
    case error

    @discardableResult
    func apply(item: CalculatorButtons) -> CalculatorActions {
        switch item {
        case .digit(let num):
            return apply(num: num)
        case .decimal:
            return applyDot()
        case .operation(let operation):
            return apply(oper: operation)
        case .command(let command):
            return apply(command: command)
        }
    }

    var output: String {
        let result: String
        switch self {
        case .first(let left): result = left
        case .firstOperation(let left, _): result = left
        case .firstOperationSecond(_, _, let right): result = right
        case .error: return "Error"
        }
        guard let value = Double(result) else {
            return "Error"
        }
        return formatter.string(from: value as NSNumber)!
    }

    private func apply(num: Int) -> CalculatorActions {
        switch self {
        case .first(let first):
            return .first(first.apply(num: num))
        case .firstOperation(let first, let oper):
            return .firstOperationSecond(first: first, oper: oper, second: "0".apply(num: num))
        case .firstOperationSecond(let first, let oper, let second):
            return .firstOperationSecond(first: first, oper: oper, second: second.apply(num: num))
        case .error:
            return .first("0".apply(num: num))
        }
    }

    private func applyDot() -> CalculatorActions {
        switch self {
        case .first(let first):
            return .first(first.applyDot())
        case .firstOperation(let first, let oper):
            return .firstOperationSecond(first: first, oper: oper, second: "0".applyDot())
        case .firstOperationSecond(let first, let oper, let second):
            return .firstOperationSecond(first: first, oper: oper, second: second.applyDot())
        case .error:
            return .first("0".applyDot())
        }
    }

    private func apply(oper: CalculatorButtons.Operation) -> CalculatorActions {
        switch self {
        case .first(let first):
            switch oper {
            case .plus, .minus, .multiply, .divide, .numberInExponentiation:
                return .firstOperation(first: first, oper: oper)
            case .equal:
                return self
            }
        case .firstOperation(let first, let currentOp):
            switch oper {
            case .plus, .minus, .multiply, .divide, .numberInExponentiation:
                return .firstOperation(first: first, oper: currentOp)
            case .equal:
                if let result = currentOp.calculate(f: first, s: first) {
                    return .firstOperation(first: result, oper: currentOp)
                } else {
                    return .error
                }
            }
        case .firstOperationSecond(let first, let currentOp, let second):
            switch oper {
            case .plus, .minus, .multiply, .divide, .numberInExponentiation:
                if let result = currentOp.calculate(f: first, s: second) {
                    return .firstOperation(first: result, oper: currentOp)
                } else {
                    return .error
                }
            case .equal:
                if let result = currentOp.calculate(f: first, s: second) {
                    return .first(result)
                } else {
                    return .error
                }

            }
        case .error:
            return self
        }
    }

    private func apply(command: CalculatorButtons.Command) -> CalculatorActions {
        switch command {
        case .clear:
            return .first("0")
        case .flip:
            switch self {
            case .first(let first):
                return .first(first.flipped())
            case .firstOperation(let first, let oper):
                return .firstOperationSecond(first: first, oper: oper, second: "-0")
            case .firstOperationSecond(first: let first, let oper, let second):
                return .firstOperationSecond(first: first, oper: oper, second: second.flipped())
            case .error:
                return .first("-0")
            }
        case .percent:
            switch self {
            case .first(let left):
                return .first(left.percentaged())
            case .firstOperation:
                return self
            case .firstOperationSecond(first: let left, let oper, let second):
                return .firstOperationSecond(first: left, oper: oper, second: second.percentaged())
            case .error:
                return .first("-0")
            }
        case .rootExtraction:
            switch self {
            case .first(let first):
                return .first(first.extracted())
            case .firstOperation(let first,let oper):
                return .firstOperation(first: first, oper: oper)
            case .firstOperationSecond(first: let first, oper: let oper, second: let second):
                return .firstOperationSecond(first: first, oper: oper, second: second.extracted())
            case .error:
                return .first("-0")
            }
        case .factorial:
            switch self {
            case .first(let first):
                return .first(first.factorialed())
            case .firstOperation(let first,let oper):
                return .firstOperation(first: first, oper: oper)
            case .firstOperationSecond(first: let left, oper: let oper, second: let second):
                return .firstOperationSecond(first: left, oper: oper, second: second.factorialed())
            case .error:
                return .first("-0")
            }
        case .tenInExponentiation:
            switch self {
            case .first(let first):
                return .first(first.tenExponented())
            case .firstOperation(let first,let oper):
                return .firstOperation(first: first, oper: oper)
            case .firstOperationSecond(first: let first, oper: let oper, second: let second):
                return .firstOperationSecond(first: first, oper: oper, second: second.tenExponented())
            case .error:
                return .first("-0")
            }
        case .numberInTenExponentiation:
            switch self {
            case .first(let first):
                return .first(first.numberExponented())
            case .firstOperation(let first,let oper):
                return .firstOperation(first: first, oper: oper)
            case .firstOperationSecond(first: let first, oper: let oper, second: let second):
                return .firstOperationSecond(first: first, oper: oper, second: second.numberExponented())
            case .error:
                return .first("-0")
            }
        }
    }
}

var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()

extension String {
    var containsDot: Bool {
        return contains(".")
    }

    var startWithNegative: Bool {
        return starts(with: "-")
    }

    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }

    func applyDot() -> String {
        return containsDot ? self : "\(self)."
    }

    func flipped() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }

    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
    
    func extracted() -> String {
        return String(sqrt(Double(self)!))
    }
    
    func factorialed() -> String {
        let number = Int(self)!
        var fact = 1
        let n = number + 1
        for i in 1..<n {
            fact = fact * i
        }
        return String(fact)
    }
    
    func tenExponented() -> String {
        let number = Int(self)!
        let result = pow(10, number)
        return String(describing: result)
    }
    
    func numberExponented() -> String {
        print(String(describing: pow(Decimal(Int(self)!), 10)))
        return String(describing: pow(Decimal(Int(self)!), 10))
        
    }
}

extension CalculatorButtons.Operation {
    func calculate(f: String, s: String) -> String? {

        guard let first = Double(f), let second = Double(s) else {
            return nil
        }

        let result: Double?
        switch self {
        case .plus: result = first + second
        case .minus: result = first - second
        case .multiply: result = first * second
        case .divide: result = second == 0 ? nil : first / second
        case .equal: fatalError()
        case .numberInExponentiation: result = pow(first, second)
        }
        return result.map { String($0) }
    }
}
