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
    @State private var number = 0
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    Text("\(number)")
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
                                        Button(char, action: {})
                                            .frame(width: 80, height: 80)
                                            .background(Color.orange)
                                            .cornerRadius(100)
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                            .fontWeight(.bold)
                                    } else if char == "AC" || char == "+/-" || char == "%" {
                                        Button(char, action: {})
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
                                            showNumber(value: Int(char) ?? 0)
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
    func showNumber(value : Int){
        if value.isNaN {
            number = number * 10 + value
        } else {
            number = 0
        }
    }
}
#Preview {
    ContentView()
}
