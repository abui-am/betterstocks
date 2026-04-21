//
//  PageMyPortfolio.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 20/04/26.
//
import SwiftUI
import Charts

struct PageMyPortfolio: View {
    
    var gains = Gain(portfolio: mockPortfolio)
    
    var dayGainPercentage: Double {
            return (mockPortfolio.holdingHistories.last!.price - mockPortfolio.holdingHistories.first!.price) / mockPortfolio.holdingHistories.first!.price
    }
    var body: some View {
        NavigationStack {
            List {
                Text(mockPortfolio.netWorth.formatted(.currency(code: "USD")))
                        .font(Font.largeTitle.bold())
                        .listRowSeparator(.hidden)
                    Chart {
                        ForEach(mockPortfolio.holdingHistories, id: \.date) { item in
                            AreaMark(x: .value("Date", item.date), y: .value("Price", item.price))
                                .foregroundStyle(
                                    LinearGradient(gradient: .init(colors: [mockPortfolio.statusColor.opacity(0.5), .clear]), startPoint: .top, endPoint:
                                            .bottom)
                                )
                            LineMark(x: .value("Date", item.date), y: .value("Price", item.price))
                                .foregroundStyle(mockPortfolio.statusColor)
                                .foregroundStyle(mockPortfolio.statusColor)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .frame(height: 300)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack{
                            Text("Day Gains").opacity(0.6)
                            
                            Spacer()
                            Text("\(gains.dayGains.formatted(.currency(code: "USD")))")
                                .foregroundColor(gains.dayGainStatusColor)
                            
                        }
                        HStack{
                            Text("Total Gains").opacity(0.6)
                            
                            Spacer()
                            Text("\(gains.totalGains.formatted(.currency(code: "USD")))")
                                .foregroundColor(gains.totalGainColor)
                        }
                    }
                    .listRowSeparator(.hidden)
                    VStack(alignment: .leading, spacing: 20) {
                        Menu {
                            Button("Holdings") {
                                
                            }
                            Button("Next list") {
                                
                            }
                        } label: {
                            HStack {
                                Text("My Symbols")
                                Button("", systemImage: "chevron.up.chevron.down") {
                                    
                                }
                                
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            
                        }
                        
                        HoldingCardTitle()
                        ForEach(mockPortfolio.holdings, id: \.id) { item in
                            HoldingCard(holding: item)
                        }
                        
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("My Portfolio")
                            .font(.title).fontWeight(.bold)
                        Text("14 April").font(.subheadline).foregroundStyle(
                            .secondary
                        )
                    }
                    .frame(width: 200, alignment: .leading)

                }
                .sharedBackgroundVisibility(.hidden)
            }
            
            .listStyle(.plain)

        }
        
    
        
    }
}

#Preview {
     PageMyPortfolio()
}
