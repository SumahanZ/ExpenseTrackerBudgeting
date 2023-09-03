//
//  InsightViewModel.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 11/05/23.
//

import Foundation
import CoreData

class InsightViewModel: ObservableObject {
    let coreDataManager = CoreDataManager()
    @Published var totalIncomeMonth: Decimal = 0
    @Published var totalExpenseMonth: Decimal = 0
    @Published var isCurrentMonth: Bool = false
    @Published var dayDifference: Int = 0
    @Published var accumulatedBalance: Decimal = 0
    @Published var expenseDictionary = [Category: Decimal]()
    @Published var incomeDictionary = [Category: Decimal]()
    
    func fetchIncomeMonth(date: Date)  {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: date)!.start
        let endOfMonth = calendar.dateInterval(of: .month, for: date)!.end
        
        let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfMonth as NSDate, endOfMonth as NSDate)
        
        totalIncomeMonth = 0
        do {
            let fetchedTransactions = try coreDataManager.viewContext.fetch(fetchRequest)
            for transaction in fetchedTransactions {
                if (transaction.category?.type == "Income") {
                    totalIncomeMonth += transaction.amount! as Decimal
                }
            }
        } catch let error as NSError {
            print("Could not fetch transactions. \(error), \(error.userInfo)")
        }
    }
    
    func fetchExpenseMonth(date: Date) {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: date)!.start
        let endOfMonth = calendar.dateInterval(of: .month, for: date)!.end
        
        let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfMonth as NSDate, endOfMonth as NSDate)
        
        totalExpenseMonth = 0
        do {
            let fetchedTransactions = try coreDataManager.viewContext.fetch(fetchRequest)
            for transaction in fetchedTransactions {
                if (transaction.category?.type == "Expense") {
                    totalExpenseMonth += transaction.amount! as Decimal
                }
            }
        } catch let error as NSError {
            print("Could not fetch transactions. \(error), \(error.userInfo)")
        }
    }
    
    func getDayDifference(date: Date) {
        let monthPassed = Calendar.current.component(.month, from: date)
        let monthCurrent = Calendar.current.component(.month, from: Date())
        if (monthPassed != monthCurrent) {
            isCurrentMonth = false
        } else {
            isCurrentMonth = true
            guard let lastDayOfMonth = Calendar.current.dateInterval(of: .month, for: Date())?.end else {
                fatalError("Could not get last day of month for \(Date())")
            }
            let daysBetween = Calendar.current.dateComponents([.day], from: Date(), to: lastDayOfMonth).day ?? 0
            dayDifference = daysBetween
        }
        
    }
    
    func getExpenseCategory(date: Date, categories: [Category]) {
        //TODO: Fetch transactions based on the month
        //TODO: Get all expenses of a certain category on a certain month
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: date)!.start
        let endOfMonth = calendar.dateInterval(of: .month, for: date)!.end
        
        let categorySet = Set(categories)
        
        expenseDictionary.removeAll()
        for category in categorySet {
            var amount: Decimal = 0
            do {
                let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@ AND category.name == %@", startOfMonth as NSDate, endOfMonth as NSDate, category.name!)
                let transactions = try coreDataManager.viewContext.fetch(fetchRequest)
                for transaction in transactions {
                    amount += transaction.amount!.decimalValue
                }
                expenseDictionary[category] = amount
            } catch {
                fatalError("Error fetching transactions of the specific category: \(error.localizedDescription)")
            }
        }
    }
    
    func getIncomeCategory(date: Date, categories: [Category]) {
        //TODO: Fetch transactions based on the month
        //TODO: Get all expenses of a certain category on a certain month
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: date)!.start
        let endOfMonth = calendar.dateInterval(of: .month, for: date)!.end
        
        let categorySet = Set(categories)
        
        incomeDictionary.removeAll()
        for category in categorySet {
            var amount: Decimal = 0
            do {
                let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@ AND category.name == %@", startOfMonth as NSDate, endOfMonth as NSDate, category.name!)
                let transactions = try coreDataManager.viewContext.fetch(fetchRequest)
                for transaction in transactions {
                    amount += transaction.amount!.decimalValue
                }
                incomeDictionary[category] = amount
            } catch {
                fatalError("Error fetching transactions of the specific category: \(error.localizedDescription)")
            }
        }
    }
    
    func getAccumulatedBalance() {
        accumulatedBalance = totalIncomeMonth - totalExpenseMonth
    }
    
}
