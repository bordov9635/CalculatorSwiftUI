//
//  ContentView.swift
//  CalculatorSwiftUI
//
//  Created by Siarhei Bardouski on 5/10/20.
//  Copyright © 2020 Siarhei Bardouski. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var model: CalculatorModel
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)
        VStack(spacing: 3) {
            HStack {
                Spacer()
                 Text(model.brain.output)
                               .font(.system(size: 64))
                               .foregroundColor(.white)
                               .lineLimit(3)
                    .padding(.trailing)
            }.padding()
           
            
            CalculatorButtonView()
                
        }.padding(.bottom)
        }
  }
}

struct CalculatorButtonView: View {
    
    @EnvironmentObject  var model: CalculatorModel
    
    let buttons: [[CalculatorButtons]] = [
        [.command(.clear), .command(.flip), .command(.percent), .operation(.divide), .operation(.numberInExponentiation)],
        [.digit(7), .digit(8), .digit(9), .operation(.multiply), .command(.tenInExponentiation)],
        [.digit(4), .digit(5), .digit(6), .operation(.minus), .command(.numberInTenExponentiation)],
        [.digit(1), .digit(2), .digit(3), .operation(.plus), .command(.factorial)],
        [.digit(0), .decimal, .operation(.equal), .command(.rootExtraction)],
    ]
    
    var body: some View {
        VStack(spacing: 3) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 3) {
                    ForEach(row, id:  \.self){ button in
                        CalculatorButton(button: button) {
                            self.model.apply(button)}
                   }
                }
            }
        }
    }
}

struct CalculatorButton: View {
    
    @EnvironmentObject  var model: CalculatorModel
    
    var button: CalculatorButtons
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(button.title)
                    .font(.system(size: 30))
                .frame(width: self.buttonWidth(button: button), height: (UIScreen.main.bounds.width - 5 * 3) / 5)
                    .foregroundColor(.white)
                .background(self.backgroundColor(button: button))
                
                .cornerRadius(self.buttonWidth(button: button))
            }
        }

private func backgroundColor(button: CalculatorButtons) -> Color {
    switch button {
    case .digit, .decimal:
        return Color(.darkGray)
    case .command, .operation(.numberInExponentiation):
        return Color(.lightGray)
    default:
        return .orange
    }
}
    
    private func buttonWidth(button: CalculatorButtons) -> CGFloat {
        if button == .digit(0)  {
            return (UIScreen.main.bounds.width - 4 * 3) / 4 * 1.6
        }
        
        return (UIScreen.main.bounds.width - 5 * 3) / 5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
