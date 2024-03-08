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
    @State private var calculationForDouble = 0.0
    @State private var calculationForInt = 0
    @State private var isClicked: String? = nil // for the button to change color
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
                                        let isOperator = ["+", "-", "x", "÷"].contains(char) // check if the clicked button is any of these characters
                                        Button(char, action: {
                                            isSecondNum = true
                                            operationCalc(char)
                                            isClicked = char // change isClicked to these characters
                                        })
                                            .frame(width: 80, height: 80)
                                            .background(isClicked == char && isOperator ? Color.white : Color.orange) // if the isClicked is these characters and in the isOperator, change background to white, else orange
                                            .cornerRadius(100)
                                            .foregroundColor(isClicked == char && isOperator ? .orange : .white) // if the isClicked is these characters and in the isOperator, change background to orange, else white
                                            .font(.system(size: 35))
                                    } else if char == "AC" || char == "+/-" || char == "%" {
                                        Button(char, action: {
                                            functionality(operation: char)
                                            isClicked = nil})
                                            .frame(width: 80, height: 80)
                                            .background(Color(UIColor.lightGray))
                                            .cornerRadius(100)
                                            .foregroundColor(.black)
                                            .font(.system(size: 35))
                                    } else if char == "0" {
                                        Button(char, action: {
                                            showNumber(value: char)
                                            isClicked = nil
                                        })
                                            .padding(.leading, 30)
                                            .frame(width: 170, height: 80, alignment: .leading)
                                            .background(Color(UIColor.darkGray))
                                            .cornerRadius(100)
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                    } else {
                                        Button(char, action: {
                                            showNumber(value: char)
                                            isClicked = nil
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
            if isFirstDigit2 { // if it is the first digit for the 2nd number
                result = value // result is the first digit
            } else { // else result append to the other value
                result += value
            }
            secondNum = result
            isFirstDigit2 = false
        } else { // else keep adding to the firstNum
            result += value
            firstNum = result
            print(firstNum)
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
        if firstNum.contains(".") || secondNum.contains("."){
            guard let firstNumDouble = Double(firstNum), let secondNumDouble = Double(secondNum) else {
                // Handle the case where conversion fails
                print("Invalid input for calculation double")
                return
            }
            switch operation {
            case "+":
                calculationForDouble = firstNumDouble + secondNumDouble
            case "-":
                calculationForDouble = firstNumDouble - secondNumDouble
            case "x":
                calculationForDouble = firstNumDouble * secondNumDouble
            case "÷":
                if secondNumDouble != 0 {
                    calculationForDouble = firstNumDouble / secondNumDouble
                } else {
                    result = "Error"
                    return
                }
            default:
                print("Unexpected")
                return
            }
            print(result)
            result = String(calculationForDouble)
        } else {
            guard let firstNumInt = Int(firstNum), let secondNumInt = Int(secondNum) else {
                // Handle the case where conversion fails
                print("Invalid input for calculation int")
                return
            }
            switch operation {
            case "+":
                calculationForInt = firstNumInt + secondNumInt
            case "-":
                calculationForInt = firstNumInt - secondNumInt
            case "x":
                calculationForInt = firstNumInt * secondNumInt
            case "÷":
                if secondNumInt != 0 {
                    calculationForInt = firstNumInt / secondNumInt
                } else {
                    result = "Error"
                    return
                }
                
            default:
                print("Unexpected")
                return
            }
            result = String(calculationForInt)
            print(result)
        }
        print(firstNum)
        print(secondNum)
        isSecondNum = true
        firstNum = result
        secondNum = ""
        isFirstDigit2 = true
    }
    func functionality(operation: String) {
        switch operation {
            case "AC":
                isSecondNum = false
                result = "0"
                firstNum = ""
                secondNum = ""
                calculationForInt = 0
                calculationForDouble = 0.0
                isFirstDigit = true
                isFirstDigit2 = true
            case "+/-":
                if result.first == "-" {
                    result.removeFirst()
                } else {
                    result.insert("-", at: result.startIndex)
                }
            case "%":
                if let num = Double(result){
                    result = String(num / 100)
                }
            default:
                print("Error")
        }
    }
}
#Preview {
    ContentView()
}
