//
//  BudgetGoalSheet.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 12/05/23.
//

import SwiftUI

struct BudgetGoalSheet: View {
    @ObservedObject var overviewViewModel : OverviewViewModel
    @Environment(\.dismiss) var dismiss
    @State private var transactionAmountField: Double = 0.00
    private var isValidated: Bool {
        guard transactionAmountField != 0.00 else {
            return false
        }
        return true
    }
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea(.all)
                VStack {
                    Text("Set Budget Goal This Month")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.leading, 18)
                    
                    HStack{
                        Text("USD")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(accentsColor.cornerRadius(20))
                        Spacer()
                        NumberTextField(value: $transactionAmountField)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black.opacity(0.6))
                        
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Color.white.cornerRadius(31).shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1))
                    .padding(.horizontal, 15)
                    Image("budgetImage")
                        .resizable()
                    Spacer()
                    Button {
                        if (isValidated) {
                            overviewViewModel.updateBudgetGoal(newBudgetGoal: Decimal(transactionAmountField))
                            dismiss.callAsFunction()
                        }
                    } label: {
                        Text("Set Budget Goal")
                            .fontWeight(.bold)
                            .font(.title3)
                            .foregroundColor(isValidated ? .white : .black.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 20)
                            .background(isValidated ? accentsColor.cornerRadius(35) : Color.gray.opacity(0.6).cornerRadius(35))
                            .padding(.horizontal, 15)
                    }
                    .padding(.bottom, 30)
                    .disabled(isValidated ? false : true)
                    .animation(.easeInOut(duration: 0.2), value: isValidated)
                }
            }
            .onTapGesture(perform: {
                self.endTextEditing()
            })
            .onAppear {
                transactionAmountField = Double(truncating: overviewViewModel.budgetGoal as NSDecimalNumber)
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text("Budget Goal"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Cancel")
                    }
                    
                }
            }
        }
    }
}


//struct BudgetGoalSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetGoalSheet()
//    }
//}
