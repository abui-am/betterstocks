//
//  HoldingCard.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 20/04/26.
//

import SwiftUI


public struct HoldingCard: View {
    var holding: Holding
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(holding.symbol)
                    .font(.title2.bold())
                    .lineLimit(1)
                Text(holding.name)
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }.frame(width: 100, alignment: .leading)
            Spacer()
            //chart
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(holding.currentPrice, specifier: "%.2f")")
                Badge(color: holding.statusColor, value: String(format: "%.2f%%", holding.changePercentage))
            }
            .frame(width : 100, alignment: .trailing)
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(holding.currentPrice, specifier: "%.2f")")
                Text("\(holding.shares) shares")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            .frame(width : 100, alignment: .trailing)
            
        }
        
    }
}

public struct HoldingCardTitle: View {
    public var body: some View {
        HStack {
            Text("Asset").frame(width: 100, alignment: .leading)
                .foregroundStyle(.gray)
            Spacer()
            //chart
            Text("Price")
                .frame(width : 100, alignment: .trailing)
                .foregroundStyle(.gray)
            
            Text("Holdings")
                .frame(width : 100, alignment: .trailing)
                .foregroundStyle(.gray)
            
        }
        
    }
}

#Preview {
    HoldingCardTitle(
    )
    HoldingCard(
        holding: mockHoldings.first!
    )
}
