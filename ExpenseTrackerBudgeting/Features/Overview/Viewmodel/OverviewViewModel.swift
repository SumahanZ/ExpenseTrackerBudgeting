//
//  OverviewViewModel.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 09/05/23.
//

import Foundation
import CoreData

class OverviewViewModel: ObservableObject {
    
    let coreDataManager = CoreDataManager()
    
    var coreDataConstants: CoreDataConstants {
        return CoreDataConstants(coreDataManager: coreDataManager)
    }
    @Published var totalSpentToday: Decimal = 0.00
    @Published var totalSpentWeek: Decimal = 0.00
    @Published var totalSpentWeekAgo: Decimal = 0.00
    @Published var totalSpentYesterday: Decimal = 0.00
    @Published var totalSpentMonth: Decimal = 0.00
    @Published var isWeekBigger: Bool = false
    @Published var isTodayBigger: Bool = false
    @Published var percentageWeek: Decimal = 0
    @Published var percentageDay: Decimal = 0
    @Published var transactions: [Transaction] = []
    @Published var budgetGoal: Decimal = 0.00
    @Published var balance: Balance?
    
    init() {
        //deleteAllTransactions()
        //addDummyTransactions()
        fetchBalance()
        fetchRecentTransactions()
    }
    
    func fetchRecentTransactions() {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 10
        
        do {
            transactions = try coreDataManager.viewContext.fetch(fetchRequest)
            print("succeed fetch data")
        } catch let error as NSError {
            print("Error fetching expenses: \(error)")
        }
    }
    
    func fetchTotalSpentToday() {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = calendar.startOfDay(for: currentDate)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startDate as NSDate, endDate! as NSDate)
        
