//
//  SheetDetailInformation.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 21/04/26.
//
import SwiftUI

struct SheetDetailInformation: View  {
    var info : InformationDetail
    var body  : some View {
        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 16){
            VStack(spacing: 8)  {
                ListInfo(label: "Open", value: "\(info.open, default: "-")")
                ListInfo(label: "High", value : "\(info.high, default: "-")")
                ListInfo(label: "Low", value : "\(info.low, default: "-")")
            }
            Divider().frame(height: 80)
            VStack(spacing: 8) {
                ListInfo(label: "Vol", value: "\(info.volume)")
                ListInfo(label: "P/E", value : "\(info.priceToEarningsRatio, default: "-")")
                ListInfo(label: "Mkt Cap", value : "\(info.marketCap, default: "-")")
            }
            Divider().frame(height: 80)
            VStack(spacing: 8)  {
                ListInfo(label: "52W H", value: "\(info.weekLow52, default: "-")")
                ListInfo(label: "52W L", value : "\(info.weekLow52, default: "-")")
                ListInfo(label: "Avg Vol", value : "\(info.averageVolume, default: "-")")
            }
        }
       
            
        }
    }
}


struct ListInfo : View {
    var label : String = "Information"
    var value : String = "Value"
    var body: some View {
        HStack(spacing: 8){
                Text(label).opacity(0.6)
                Spacer()
                Text(value)
                    .font(Font.default.bold())
            }.frame(width: 150)
        }
}

#Preview {
    SheetDetailInformation(info: defaultStocks[0].informationDetail!)
}
