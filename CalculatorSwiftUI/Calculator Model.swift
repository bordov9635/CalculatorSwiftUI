//
//  Calculator Model.swift
//  CalculatorSwiftUI
//
//  Created by Siarhei Bardouski on 5/10/20.
//  Copyright © 2020 Siarhei Bardouski. All rights reserved.
//

import Combine

class CalculatorModel: ObservableObject {
    
    @Published var brain: CalculatorActions = .first("0")
    
    func apply(_ item: CalculatorButtons) {
        brain = brain.apply(item: item)
    }
}
