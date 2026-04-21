//
//  Label.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 20/04/26.
//

import SwiftUI

struct Badge: View {
    var color : Color
    var value : String
    var body : some View {
        Button {

        } label: {
            Text(value).foregroundStyle(.white)
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 4)

        }

        .frame(alignment: .trailing)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
        )

    }
}
