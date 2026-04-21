//
//  StockCard.swift
//  Reno's Stock App
//
//  Created by Reno Raphael Yang on 17/04/26.
//
import SwiftUI
import Charts

func filterPriceHistory(priceHistory: [PriceHistory], timePeriod: TimePeriod) -> [PriceHistory] {
    switch timePeriod {
    case .w:
        return priceHistory.filter { $0.date >= Date().addingTimeInterval(-(60 * 60 * 24 * 7)) && $0.date <= now }
    case .m:
        return priceHistory.filter {
            $0.date >= Date().addingTimeInterval(-(60 * 60 * 24 * 30)) && $0.date <= now
        }
    }
}

struct StockCard: View {
    var stock: Stock
    var timePeriod: TimePeriod
    
    var sortedPriceHistory: [PriceHistory] {
        filterPriceHistory(priceHistory: stock.priceHistory, timePeriod: timePeriod).sorted { $0.date < $1.date}
    }
    
    var change : Double {
        guard let first = sortedPriceHistory.first, let last = sortedPriceHistory.last else { return 0 }
        return last.price - first.price
    }
    
    var statusColor : Color {
        if change == 0 { return .gray }
        switch(change.sign) {
        case .plus:
            return .green
        case .minus:
            return .red
        }
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.symbol)
                    .font(.title2.bold())
                    .lineLimit(1)
                Text(stock.name)
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }.frame(width: 100, alignment: .leading)
            Spacer()
            //chart
            Chart {
                ForEach(sortedPriceHistory, id: \.date) { item in
                    AreaMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(
                            LinearGradient(gradient: .init(colors: [statusColor.opacity(0.5), .clear]), startPoint: .top, endPoint:
                                    .bottom)
                        )
                    LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(statusColor)
                    RuleMark(
                        y: .value("Threshold", 200)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2, dash : [10,5]))
                    .foregroundStyle(statusColor)
                }
            }
            .frame(width: 100, height: 50)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(sortedPriceHistory.first?.price ?? 0, specifier: "%.2f")")
                Badge(color: statusColor, value: change.formatted(
                    .number.precision(.fractionLength(2))
                ))
            }
        }
        
    }
}


#Preview {
    StockCard(stock: defaultStocks[0], timePeriod: .w)
}
