//
//  TransactionModal.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 08/05/23.
//

import SwiftUI

struct AddTransactionModal: View {
    @ObservedObject var overviewViewModel : OverviewViewModel
    @StateObject private var transactionViewModel = TransactionViewModel()
    @StateObject private var insightViewModel = InsightViewModel()
    var coreDataConstants: CoreDataConstants {
        return CoreDataConstants(coreDataManager: transactionViewModel.coreDataManager)
    }
    @Binding var submitted: Bool
    @State private var selectedOption: Category?
    @Environment(\.dismiss) var dismiss
    @State private var transactionAmountField: Double = 0.00
    @State private var transactionNameField = ""
    @State private var showDropdown = false
    @State private var birthDate: Date = Date()
    private var isValidated: Bool {
        guard transactionNameField != "" else {
            return false
        }
        
        guard transactionAmountField != 0.00 else {
            return false
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea(.all)
                ScrollView {
                    VStack {
                        Group {
                            Text("Transaction Name")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 5)
                                .padding(.leading, 18)
                            VStack {
                                TextField("Enter Transaction Name", text: $transactionNameField)
                                    .foregroundColor(accentsColor)
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                            .foregroundColor(Color(hex: "979797").opacity(0.3))
                            .padding(.horizontal, 20)
                            
                            Text("Enter Amount")
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
                            
                        }
                        
                        Group {
                            Text("Transaction Details")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 16)
                                .padding(.leading, 18)
                            
                            Text("Category")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 5)
                                .padding(.leading, 25)
                            
                            HStack{
                                HStack(spacing: 15) {
                                    Image(systemName: selectedOption?.categoryIcon ?? "cart.fill")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.all, 10)
                                        .frame(width: 40, height: 40)
                                        .background((selectedOption?.type == "Expense" ? expenseColor : incomeColor).cornerRadius(50))
                                    
                                    Text(selectedOption?.name ?? "None")
                                        .fontWeight(.medium)
                                        .opacity(0.7)
                                }
                                
                                Spacer()
                                Button {
                                    showDropdown.toggle()
                                } label: {
                                    Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .foregroundColor(.black.opacity(0.6))
                                }
                            }
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                            .background(Color.white.cornerRadius(31).shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1))
                            .padding(.horizontal, 15)
                            
                            //                            selectedOption = option
                            if (showDropdown) {
                                List(coreDataConstants.categoriesFilled, id: \.self) { option in
                                    VStack {
                                        HStack (spacing: 15.0) {
                                            Image(systemName: option.categoryIcon ?? "cart.fill")
                                                .font(.title3)
                                                .foregroundColor(.white)
                                                .padding(.all, 10)
                                                .frame(width: 40, height: 40)
                                                .background(
                                                    Circle()
                                                        .fill(option.type == "Expense" ? expenseColor : incomeColor)
                                                )
                                            VStack (alignment: .leading) {
                                                Text(option.name ?? "Test")
                                                    .fontWeight(.medium)
                                                    .opacity(0.7)
                                            }
                                            Spacer()
                                            if (selectedOption?.name == option.name) {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .font(.headline)
                                                        .fontWeight(.medium)
                                                        .foregroundColor(.black.opacity(0.6))
                                                }
                                            }
                                        }
                                        
                                    }
                                    .onTapGesture {
                                        self.selectedOption = option
                                        withAnimation(.interactiveSpring()) {
                                            showDropdown.toggle()
                                        }
                                    }
                                    
                                    
                                }
                                .transition(.asymmetric(insertion: .move(edge:.top), removal: .opacity))
                                .animation(.spring())
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .listStyle(.plain)
                                .frame(height: 150)
                                .cornerRadius(25)
                            }
                            
                            
                            Text("Date")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 5)
                                .padding(.leading, 25)
                            HStack{
                                DatePicker("Pick Date", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black.opacity(0.5))
                                    .accentColor(accentsColor)
                            }
                            .padding(.horizontal, 25)
                            .padding(.vertical, 16)
                            .background(Color.white.cornerRadius(31).shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1))
                            .padding(.horizontal, 15)
                            
                            
                            Button {
                                if (isValidated) {
                                    transactionViewModel.addTransaction(name: transactionNameField, amount: Decimal(transactionAmountField), date: birthDate, category: selectedOption!)
                                    overviewViewModel.updateBalance(category: selectedOption!, amount: Decimal(transactionAmountField))
                                    submitted = true
                                }
                            } label: {
                                Text("Add Transaction")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .foregroundColor(isValidated ? .white : .black.opacity(0.3))
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 20)
                                    .background(isValidated ? accentsColor.cornerRadius(35) : Color.gray.opacity(0.6).cornerRadius(35))
                                    .padding(.horizontal, 15)
                            }
                            .padding(.top, 40)
                            .disabled(isValidated ? false : true)
                            .animation(.easeInOut(duration: 0.2), value: isValidated)
                        }
                        
                    }
                }
                .onAppear {
                    selectedOption = coreDataConstants.categoriesFilled[0]
                }
            }
            .onTapGesture(perform: {
                self.endTextEditing()
            })
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text("Add Transaction"))
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


//struct AddTransactionModal_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTransactionModal(submitted: false)
//    }
//}

