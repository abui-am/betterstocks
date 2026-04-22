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
    var stock: Stock

    @State private var selectionTimePeriod: TimePeriodDetail = .m1
    @State private var selectedItem: PriceHistory? = nil

    var exchangeCurrency: String {
        "\(stock.composite ?? "") . \(stock.currency ?? "")"
    }

    var displayedChartData: [PriceHistory] {
        let sorted = stock.priceHistory.sorted { $0.date < $1.date }
        switch selectionTimePeriod {
        case .w1:
            guard let startDate = calendar.date(byAdding: .day, value: -7, to: now) else { return [] }
            return sorted.filter { $0.date >= startDate && $0.date <= now }
        case .m1:
            guard let startDate = calendar.date(byAdding: .month, value: -1, to: now) else { return [] }
            return sorted.filter { $0.date >= startDate && $0.date <= now }
        case .m3:
            guard let startDate = calendar.date(byAdding: .month, value: -3, to: now) else { return [] }
            return sorted.filter { $0.date >= startDate && $0.date <= now }
        }
    }

    private var displayedPrice: Double {
        selectedItem?.price ?? stock.priceHistory.last?.price ?? 0.0
    }

    private var displayedChange: Double {
        guard let selected = selectedItem else { return stock.change }
        return selected.price - (stock.priceHistory.first?.price ?? selected.price)
    }

    private var chartColor: Color {
        selectedItem != nil ? .blue : stock.statusColor()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading) {
                    
                VStack(alignment: .leading) {
                    Text(stock.symbol)
                        .font(Font.largeTitle.bold())
                    Text(stock.name)
                        .font(Font.caption)
                        .opacity(0.5)
                }

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(displayedPrice, specifier: "%.2f")")
                        .font(Font.default.bold())
                        .contentTransition(.numericText())
                    Text("\(displayedChange.sign == .plus ? "+" : "")\(displayedChange, specifier: "%.2f")")
                        .font(Font.caption)
                        .foregroundColor(displayedChange >= 0 ? .green : .red)
                        .contentTransition(.numericText())
                    if let selected = selectedItem {
                        Text(selected.date, style: .date)
                            .font(Font.caption2)
                            .foregroundColor(.secondary)
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: selectedItem?.price)

                Text(exchangeCurrency).opacity(0.5)
                    
                }
                Picker("", selection: $selectionTimePeriod) {
                    ForEach(TimePeriodDetail.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectionTimePeriod) { _, _ in
                    selectedItem = nil
                }

                VStack(alignment: .leading, spacing: 16) {
                    interactiveChart
                    if let info = stock.informationDetail {
                        SheetDetailInformation(info: info)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    var interactiveChart: some View {
        Chart {
            ForEach(displayedChartData, id: \.date) { item in
                AreaMark(
                    x: .value("Date", item.date),
                    y: .value("Price", item.price)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [chartColor.opacity(0.4), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Price", item.price)
                )
                .foregroundStyle(chartColor)
            }

            if let selected = selectedItem {
                RuleMark(x: .value("Date", selected.date))
                    .foregroundStyle(Color.primary.opacity(0.35))
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [4]))
            }
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) {
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 4)) {
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geo in
                ZStack {
                    if let selected = selectedItem,
                       let xPos = proxy.position(forX: selected.date),
                       let yPos = proxy.position(forY: selected.price) {
                        ZStack {
                                Circle()
                                    .fill(chartColor.opacity(0.25))
                                    .frame(width: 22, height: 22)
                                Circle()
                                    .fill(chartColor)
                                    .frame(width: 11, height: 11)
                                    .shadow(color: chartColor.opacity(0.5), radius: 4, x: 0, y: 2)
                            }
                        .position(x: xPos, y: yPos)
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                    }

                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let data = displayedChartData
                                    guard !data.isEmpty else { return }
                                    let ratio = value.location.x / geo.size.width
                                    let rawIndex = ratio * CGFloat(data.count - 1)
                                    let index = max(0, min(Int(rawIndex.rounded()), data.count - 1))
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        selectedItem = data[index]
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedItem = nil
                                    }
                                }
                        )
                }
            }
        }
        .frame(height: 300)
    }
}

#Preview {
    SheetDetail(stock: defaultStocks[0])
}
