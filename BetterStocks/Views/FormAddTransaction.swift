//
//  FormAddTransaction.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 22/04/26.
//

import SwiftUI




struct FormAddTransaction: View {
    @State private var stockSymbol: String?
    
   
    
    var currentHolding: Holding?  {
       return mockHoldings.first { $0.symbol == stockSymbol }
    }
    
    private var stock: Stock? { return defaultStocks.first {
        $0.symbol == stockSymbol
    }
    }
    
    var onSubmit: (_ holding: Holding) -> Void
    func findClosestPrice(for date: Date) -> Double {
        guard !(stock?.priceHistory.isEmpty ?? true) else { return 0 }
        
        let closest = stock?.priceHistory.min(by: {
            abs($0.date.timeIntervalSince(date)) <
            abs($1.date.timeIntervalSince(date))
        })
        
        return closest?.price ?? 0
    }
    @State private var selectedDate: Date = Date()
    @State private var shares: String = ""
    
    // computed price based on selected date
    var selectedPrice: Double {
        findClosestPrice(for: selectedDate)
    }
    
    var minDate: Date { stock?.sortedPriceHistory.first?.date ?? Date()
    }
    var maxDate: Date { stock?.sortedPriceHistory.last?.date ?? Date()
    }

    
    var body: some View {
        Form {
            Section(header: Text("Transaction")) {
                Picker("Stock", selection: $stockSymbol ) {
                    ForEach(defaultStocks, id: \.id) {   option in
                        Text(option.name).tag(option.symbol)
                    }
                }
                DatePicker("Transaction Date", selection: $selectedDate, in:
                            minDate...maxDate
                    , displayedComponents: .date
                )
                TextField("Number of shares", text: $shares)
                    .keyboardType(.numberPad)
            }
            
    
            
            Section(header: Text("Price Info")) {
                Text("Price on selected date:")
                Text("\(selectedPrice, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.blue)
                
            }
            if let currentHolding = currentHolding {
                Section(header: Text("Current Holding")) {
                    Text("Avg purchase price: \(currentHolding.averagePurchasePrice, specifier: "%.2f")")
                    Text("Shares: \(currentHolding.shares)")
                }
            } else {
                Section(header: Text("Current Holding")) {
                    Text("No holding for this stock")
                }
                
                
            }
            Section {
                Button("Add Holding") {
                    guard let sharesInt = Int(shares)  else {
                        return
                    }
                    
                    guard let stock else { return }
                    
                    
                    let holding = Holding(
                        symbol: stock.symbol,
                        averagePurchasePrice: selectedPrice,
                        currentPrice: selectedPrice,
                        name: stock.name,
                        shares: sharesInt
                    )
                    
                    onSubmit(holding)
                }
                .disabled(Int(shares) == nil || selectedPrice == 0)
            }
        }
    }
}

#Preview {
    FormAddTransaction(
        onSubmit : { _ in }
    )
}
