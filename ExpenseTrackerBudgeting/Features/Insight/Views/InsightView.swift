//
//  InsightView.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 11/05/23.
//

import SwiftUI

struct InsightView: View {
    @StateObject private var insightViewModel: InsightViewModel = InsightViewModel()
    @State private var selectedTab: Int = 0
    var tabs: [Tab] {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM/yyyy"
        
        var formattedMonths: [String] = []
        for monthIndex in 0..<currentMonth {
            let year = Calendar.current.component(.year, from: Date())
            let dateComponents = DateComponents(year: year, month: monthIndex + 1)
            let formattedDate = dateFormatter.string(from: Calendar.current.date(from: dateComponents)!)
            if monthIndex == currentMonth - 1 {
                formattedMonths.append("This Month")
            } else if monthIndex == currentMonth - 2 {
                formattedMonths.append("Last Month")
            } else {
                formattedMonths.append(formattedDate)
            }
        }
        let monthTabItems = formattedMonths.map { Tab(title: $0) }
        return monthTabItems
    }
    
    var dates: [Date] {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM/yyyy"
        
        var months: [Date] = []
        
        for monthIndex in 1...currentMonth {
            let dateComponents = DateComponents(year: currentYear, month: monthIndex)
            if let date = Calendar.current.date(from: dateComponents) {
                months.append(date)
            }
        }
        return months
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea(.all)
                GeometryReader { geo in
                    VStack (spacing: 0) {
                        Tabs(tabs: tabs, selectedTab: $selectedTab)
                        
                        TabView(selection: $selectedTab, content: {
                            ForEach(0..<tabs.count, id: \.self) { index in
                                InsightComponent(selectedMonth: dates[selectedTab], insightViewModel: insightViewModel)
                                    .tag(index)
                                    .gesture(DragGesture())
                                
                            }
                        })
                        .onAppear {
                            for (index, tab) in tabs.enumerated() {
                                if (tab.title == "This Month") {
                                    selectedTab = index
                                }
                            }
                        }
                        .onChange(of: selectedTab, perform: { newValue in
                            withAnimation {
                                insightViewModel.getDayDifference(date: dates[newValue])
                                insightViewModel.fetchIncomeMonth(date: dates[newValue])
                                insightViewModel.fetchExpenseMonth(date: dates[newValue])
                            }
                            
                        })
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .navigationTitle("Insight")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView()
    }
}
