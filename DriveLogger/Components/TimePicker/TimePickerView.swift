//
//  TimePickerView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/29/23.
//  Inspiration: https://digitalbunker.dev/recreating-the-ios-timer-in-swiftui/
//

import SwiftUI


struct TimePickerView: View {
    let title: String
    let range: ClosedRange<Int>
    let selection: Binding<Int>
    
    var body: some View {
        HStack(spacing: -4.0) {
            Picker(title, selection: selection) {
                ForEach(range, id: \.self) { timeIncrement in
                    HStack {
                        Spacer()
                        Text("\(timeIncrement)")
                    }
                }
            }
            .pickerStyle(.wheel)
            
            Text(title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    HStack {
        TimePickerView(title:"Hours", range:0...23, selection: .constant(0))
        TimePickerView(title:"Min", range:0...59, selection: .constant(0))
        TimePickerView(title:"Sec", range:0...59, selection: .constant(0))
    }
}
