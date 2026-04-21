//
//  ContentView.swift
//  AcademyStocksPM
//
//  Created by benchandra on 15/04/26.
//


import SwiftUI
import Charts


struct ContentView: View {
    var body: some View {
        TabView {
                  PageHome()
                      .tabItem {
                          Label("Home", systemImage: "house")
                      }

                  PageMyPortfolio()
                      .tabItem {
                          Label("My Portfolio", systemImage: "chart.pie")
                      }

                  Text("Settings Page")
                      .tabItem {
                          Label("Settings", systemImage: "gearshape")
                      }
              }
    }
}

#Preview {
    ContentView()
}
