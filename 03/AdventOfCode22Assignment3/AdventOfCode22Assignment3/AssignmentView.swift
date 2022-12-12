//
//  ContentView.swift
//  AdventOfCode22Assignment3
//
//  Created by David van Erkelens on 04/12/2022.
//

import SwiftUI

struct AssignmentView: View {

    @StateObject private var viewModel = AssignmentViewModel()

    var body: some View {
        VStack {
            Image(systemName: "highlighter")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Advent Of Code 2022 - Assignment 3")
            HStack {
                VStack {
                    Text("Input data:")
                    TextEditor(text: $viewModel.input)
                        .font(.system(size: 11).monospaced())
                }
                VStack {
                    Text("Output data:")
                    TextEditor(text: $viewModel.output)
                        .font(.system(size: 11).monospaced())
                    HStack {
                        Text("Result:")
                        TextField("", text: $viewModel.result)
                    }
                }
            }
            HStack {
                Button("Execute part 1") {
                    viewModel.executeAssignmentOne()
                }
                .padding()
                Button("Execute part 2") {
                    viewModel.executeAssignmentTwo()
                }
                .padding()
            }
                   }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentView()
    }
}
