//
//  ExpenseTrackerBudgetingApp.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 08/05/23.
//

import SwiftUI

@main
struct ExpenseTrackerBudgetingApp: App {
    @StateObject private var overviewViewModel = OverviewViewModel()
    @StateObject private var transactionViewModel = TransactionViewModel()
    var body: some Scene {
        WindowGroup {
            TabViewExampleView(overviewViewModel: overviewViewModel, transactionViewModel: transactionViewModel)
        }
    }
}
