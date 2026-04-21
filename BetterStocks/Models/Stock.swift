//
//  Stock.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 20/04/26.
//

import SwiftUI

let day: Double = 86400

enum TimePeriod : String, CaseIterable {
//    case h = "H"
//    case d = "D"
    case w = "W"
    case m = "M"
}

struct InformationDetail {
    var open: Double
    var low : Double
    var high: Double
    var volume: Int
    var priceToEarningsRatio: Double?
    var marketCap: Double?
    var weekLow52: Double?
    var weekHigh52: Double?
    var averageVolume: Double?
}


enum TimePeriodDetail : String, CaseIterable {
//    case d1 = "1d"
    case w1 = "1w"
    case m1 = "1m"
    case m3 = "3m"
}



// Model for our stock app
struct Stock: Identifiable {
    // we give id, so we can do a ForEach without specifying an Id column
    let id = UUID()
    
    var currency: String?
    var composite: String?
    
    var symbol: String
    var name: String
    
    // an array of the stock prices
    var priceHistory: [PriceHistory]
    
    
    var informationDetail: InformationDetail?
    
    var sortedPriceHistory: [PriceHistory] {
        priceHistory.sorted { firstElement, secondElement in
            return firstElement.date < secondElement.date
        }
    }

    // function to determine whether the price is going up, down or neutral
    func calculateStatus() -> StockPriceStatus{
        if(priceHistory.count < 2) {
            return .neutral
        }
        if (lastPriceHistory() > priceHistory[0].price) {
            return .positive
        }
        
        return .negative
        
    }
    
    // computed property to safely get the change
    var change : Double {
        return lastPriceHistory() - (priceHistory[0].price)
    }
    
    // safely getting the last element of the array
    func lastPriceHistory() -> Double {
        return priceHistory.last?.price ?? 0.0
    }

    
    func statusColor() -> Color {
        switch calculateStatus() {
        case .positive:
                .green
        case .negative:
                .red
        default:
                .gray
        }
    }
}

func generatePriceHistory(days: Int, basePrice: Double, volatility: Double) -> [PriceHistory] {
    var history: [PriceHistory] = []
    var currentPrice = basePrice
    
    for i in stride(from: -days, through: 0, by: 1) {
        // Random price movement
        let change = Double.random(in: -volatility...volatility)
        currentPrice = max(1, currentPrice + change) // prevent negative price
        
        history.append(
            PriceHistory(
                date: Date().addingTimeInterval(day * Double(i)),
                price: (currentPrice * 100).rounded() / 100 // 2 decimal places
            )
        )
    }
    
    return history
}

var defaultStocks = [
    Stock(
        currency: "USD",
        composite: "NASDAQ",
        symbol: "AAPL",
        name: "Apple Inc.",
        priceHistory: generatePriceHistory(days: 90, basePrice: 200, volatility: 100),
        informationDetail: InformationDetail(open: 210, low: 120, high: 320, volume: 1200000)
    ),
    Stock(
        currency: "USD",
        composite: "NASDAQ",
        symbol: "MSFT",
        name: "Microsoft Inc.",
        priceHistory: generatePriceHistory(days: 90, basePrice: 200, volatility: 100),
        informationDetail: InformationDetail(open: 250, low: 180, high: 350, volume: 980000)
    ),
    Stock(
        currency: "USD",
        composite: "NYSE",
        symbol: "BA",
        name: "The Boeing Company",
        priceHistory: generatePriceHistory(days: 90, basePrice: 200, volatility: 100),
        informationDetail: InformationDetail(open: 190, low: 110, high: 280, volume: 1500000)
    ),
    Stock(
        currency: "USD",
        composite: "NYSE",
        symbol: "HD",
        name: "The Home Depot, Inc.",
        priceHistory: generatePriceHistory(days: 90, basePrice: 200, volatility: 100),
        informationDetail: InformationDetail(open: 300, low: 220, high: 370, volume: 870000)
    ),
    Stock(
        currency: "USD",
        composite: "NYSE",
        symbol: "GE",
        name: "GE Aerospace, Inc.",
        priceHistory: generatePriceHistory(days: 90, basePrice: 200, volatility: 100),
        informationDetail: InformationDetail(open: 140, low: 90, high: 210, volume: 2000000)
    ),
    Stock(
        currency: "IDR",
        composite: "IDX",
        symbol: "ABUI",
        name: "Abui Jaya Inc.",
        priceHistory: generatePriceHistory(days: 90, basePrice: 600, volatility: 10),
        informationDetail: InformationDetail(open: 610, low: 580, high: 660, volume: 450000)
    ),
    Stock(
        currency: "USD",
        composite: "NYSE",
        symbol: "RENO",
        name: "Reno Energy Inc.",
        priceHistory: generatePriceHistory(days: 90, basePrice: 200, volatility: 100),
        informationDetail: InformationDetail(open: 220, low: 130, high: 310, volume: 1100000)
    ),
]
