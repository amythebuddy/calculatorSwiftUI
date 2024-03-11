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
    @State private var isDecimal = false
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    Text(String(result))
                        .foregroundColor(.white)
                        .font(.system(size: result.count > 8 ? 60 : 72)) // if result has more than 8 digits, decrease the size from 75 to 68
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
                                    } else if char == "AC" || char == "C" || char == "+/-" || char == "%" {
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
        if result.count > 10 { // if result has more than 8 digits
            result = String(result.prefix(10)) //only contains the first 8 digits
        }
        if isFirstDigit { // if it's first digit, change the 0
            if value == "." && firstNum.contains("."){ //only allow 1 decimal point
                return
            }
            if value == "." { // if the user press the . first, then keep the 0 and add decimal
                result += "."
            } else {
                result = value
            }
        } else if isSecondNum { // else if after the user click the operation, the secondNum will activate
            if isFirstDigit2 { // if it is the first digit for the 2nd number
                if value == "." && secondNum.contains(".") { // only allow 1 decimal point
                    // Ignore subsequent decimal points
                    return
                }
                if value == "." { // if the user press the . first, then add 0 and decimal
                    result = "0."
                } else {
                    result = value
                } // result is the first digit
            } else { // else result append to the other value
                if value == "." && secondNum.contains(".") { // only allow 1 decimal point
                    // Ignore subsequent decimal points
                    return
                }
                result += value
            }
            secondNum = result // assign result to the second number
            isFirstDigit2 = false
        } else { // else keep adding to the firstNum
            if value == "." && firstNum.contains(".") { // only allow 1 decimal point
                // Ignore subsequent decimal points
                return
            }
            result += value
            firstNum = result // assign result to firstNum
        }
        isFirstDigit = false
        
        // Insert commas for every three digits
        if let formattedNumber = formatNumber(result) {
            result = formattedNumber
        }
        // Check if the user has entered a digit and update "AC" to "C"
        if !result.isEmpty && result != "0" {
            numsAndOperations[0][0] = "C"
        }
    }
    
    // a function to add comma
    func formatNumber(_ numberString: String) -> String? {
        var formattedNumber = ""
        var count = 0
        
        for char in numberString.reversed() { // for each character
            if char == "."{
                isDecimal = true
            }
            if char != "," { // if character is not a comma
                if count != 0 && count % 3 == 0 && !isDecimal{ // if count is not 0 to not add comma to the first digit and count is divisible by 3
                    formattedNumber.insert(",", at: formattedNumber.startIndex) // add a comma
                    print(formattedNumber)
                }
                formattedNumber.insert(char, at: formattedNumber.startIndex)
                count += 1 // add 1 to count for each digit
                print(formattedNumber)
            }
        }
        return String(formattedNumber)
    }
    func operationCalc(_ char: String) {
      switch char {
          case "+", "-", "x", "÷":
              operation = char // assign operation with +, -, x, ÷
              firstNum = result.replacingOccurrences(of: ",", with: "") // eliminate the commas for calculation
          default: // for = button
              secondNum = result.replacingOccurrences(of: ",", with: "") // eliminate the commas for calculation
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
            // Insert commas for every three digits
            if let formattedNumber = formatNumber(String(calculationForDouble)) {
                result = formattedNumber
            }
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
                    calculationForDouble = Double(firstNumInt) / Double(secondNumInt)
                    if let formattedNumber = formatNumber(String(calculationForDouble)) {
                        result = formattedNumber
                    }
                    isSecondNum = true
                    firstNum = result
                    secondNum = ""
                    isFirstDigit2 = true
                    return
                } else {
                    result = "Error"
                    return
                }
                
            default:
                print("Unexpected")
                return
            }
            if let formattedNumber = formatNumber(String(calculationForInt)) {
                result = formattedNumber
            }
        }
        isSecondNum = true
        firstNum = result
        secondNum = ""
        isFirstDigit2 = true
    }
    func functionality(operation: String) {
        switch operation {
            case "AC", "C": // reset everything back
                isSecondNum = false
                isDecimal = false
                result = "0"
                firstNum = ""
                secondNum = ""
                calculationForInt = 0
                calculationForDouble = 0.0
                isFirstDigit = true
                isFirstDigit2 = true
                numsAndOperations[0][0] = "AC" // clicking C, change it back to AC
            case "+/-":
                if result.first == "-" { // if result already had the - then remove it
                    result.removeFirst()
                } else { // else add the - to the beginning
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
