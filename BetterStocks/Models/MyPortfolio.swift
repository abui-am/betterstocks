//
//  MyPortfolio.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 20/04/26.
//

import SwiftUI

struct Holding: Identifiable {
    var id = UUID()
    var symbol: String
    var averagePurchasePrice: Double
    var currentPrice: Double
    var name: String
    var shares: Int
    var netWorth: Double {
        return averagePurchasePrice * Double(shares)
    }
    var change: Double {
        return currentPrice - averagePurchasePrice
    }
    
    var statusColor: Color {
        return change < 0 ? .red : change == 0 ? .gray : .green
    }
    
    var changePercentage: Double {
        return (currentPrice - averagePurchasePrice) / averagePurchasePrice * 100
    }
}

struct HoldingHistory: Identifiable {
    var id = UUID()
    var date: Date
    var price: Double
}

struct MyPortfolio {
    var holdings : [Holding]
    var holdingHistories: [HoldingHistory]
    var netWorth: Double {
        holdings.reduce(0) { $0 + $1.netWorth }
    }
    var totalGain : Double {
        holdings.reduce(0) { $0 + $1.change * Double($1.shares) }
    }
    
    var totalGainPercentage: Double {
        (totalGain / netWorth) * 100
    }
    
    var statusColor : Color {
        totalGain < 0 ? .red : totalGain == 0 ? .gray : .green
    }
}


let today = Date()

var mockHistories: [HoldingHistory] = [
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -19, to: today)!, price: 0),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -18, to: today)!, price: 22),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -17, to: today)!, price: 61),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -16, to: today)!, price: 95),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -15, to: today)!, price: 50),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -14, to: today)!, price: 6),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -13, to: today)!, price: 90),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -12, to: today)!, price: 102),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -11, to: today)!, price: 151),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -10, to: today)!, price: 55),

    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -9, to: today)!, price: 157),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -8, to: today)!, price: 156),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -7, to: today)!, price: 120),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -6, to: today)!, price: 102),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -5, to: today)!, price: 91),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -4, to: today)!, price: 175),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -3, to: today)!, price: 167),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -2, to: today)!, price: 166),
    HoldingHistory(date: Calendar.current.date(byAdding: .day, value: -1, to: today)!, price: 170),
    HoldingHistory(date: today, price: 172)
]

var mockHoldings: [Holding] = [
    Holding(
        symbol: "AAPL",
        averagePurchasePrice: 150,
        currentPrice: 172, // match latest history
        name: "Apple Inc.",
        shares: 10
    ),
    Holding(
        symbol: "TSLA",
        averagePurchasePrice: 700,
        currentPrice: 760,
        name: "Tesla Inc.",
        shares: 5
    )
    ,
    Holding(
        symbol: "GOOGL",
        averagePurchasePrice: 2800,
        currentPrice: 2900,
        name: "Alphabet Inc.",
        shares: 2
    )
]

var mockPortfolio = MyPortfolio(
    holdings: mockHoldings,
    holdingHistories: mockHistories
)
