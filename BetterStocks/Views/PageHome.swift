//
//  PageHome.swift
//  BetterStocks
//
//  Created by Abuidillah Adjie Muliadi on 20/04/26.
//


import SwiftUI
import Charts


struct PageHome: View {
    
    @State var stocks: [Stock] = defaultStocks
    @State var showSheet = true
    @State var selectionTimePeriod  : TimePeriod = .w
    @State var shouldPresentSheet = false
    @State var selectedStock: Stock?
    var body: some View {
        NavigationStack {
            List {
                MyPortfolioCard()
                    .listRowSeparator(.hidden)
                HStack {
                    Menu {
                        Button("My Symbols") {
                            
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
                    Picker("", selection: $selectionTimePeriod ) {
                        ForEach(TimePeriod.allCases, id: \.self) {   option in
                            Text(option.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                    .listRowSeparator(.hidden)
                
                ForEach(stocks) { stock in
                    StockCard(stock: stock, timePeriod: selectionTimePeriod)
                        .onTapGesture(perform: {
                            selectedStock = stock
                            shouldPresentSheet = true
                        } )
                        .swipeActions {
                            Button(role: .destructive) {} label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            Button {  } label: {
                                                Label("Flag", systemImage: "flag")
                                            }
                            
                        }
                }.onMove {
                    from, to in
                    stocks.move(fromOffsets: from, toOffset: to)
                }

            }
            .listStyle(.plain)
            .sheet(isPresented: $shouldPresentSheet) {
                          } content: {
                              NavigationStack() {
                                  SheetDetail(stock : (selectedStock != nil ? selectedStock! : stocks.first!))
                                      .padding()
                                      .presentationDragIndicator(.visible)
                                      .toolbar {
                                          ToolbarItem(placement: .topBarLeading) {
                                                  Button("", systemImage: "xmark") {
                                                      shouldPresentSheet  = false
                                              }
                                              .frame(width: 200, alignment: .leading)
                                          }
                                          ToolbarItem(placement: .topBarTrailing) {
                                              HStack {
                                                  Button("", systemImage: "magnifyingglass") {

                                                  }
                                                  Button("", systemImage: "ellipsis") {

                                                  }
                                              }
                                          }
                                      }
                                    
                                  Spacer()
                                  

                              }
                              
                              
                          }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("BetterStocks")
                            .font(.title).fontWeight(.bold)
                        Text("14 April").font(.subheadline).foregroundStyle(
                            .secondary
                        )
                    }
                    .frame(width: 200, alignment: .leading)

                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button("", systemImage: "magnifyingglass") {

                        }
                        Button("", systemImage: "ellipsis") {

                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
            
            
        }

    }
}


struct PriceHistory {
    var date: Date
    var price: Double
}

// enum for strict typing of stock status
enum StockPriceStatus {
   case neutral, positive, negative
}

#Preview {
    PageHome()
}
