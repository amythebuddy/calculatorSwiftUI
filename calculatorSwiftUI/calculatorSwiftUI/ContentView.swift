//
//  ContentView.swift
//  calculatorSwiftUI
//
//  Created by StudentAM on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var numsAndOperations: [[String]] = [
            ["AC","+/-", "%", "÷"],
            ["7","8", "9", "x"],
            ["4","5", "6", "-"],
            ["1","2", "3", "+"],
            ["0", "." , "="]
        ]
    @State private var result = "0"
    @State private var operation = ""
    @State private var calculation = 0
    @State private var firstNum = ""
    @State private var secondNum = ""
    @State private var isFirstDigit = true
    @State private var isFirstDigit2 = true
    @State private var isSecondNum = false
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    Text(String(result))
                        .foregroundColor(.white)
                        .font(.system(size: 70))
                        .fontWeight(.light)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineLimit(1)
                    
                        ForEach(numsAndOperations, id: \.self) { row in
                            HStack {
                                ForEach(row, id: \.self) { char in
                                    if char == "=" || char == "+" || char == "-" || char == "x" || char == "÷" {
                                        Button(char, action: {
                                            isSecondNum = true
                                            operationCalc(char)
                                        })
                                            .frame(width: 80, height: 80)
                                            .background(Color.orange)
                                            .cornerRadius(100)
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                    } else if char == "AC" || char == "+/-" || char == "%" {
                                        Button(char, action: {functionality(operation: char)})
                                            .frame(width: 80, height: 80)
                                            .background(Color(UIColor.lightGray))
                                            .cornerRadius(100)
                                            .foregroundColor(.black)
                                            .font(.system(size: 35))
                                    } else if char == "0" {
                                        Button(char, action: {})
                                            .padding(.leading, 30)
                                            .frame(width: 170, height: 80, alignment: .leading)
                                            .background(Color(UIColor.darkGray))
                                            .cornerRadius(100)
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                    } else {
                                        Button(char, action: {
                                            showNumber(value: char)
                                        })
                                            .frame(width: 80, height: 80)
                                            .background(Color(UIColor.darkGray))
                                            .cornerRadius(100)
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                    }
                                }
                            }
                        }
                }
        )
    }
    func showNumber(value: String) {
        if isFirstDigit { // if it's first digit, change the 0
            result = value
        } else if isSecondNum { // else if after the user click the operation, the secondNum will activate
            if isFirstDigit2 {
                result = value
            } else {
                result += value
            }
            secondNum = result
            isFirstDigit2 = false
        } else { // else keep adding to the firstNum
            result += value
            firstNum = result
        }
        isFirstDigit = false
    }
    func operationCalc(_ char: String) {
            switch char {
            case "+", "-", "x", "÷":
                operation = char
                firstNum = result
            default:
                secondNum = result
                calculate()
            }
        }
    func calculate() {
        if result.contains("."){
            
        } else {
            guard let firstNumValue = Int(firstNum), let secondNumValue = Int(secondNum) else {
                // Handle the case where conversion fails
                print("Invalid input for calculation")
                return
            }
            print(firstNumValue)
            print(secondNumValue)
            switch operation {
            case "+":
                calculation = firstNumValue + secondNumValue
                print(calculation)
            case "-":
                calculation = firstNumValue - secondNumValue
            case "x":
                calculation = firstNumValue * secondNumValue
            case "÷":
                if  secondNumValue != 0 {
                    calculation = firstNumValue / secondNumValue
                } else {
                    result = "Error"
                }
            case "=":
                result = String(calculation)
                print(result)
                firstNum = ""
                secondNum = ""
                isSecondNum = false
                isFirstDigit = true
                isFirstDigit2 = true
            default:
                print("error")
            }
        }
    }
    func functionality(operation: String) {
        switch operation {
            case "AC":
                isSecondNum = false
                result = "0"
                firstNum = ""
                secondNum = ""
                calculation = 0
                isFirstDigit = true
                isFirstDigit2 = true
            case "%":
                result = "0"
            default:
                print("Error")
        }
    }
}
#Preview {
    ContentView()
}
