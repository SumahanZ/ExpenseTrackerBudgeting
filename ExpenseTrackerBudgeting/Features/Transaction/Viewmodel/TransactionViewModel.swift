//
//  TransactionViewModel.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 09/05/23.
//

import Foundation
import CoreData

class TransactionViewModel: ObservableObject {
    let coreDataManager = CoreDataManager()
    @Published var transactions: [Transaction] = []
    @Published var balance: Balance?
    @Published var groupedTransactions: [(String, [Transaction])] = []
    
    func fetchTransactions() {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            transactions = try coreDataManager.viewContext.fetch(fetchRequest)
            groupedTransactions = groupTransactionsByMonth(transactions)!
        } catch let error {
            print("Error fetching transactions \(error.localizedDescription)")
        }
    }
    
    init() {
        fetchTransactions()
    }
    
    func groupTransactionsByMonth(_ transactions: [Transaction]) -> [(String, [Transaction])]? {
        var dictionary: [String: [Transaction]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        for transaction in transactions {
            let monthString = dateFormatter.string(from: transaction.date!)
            if var monthTransactions = dictionary[monthString] {
                monthTransactions.append(transaction)
                dictionary[monthString] = monthTransactions
            } else {
                dictionary[monthString] = [transaction]
            }
        }
        let sortedKeys = dictionary.keys.sorted(by: { dateFormatter.date(from: $0)! > dateFormatter.date(from: $1)! })
        return sortedKeys.map { ($0, dictionary[$0]!) }
    }
    
    func addTransaction(name: String, amount: Decimal, date: Date, category: Category) {
        let newTransaction = Transaction(context: coreDataManager.viewContext)
        newTransaction.name = name
        newTransaction.amount = (amount) as NSDecimalNumber
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = calendar.component(.day, from: date)
        let date = calendar.date(from: dateComponents)
        newTransaction.date = date
        newTransaction.category = category
        coreDataManager.saveContext()
    }
    
    //TODO: Search & Delete
    
    func searchTransactions(searchQuery: String) {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchQuery)
        
        do {
            transactions = try coreDataManager.viewContext.fetch(fetchRequest)
            groupedTransactions = groupTransactionsByMonth(transactions)!
        } catch let error {
            print("Error fetching searching transactions \(error.localizedDescription)")
        }
    }
    
    func deleteTransaction(transaction: Transaction) {
        let context = coreDataManager.viewContext
        context.delete(transaction)
        coreDataManager.saveContext()
        fetchTransactions()
    }
}

