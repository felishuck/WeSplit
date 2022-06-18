//
//  ContentView.swift
//  WeSplit
//
//  Created by Félix Tineo Ortega on 16/6/22.
//

import SwiftUI

struct ContentView: View {

    @FocusState private var isFocused: Bool
    @ObservedObject private var modelView = WeSplitModeView()
    
    var body: some View {
        NavigationView {
            Form{
                Section{
                    TextField("Amount to Split", value: $modelView.amount, format: .currency(code: Locale.current.currencyCode ?? "EUR"))
                        .focused($isFocused)
                        .keyboardType(.decimalPad)
                        .task {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isFocused = true
                            }
                        }

                    Picker("Number of People", selection: $modelView.numberOfPeople) {
                        ForEach(2..<100) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    
                }
                
                Section(header: Text("Select Tip Percentage")) {
                    Picker("Tip", selection: $modelView.currentPercentage) {
                        ForEach(modelView.percentages, id: \.self) { percentage in
                            Text(percentage, format: .percent)
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section(header: Text("Everyone has to pay")){
                    Text(modelView.resultingAmount, format: .currency(code: Locale.current.currencyCode ?? "EUR"))
                }
            }.navigationTitle("We Split")

        }.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done"){
                    doneButtonWasTapped()
                }
            }
        }
        }
    func doneButtonWasTapped(){
        isFocused = false
    }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class WeSplitModeView: ObservableObject{

    @Published var amount:Double = 0.0
    @Published var numberOfPeople: Int = 2
    var percentages:[Int] = [0, 10, 15, 20, 25]
    @Published var currentPercentage: Int = 10
    var resultingAmount: Double{
        splitBill()
    }
    
    func splitBill()->Double{
        (amount + (amount * Double(currentPercentage) / 100)) / Double(numberOfPeople)
    }
}
