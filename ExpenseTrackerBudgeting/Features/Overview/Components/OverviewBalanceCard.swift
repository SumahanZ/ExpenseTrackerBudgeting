//
//  OverviewBalanceCard.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 08/05/23.
//

import SwiftUI

struct OverviewBalanceCard: View {
    @ObservedObject var overviewViewModel: OverviewViewModel
    @State private var showBudgetGoalSheet: Bool = false
    var progressBarColor: Color {
        
        if (Double(truncating: overviewViewModel.totalSpentMonth as NSDecimalNumber) / Double(truncating: overviewViewModel.budgetGoal as NSDecimalNumber)) >= 0.3 && !(overviewViewModel.totalSpentMonth > overviewViewModel.budgetGoal) {
            return .yellow
        } else if Double(truncating: overviewViewModel.totalSpentMonth as NSDecimalNumber) / Double(truncating: overviewViewModel.budgetGoal as NSDecimalNumber) >= 0.5 && !(overviewViewModel.totalSpentMonth > overviewViewModel.budgetGoal) {
            return .orange
        } else if (overviewViewModel.totalSpentMonth > overviewViewModel.budgetGoal) {
            return .red
        }
        return Color.green
    }
    
    var body: some View {
        VStack {
            Text("My Balance")
                .font(.title2)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .padding(.top, 30.0)
                .padding(.bottom, -10.0)
            
            Text("\((overviewViewModel.balance?.balanceAmount ?? 0).doubleValue.formatted(.currency(code: "USD")))")
                .font(.largeTitle)
                .foregroundColor(accentsColor)
                .fontWeight(.bold)
                .animation(.easeIn(duration: 0.05), value: overviewViewModel.balance?.balanceAmount)
            
            HorizontalDivider(color: accentsColor.opacity(0.5), height: 1.5, width: UIScreen.main.bounds.width)
            VStack  {
                Text("Recent Spendings")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                
                HStack {
                    VStack (alignment: .center) {
                        Text("\((overviewViewModel.totalSpentWeek as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD")))")
                            .font(.title2)
                            .fontWeight(.semibold)
                        HStack(spacing: 4) {
                            Text("Spent this week")
                                .opacity(0.5)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                            
                            Image(systemName: overviewViewModel.isWeekBigger ? "arrow.up.right" : "arrow.down.left")
                                .fontWeight(.bold)
                                .foregroundColor(overviewViewModel.isWeekBigger ? expenseColor : incomeColor)
                                .font(.caption2)
                            Text("\((overviewViewModel.percentageWeek as NSDecimalNumber).doubleValue, specifier: "%.2f")%")
                                .foregroundColor(overviewViewModel.isWeekBigger ? expenseColor : incomeColor)
                                .font(.caption2)
                                .fontWeight(.bold)
                        }
                        
                    }
                    Spacer()
                    VStack (alignment: .center) {
                        Text("\((overviewViewModel.totalSpentToday as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD")))")
                            .font(.title2)
                            .fontWeight(.semibold)
                        HStack (spacing: 4) {
                            Text("Spent today")
                                .opacity(0.5)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                            Image(systemName: overviewViewModel.isTodayBigger ? "arrow.up.right" : "arrow.down.left")
                                .foregroundColor(overviewViewModel.isTodayBigger ? expenseColor : incomeColor)
                                .font(.caption2)
                                .fontWeight(.bold)
                            Text("\((overviewViewModel.percentageDay as NSDecimalNumber).doubleValue, specifier: "%.2f")%")
                                .foregroundColor(overviewViewModel.isTodayBigger ? expenseColor : incomeColor)
                                .font(.caption2)
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 40)
                
                VStack {
                    HStack {
                        Text("Goal expenses for this month")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\((overviewViewModel.budgetGoal as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD")))")
                            .foregroundColor(accentsColor)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .onTapGesture {
                                showBudgetGoalSheet.toggle()
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    
                    
                    ProgressView(value: Double(truncating: overviewViewModel.totalSpentMonth as NSDecimalNumber), total: Double(truncating: overviewViewModel.budgetGoal as NSDecimalNumber))
                        .progressViewStyle(.linear)
                        .tint(progressBarColor)
                        .scaleEffect(x: 1, y: 4, anchor: .center)
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                        .animation(.easeInOut(duration: 0.8), value: overviewViewModel.totalSpentMonth)
                    
                    HStack(spacing: 5) {
                        Text("Spent")
                            .opacity(0.5)
                        Text("\((overviewViewModel.totalSpentMonth as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD"))) of")
                        Text("\((overviewViewModel.budgetGoal as NSDecimalNumber).doubleValue.formatted(.currency(code: "USD"))) this month")
                            .opacity(0.5)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .padding(.leading, 35)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .sheet(isPresented: $showBudgetGoalSheet, onDismiss: {
            overviewViewModel.fetchBudgetGoal()
        }, content: {
            BudgetGoalSheet(overviewViewModel: overviewViewModel)
        })
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 15.0)
        
    }
    
    //    struct OverviewBalanceCard_Previews: PreviewProvider {
    //        static var previews: some View {
    //            OverviewBalanceCard(overviewViewModel: over)
    //        }
    //    }
}

