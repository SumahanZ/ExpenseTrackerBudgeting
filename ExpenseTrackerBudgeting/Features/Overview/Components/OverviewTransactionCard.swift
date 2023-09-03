//
//  OverviewTransactionCard.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 08/05/23.
//

import SwiftUI

struct OverviewTransactionCard: View {
    @ObservedObject var overviewViewModel: OverviewViewModel
    @ObservedObject var transactionViewModel: TransactionViewModel
    //    @Binding var strings: [String]
    
    var body: some View {
        VStack {
            List {
                Section {
                    if (overviewViewModel.transactions.isEmpty) {
                        Text("Your transactions are empty")
                            .font(.body)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(overviewViewModel.transactions, id: \.self) { transaction in
                            VStack {
                                HStack  {
                                    HStack (spacing: 15.0) {
                                        Image(systemName: transaction.category?.categoryIcon ?? "cart.fill")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                            .padding(.all, 5)
                                            .frame(width: 40, height: 40)
                                            .background(
                                                Circle()
                                                    .fill(transaction.category?.type == "Expense" ? expenseColor : incomeColor)
                                            )
                                        VStack (alignment: .leading) {
                                            Text(transaction.name ?? "Indomaret")
                                                .font(.body)
                                                .fontWeight(.medium)
                                            Text(transaction.category?.name ?? "Balu")
                                                .fontWeight(.medium)
                                                .opacity(0.7)
                                            Text(transaction.date?.formatted(.dateTime.year(.defaultDigits).month(.wide).day(.twoDigits)) ?? Date().formatted(.dateTime.year(.defaultDigits).month(.wide).day(.twoDigits)))
                                                .fontWeight(.medium)
                                                .opacity(0.3)
                                        }
                                    }
                                    Spacer()
                                    HStack (spacing: 5) {
                                        Text(transaction.category?.type == "Income" ?  "+" : "-")
                                        Text("\((transaction.amount ?? 0).doubleValue.formatted(.currency(code: "USD")))")
                                    }
                                    .foregroundColor(transaction.category?.type == "Expense" ? expenseColor : incomeColor)
                                    .fontWeight(.bold)
                                }
                                
                            }
                        }
                    }
                } header: {
                    HStack {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("Recent Transactions")
                                .foregroundColor(.black)
                                .font(.title2)
                                .fontWeight(.bold)
                                .textCase(nil)
                            Text("Recent 10 Transactions")
                                .font(.caption)
                        }
                        Spacer()
                        NavigationLink {
                            TransactionView(transactionViewModel: transactionViewModel, overviewViewModel: overviewViewModel)
                        } label: {
                            Text("View All")
                                .foregroundColor(accentsColor)
                        }
                    }
                }
            }
            .scrollIndicators(.never)
            .listStyle(PlainListStyle())
            .padding(.horizontal, 15)
            .background(Color.white.cornerRadius(0.0))
            Spacer()
        }
    }
    
    //struct OverviewTransactionCard_Previews: PreviewProvider {
    //    static var previews: some View {
    //        OverviewTransactionCard(strings: $strings)
    //    }
    //}
}
