//
//  OverviewView.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 08/05/23.
//

import SwiftUI

struct OverviewView: View {
    @ObservedObject var overviewViewModel: OverviewViewModel
    @ObservedObject var transactionViewModel: TransactionViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                VStack(spacing: 20) {
                    OverviewBalanceCard(overviewViewModel: overviewViewModel)
                    OverviewTransactionCard(overviewViewModel: overviewViewModel, transactionViewModel: transactionViewModel)
                }
                .onAppear {
                    overviewViewModel.fetchRecentTransactions()
                    overviewViewModel.fetchBalance()
                    overviewViewModel.fetchBudgetGoal()
                    overviewViewModel.fetchTotalSpentMonth()
                    overviewViewModel.fetchTotalSpentToday()
                    overviewViewModel.fetchTotalSpentWeek()
                    overviewViewModel.getPercentageDifferenceWeek()
                    overviewViewModel.getPercentageDifferenceDay()
                }
            }
            .navigationTitle(Text("Overview"))
            .navigationBarTitleDisplayMode(.automatic)
            
        }
        
    }
}

//struct OverviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverviewView(overviewViewModel: OverviewViewModel())
//    }
//}
