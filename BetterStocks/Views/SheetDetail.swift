//
//  SheetDetail.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 21/04/26.
//

import SwiftUI
import Charts

let calendar = Calendar.current
let now = Date()
struct SheetDetail: View {
    var stock : Stock
    
    @State var selectionTimePeriod  : TimePeriodDetail = .m1
    var exchangeCurrency: String {
        return "\(stock.composite ?? "") . \(stock.currency ?? "")"
    }
    
    // Filter by selection time period
    var displayedChartData: [PriceHistory] {
       switch selectionTimePeriod {
       case .w1:
               guard let startDate = calendar.date(byAdding: .day, value: -7, to: now) else {
                   return []
               }
               return stock.priceHistory.filter { $0.date >= startDate && $0.date <= now }

           case .m1:
               guard let startDate = calendar.date(byAdding: .month, value: -1, to: now) else {
                   return []
               }
               return stock.priceHistory.filter { $0.date >= startDate && $0.date <= now }

           case .m3:
               guard let startDate = calendar.date(byAdding: .month, value: -3, to: now) else {
                   return []
               }
               return stock.priceHistory.filter { $0.date >= startDate && $0.date <= now }
           }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                Text("\(stock.symbol)")
                    .font(Font.largeTitle.bold())
                Text(stock.name)
                    .font(Font.caption)
                    .opacity(0.5)
            }
            HStack {
                Text("\(stock.priceHistory.last?.price ?? 0.0, specifier: "%.2f")")
                    .font(Font.default.bold())
                Text("\(stock.change, specifier: "%.2f")")
                    .font(Font.caption)
                    .foregroundColor(stock.statusColor())
            }
            
            Text(exchangeCurrency).opacity(0.5)
            
            Picker("", selection: $selectionTimePeriod ) {
                ForEach(TimePeriodDetail.allCases, id: \.self) {   option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            
            VStack(alignment: .leading, spacing: 16) {
                
            Chart {
                ForEach(displayedChartData, id: \.date) { item in
                    AreaMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(
                            LinearGradient(gradient: .init(colors: [stock.statusColor().opacity(0.5), .clear]), startPoint: .top, endPoint:
                                    .bottom)
                        )
                    LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                        .foregroundStyle(stock.statusColor())
                        .foregroundStyle(stock.statusColor())
                }
            }
            .frame(height: 300)
            SheetDetailInformation(info: stock.informationDetail!)
                
            }
        }
        
    }
}

#Preview {
    SheetDetail(stock:defaultStocks[0])
}
