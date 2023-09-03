//
//  TransactionView.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 08/05/23.
//

import SwiftUI

struct TransactionView: View {
    @State private var showAlert = false
    @ObservedObject var transactionViewModel: TransactionViewModel
    @ObservedObject var overviewViewModel: OverviewViewModel
    @State private var needDateHeader: Bool = false
    @State private var searchInput: String = ""
    @State private var isSearching: Bool = false
    @State private var transactionToDelete: Transaction?
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea(.all)
            VStack {
                List {
                    if(transactionViewModel.transactions.isEmpty) {
                        Text("Your transactions are empty")
                            .font(.body)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 10)
                    } else {
                        ForEach(transactionViewModel.groupedTransactions, id: \.0) { (month: String, transactions: [Transaction]) in
                            Section {
                                ForEach(transactions, id: \.self) { transaction in
                                    VStack {
                                        HStack  {
                                            HStack (spacing: 12.0) {
                                                Image(systemName: transaction.category?.categoryIcon ?? "cart.fill")
                                                    .font(.title3)
                                                    .foregroundColor(.white)
                                                    .padding(.all, 10)
                                                    .frame(width: 40, height: 40)
                                                    .background(
                                                        Circle()
                                                            .fill(transaction.category?.type == "Expense" ? expenseColor : incomeColor)
                                                    )
                                                VStack (alignment: .leading) {
                                                    Text(transaction.name ?? "Indomaret")
                                                        .font(.body)
                                                        .fontWeight(.medium)
                                                    Text(transaction.category?.name ?? "Super")
                                                        .fontWeight(.medium)
                                                        .opacity(0.7)
                                                    Text(transaction.date?.formatted(.dateTime.year(.defaultDigits).month(.wide).day(.twoDigits)) ?? Date().formatted(.dateTime.year(.defaultDigits).month(.wide).day(.twoDigits)))
                                                        .fontWeight(.medium)
                                                        .opacity(0.3)
                                                }
                                            }
                                            Spacer()
                                            HStack(spacing: 5) {
                                                Text(transaction.category?.type == "Income" ?  "+" : "-")
                                                Text("\((transaction.amount ?? 0).doubleValue.formatted(.currency(code: "USD")))")
                                            }
                                            .foregroundColor(transaction.category?.type == "Expense" ? expenseColor : incomeColor)
                                            .fontWeight(.bold)
                                        }
                                        
                                    }
                                    .onLongPressGesture {
                                        transactionToDelete = transaction
                                        showAlert.toggle()
                                    }
                                }
                            } header: {
                                Text(month)
                                    .padding(.bottom, 5)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                            }
                            
                        }
                    }
                    
                }
                .alert("Delete the transaction", isPresented: $showAlert, actions: {
                    Button("Cancel", role: .cancel) {
                        showAlert.toggle()
                    }
                    Button("Delete", role: .destructive) {
                        if let transaction = transactionToDelete {
                            overviewViewModel.updateDeleteBalance(transaction: transaction)
                            transactionViewModel.deleteTransaction(transaction: transaction)
                            //                            showAlert.toggle()
                        }
                    }
                }, message: {
                    
                })
                .animation(.easeOut(duration: 0.1), value: transactionViewModel.transactions)
                .onAppear{
                    transactionViewModel.fetchTransactions()
                }
                .padding(.top, -20)
                .listStyle(PlainListStyle())
                .searchable(text: $searchInput, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: searchInput) { _ in
                    if searchInput.isEmpty {
                        transactionViewModel.fetchTransactions()
                    } else {
                        transactionViewModel.searchTransactions(searchQuery: searchInput)
                    }
                }
                .navigationTitle(Text("Transaction List"))
                .navigationBarTitleDisplayMode(.inline)
                .scrollIndicators(.never)
            }
            
        }
    }
}

//struct TransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionView(overviewViewModel: OverviewViewModel())
//    }
//}