        do {
            let transactions = try coreDataManager.viewContext.fetch(fetchRequest)
            totalSpentToday = 0.00
            for transaction in transactions {
                if (transaction.category?.type == "Expense") {
                    totalSpentToday += ((transaction.amount ?? 0) as Decimal)
                } else {
                    self.totalSpentToday += 0.00
                }
            }
            print("succed fetch all transactions today")
        } catch {
            print("Error fetching transactions: \(error.localizedDescription)")
        }
    }
    
    func fetchTotalSpentWeek() {
        let calendar = Calendar.current
        let today = Date()
        var startOfWeek: Date = Date()
        var interval: TimeInterval = 0
        _ = calendar.dateInterval(of: .weekOfYear, start: &startOfWeek, interval: &interval, for: today)
        let endOfWeek = startOfWeek.addingTimeInterval(interval - 1)
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startOfWeek as NSDate, endOfWeek as NSDate)
        
        do {
            let transactions = try coreDataManager.viewContext.fetch(fetchRequest)
            totalSpentWeek = 0.00
            for transaction in transactions {
                if (transaction.category?.type == "Expense") {
                    totalSpentWeek += ((transaction.amount ?? 0) as Decimal)
                } else {
                    self.totalSpentWeek += 0.00
                }
            }
            print("succed fetch all transactions this week")
        } catch {
            print("Error fetching transactions: \(error.localizedDescription)")
        }
    }
    
    func fetchTotalSpentMonth() {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: Date())!.start
        let endOfMonth = calendar.dateInterval(of: .month, for: Date())!.end
        let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfMonth as NSDate, endOfMonth as NSDate)
        
        totalSpentMonth = 0
        do {
            let fetchedTransactions = try coreDataManager.viewContext.fetch(fetchRequest)
            for transaction in fetchedTransactions {
                if (transaction.category?.type == "Expense") {
                    totalSpentMonth += ((transaction.amount ?? 0) as Decimal)
                }
            }
        } catch let error as NSError {
            print("Could not fetch transactions. \(error), \(error.userInfo)")
        }
        
    }
    
    func getPercentageDifferenceWeek() {
        let calendar = Calendar.current
        let currentDate = Date()
        
        guard let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate) else {
            fatalError("Could not calculate date one week ago")
        }
        let startOfOneWeekAgo = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: oneWeekAgo))
        let endOfOneWeekAgo = calendar.date(byAdding: .second, value: -1, to: calendar.date(byAdding: .weekOfYear, value: 1, to: startOfOneWeekAgo!)!)
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfOneWeekAgo! as NSDate, endOfOneWeekAgo! as NSDate)
        do {
            let transactions = try coreDataManager.viewContext.fetch(fetchRequest)
            totalSpentWeekAgo = 0.00
            totalSpentWeek = 0.00
            for transaction in transactions {
                if (transaction.category?.type == "Expense") {
                    totalSpentWeekAgo += transaction.amount! as Decimal
                } else {
                    totalSpentWeekAgo += 0.00
                }
            }
            fetchTotalSpentWeek()
            percentageWeek = 0
            if (totalSpentWeekAgo > totalSpentWeek) {
                percentageWeek = ((totalSpentWeekAgo - totalSpentWeek) / totalSpentWeekAgo * 100)
                isWeekBigger = false
            } else if (totalSpentWeekAgo == totalSpentWeek) {
                percentageWeek = 0
                isWeekBigger = false
            } else {
                percentageWeek = ((totalSpentWeek - totalSpentWeekAgo) / totalSpentWeek * 100)
                isWeekBigger = true
            }
            
            print("succed fetch all transactions this week")
        } catch {
            print("Error fetching transactions: \(error.localizedDescription)")
        }
    }
    
    func getPercentageDifferenceDay() {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        let startOfYesterday = calendar.startOfDay(for: yesterday)
        let endOfYesterday = calendar.date(byAdding: .day, value: 1, to: startOfYesterday)!
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startOfYesterday as NSDate, endOfYesterday as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            let transactions = try coreDataManager.viewContext.fetch(fetchRequest)
            totalSpentYesterday = 0.00
            totalSpentToday = 0.00
            for transaction in transactions {
                if (transaction.category?.type == "Expense") {
                    totalSpentYesterday += (transaction.amount ?? 0) as Decimal
                } else {
                    totalSpentYesterday += 0.00
                }
            }
            fetchTotalSpentToday()
            percentageDay = 0
            if (totalSpentYesterday > totalSpentToday) {
                percentageDay = ((totalSpentYesterday - totalSpentToday) / totalSpentYesterday * 100)
                isTodayBigger = false
            } else if (totalSpentYesterday == totalSpentToday) {
                percentageDay = 0
                isTodayBigger = false
            } else {
                percentageDay = ((totalSpentToday - totalSpentYesterday) / totalSpentToday * 100)
                isTodayBigger = true
            }
            print("succed fetch all transactions yesterday")
        } catch let error as NSError {
            print("Error fetching transactions from yesterday: \(error.localizedDescription)")
            
        }
        
    }
    
    func addDummyTransactions() {
        let newTransaction = Transaction(context: coreDataManager.viewContext)
        newTransaction.name = "New Test"
        newTransaction.amount = 50.00
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 5
        dateComponents.day = 7
        let date = calendar.date(from: dateComponents)
        newTransaction.date = date
        
        newTransaction.category = coreDataConstants.categoriesFilled[1]
        
        
        let newTransaction2 = Transaction(context: coreDataManager.viewContext)
        newTransaction2.name = "2nd Test"
        newTransaction2.amount = 150.00
        
        var dateComponents2 = DateComponents()
        dateComponents2.year = 2023
        dateComponents2.month = 4
        dateComponents2.day = 9
        let date2 = calendar.date(from: dateComponents2)
        newTransaction2.date = date2
        newTransaction2.category = coreDataConstants.categoriesFilled[0]
        
        
        let newTransaction3 = Transaction(context: coreDataManager.viewContext)
        newTransaction3.name = "3rd Test"
        newTransaction3.amount = 250.00
        
        var dateComponents3 = DateComponents()
        dateComponents3.year = 2023
        dateComponents3.month = 3
        dateComponents3.day = 12
        let date3 = calendar.date(from: dateComponents3)
        newTransaction3.date = date3
        newTransaction3.category = coreDataConstants.categoriesFilled[1]
        coreDataManager.saveContext()
    }
    
    func deleteAllTransactions() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coreDataManager.viewContext.execute(batchDeleteRequest)
            coreDataManager.saveContext()
        } catch let error {
            print("Error deleting all transactions: \(error.localizedDescription)")
        }
    }
    
    func fetchBalance() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Balance")
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try coreDataManager.viewContext.fetch(fetchRequest)
            guard let fetchedBalance = result.first as? Balance else{
                balance = Balance(context: coreDataManager.viewContext)
                return
            }
            balance = fetchedBalance
        } catch {
            print("Error fetching your budget goal: \(error)")
        }
    }
    
    func fetchBudgetGoal() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Balance")
        fetchRequest.fetchLimit = 1
        do {
            let result = try coreDataManager.viewContext.fetch(fetchRequest)
            guard let fetchedBalance = result.first as? Balance else{
                return
            }
            budgetGoal = ((fetchedBalance.budgetGoal ?? 0) as Decimal)
        } catch {
            print("Error fetching your balance: \(error)")
        }
    }
    
    func updateBudgetGoal(newBudgetGoal: Decimal) {
        balance?.budgetGoal = ((newBudgetGoal) as NSDecimalNumber)
        coreDataManager.saveContext()
        budgetGoal = newBudgetGoal
    }
    
    func updateBalance(category: Category, amount: Decimal) {
        if (category.type == "Income") {
            print("entered income")
            if let balanceAmount = balance?.balanceAmount?.adding(amount as NSDecimalNumber) {
                balance?.balanceAmount = balanceAmount
                coreDataManager.saveContext()
            }
        } else {
            print("entered expense")
            if let balanceAmount = balance?.balanceAmount?.subtracting(amount as NSDecimalNumber) {
                balance?.balanceAmount = balanceAmount
                coreDataManager.saveContext()
            }
        }
    }
    
    func updateDeleteBalance(transaction: Transaction) {
        if (transaction.category?.type == "Income") {
            if let balanceAmount = balance?.balanceAmount?.subtracting((transaction.amount ?? 0 as NSDecimalNumber)) {
                balance?.balanceAmount = balanceAmount
                coreDataManager.saveContext()
            }
        } else {
            if let balanceAmount = balance?.balanceAmount?.adding((transaction.amount ?? 0 as NSDecimalNumber)) {
                balance?.balanceAmount = balanceAmount
                coreDataManager.saveContext()
            }
        }
    }
}







