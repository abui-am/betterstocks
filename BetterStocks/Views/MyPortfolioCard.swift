//
//  MyPortfolioCard.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 20/04/26.
//

import SwiftUI

struct Gain {
    
    var portfolio: MyPortfolio
    
    var dayGains : Double {
        return (portfolio.holdingHistories.first?.price ?? 0) - (portfolio.holdingHistories[1].price)
    }
    
    var dayGainsSign : String {
        return dayGains.sign == .plus ? "+" : ""
    }
    
    var dayGainStatusColor : Color {
        return dayGains.sign == .plus ? .green : .red
    }
    
    var totalGains : Double {
        return portfolio.totalGain
    }
    
    var totalGainsSign : String {
        return portfolio.totalGain.sign == .plus ? "+" : ""
    }
    
    var totalGainColor : Color {
        return portfolio.totalGain.sign == .plus ? .green : .red
    }
    
    var dayGainsPercentage : String {
        guard portfolio.holdingHistories.first?.price != 0 else { return "N/A" }
        guard portfolio.holdingHistories.count > 1 else { return "N/A" }
        return "\((((portfolio.holdingHistories.first?.price ?? 0) - (portfolio.holdingHistories[1].price)) / (portfolio.holdingHistories.first?.price ?? 0)) * 100))%"
    }
    
    var totalGainsPercentage : String {
        return portfolio.netWorth == 0 ? "N/A" : "\(Int((portfolio.totalGain / portfolio.netWorth) * 100))%"
    }
}

struct MyPortfolioCard : View {
    var myPortfolio: MyPortfolio = mockPortfolio

    var gains : Gain = Gain(portfolio: mockPortfolio)
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text("My portfolio")
                    .font(.title2)
                
                Text(myPortfolio.netWorth.formatted(.currency(code: "USD")))
                    
                    .font(Font.largeTitle.bold())
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack{
                    Text("Day Gains")
                        .opacity(0.6)
                        .font(.title2)
                    Spacer()
                    Text( "\(gains.dayGains.formatted(.currency(code: "USD")))")
                        .foregroundColor(gains.dayGainStatusColor)
                        .font(.title2)
                }
                HStack{
                    Text("Total Gains")
                        .opacity(0.6)
                        .font(.title2)
                    Spacer()
                    Text(gains.totalGainsSign + gains.totalGains.formatted(.currency(code: "USD")))
                        .foregroundColor(gains.totalGainColor)
                        .font(.title2)
                }
            }
        }
        .padding(20)
        .glassEffect(in: RoundedRectangle(cornerRadius: 34))

    }
}

#Preview {
        MyPortfolioCard()
}
