//
//  InsightComponent.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 11/05/23.
//

import SwiftUI

struct InsightComponent: View {
    var selectedMonth: Date
    @ObservedObject var insightViewModel: InsightViewModel
    var coreDataConstants: CoreDataConstants {
        return CoreDataConstants(coreDataManager: insightViewModel.coreDataManager)
    }
    var accumulatedBalance: Decimal {
        return insightViewModel.accumulatedBalance
    }
    
    var sortedExpenseDictionary: [(key: Category, value: Decimal)] {
        insightViewModel.expenseDictionary.sorted { $0.key.name! < $1.key.name! }
    }
    
    var sortedIncomeDictionary: [(key: Category, value: Decimal)] {
        insightViewModel.incomeDictionary.sorted { $0.key.name! < $1.key.name! }
    }
    
    var expensesCategory: [Category] {
        var tempArray: [Category] = []
        for category in coreDataConstants.categoriesFilled {
            if category.type == "Expense" {
                tempArray.append(category)
            }
        }
        return tempArray
    }
    var incomeCategory: [Category] {
        var tempArray: [Category] = []
        for category in coreDataConstants.categoriesFilled {
            if category.type == "Income" {
                tempArray.append(category)
            }
        }
        return tempArray
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("\((accumulatedBalance as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD")))")
                    .font(.largeTitle)
                    .foregroundColor(accentsColor)
                    .fontWeight(.bold)
                    .animation(.easeInOut(duration: 0.2), value: accumulatedBalance)
                Text("Accumulated Balance")
                    .fontWeight(.bold)
                    .opacity(0.5)
                    .font(.headline)
                
                HStack {
                    Spacer()
                    VStack {
                        Text("\((insightViewModel.totalIncomeMonth as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD")))")
                            .fontWeight(.bold)
                        Text("Total income")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .opacity(0.5)
                    }
                    Spacer()
                    VStack {
                        Text("\((insightViewModel.totalExpenseMonth as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD")))")
                            .fontWeight(.bold)
                        Text("Total spent")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .opacity(0.5)
                    }
                    if (insightViewModel.isCurrentMonth) {
                        Spacer()
                        VStack {
                            Text("\(insightViewModel.dayDifference) days")
                                .fontWeight(.bold)
                            Text("End of month")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.5)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 8)
            }
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity)
            .background(Color.white.cornerRadius(5.0).shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
            .padding(.all, 10.0)
            
            ScrollView {
                VStack(spacing: 0) {
                    Section {
                        //pass dictionary into foreach and use the category and amount
                        ForEach(sortedExpenseDictionary, id: \.key) { category, amount in
                            VStack {
                                HStack {
                                    HStack(spacing: 15) {
                                        Image(systemName: category.categoryIcon!)
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .padding(.all, 3)
                                            .background(
                                                Circle()
                                                    .fill(category.type == "Expense" ? expenseColor : incomeColor)
                                            )
                                        Text((category.name!))
                                            .font(.title3)
                                            .fontWeight(.medium)
                                    }
                                    Spacer()
                                    Text("\((amount as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD")))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(accentsColor)
                                    
                                }
                                Divider()
                            }
                            .padding(.all, 10)
                            .padding(.horizontal, 12)
                        }
                    } header: {
                        Text("Expenses")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                    }
                    Section {
                        ForEach(sortedIncomeDictionary, id: \.key) { category, amount in
                            VStack {
                                HStack {
                                    HStack(spacing: 15) {
                                        Image(systemName: category.categoryIcon!)
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .padding(.all, 3)
                                            .background(
                                                Circle()
                                                    .fill(category.type == "Expense" ? expenseColor : incomeColor)
                                            )
                                        Text((category.name!))
                                            .font(.title3)
                                            .fontWeight(.medium)
                                    }
                                    Spacer()
                                    Text("$ \((amount) as NSDecimalNumber),00")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(accentsColor)
                                }
                                Divider()
                                //                                HorizontalDivider(color: .black.opacity(0.1), height: 1, width: .infinity)
                            }
                            .padding(.all, 10)
                            .padding(.horizontal, 12)
                        }
                    } header: {
                        Text("Incomes")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.bottom, 5)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.top, 20)
        .onAppear{
            insightViewModel.fetchIncomeMonth(date: selectedMonth)
            insightViewModel.fetchExpenseMonth(date: selectedMonth)
            insightViewModel.getDayDifference(date: selectedMonth)
            insightViewModel.getIncomeCategory(date: selectedMonth, categories: incomeCategory)
            insightViewModel.getExpenseCategory(date: selectedMonth, categories: expensesCategory)
            insightViewModel.getAccumulatedBalance()
        }
    }
    
}

struct InsightComponent_Previews: PreviewProvider {
    static var previews: some View {
        InsightComponent(selectedMonth: Date(), insightViewModel: InsightViewModel())
    }
}

