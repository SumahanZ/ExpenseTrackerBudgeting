//
//  CoreDataConstants.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 09/05/23.
//

import Foundation

struct CoreDataConstants {
    let coreDataManager: CoreDataManager
    
    var categoriesFilled: [Category] {
        let category1 = Category(context: coreDataManager.viewContext)
        category1.name = "Food & Groceries"
        category1.type = "Expense"
        category1.categoryIcon = "fork.knife"
        
        let category2 = Category(context: coreDataManager.viewContext)
        category2.name = "Housing"
        category2.type = "Expense"
        category2.categoryIcon = "house.fill"
        
        let category5 = Category(context: coreDataManager.viewContext)
        category5.name = "Transportation"
        category5.type = "Expense"
        category5.categoryIcon = "car.fill"
        
        let category6 = Category(context: coreDataManager.viewContext)
        category6.name = "Personal Care"
        category6.type = "Expense"
        category6.categoryIcon = "heart.fill"
        
        let category7 = Category(context: coreDataManager.viewContext)
        category7.name = "Travel"
        category7.type = "Expense"
        category7.categoryIcon = "airplane.departure"
        
        let category8 = Category(context: coreDataManager.viewContext)
        category8.name = "Education"
        category8.type = "Expense"
        category8.categoryIcon = "book.fill"
        
        let category9 = Category(context: coreDataManager.viewContext)
        category9.name = "Debt"
        category9.type = "Expense"
        category9.categoryIcon = "chart.line.downtrend.xyaxis.circle.fill"
        
        let category3 = Category(context: coreDataManager.viewContext)
        category3.name = "Investment"
        category3.type = "Income"
        category3.categoryIcon = "chart.line.uptrend.xyaxis"
        
        let category10 = Category(context: coreDataManager.viewContext)
        category10.name = "Self-Employment"
        category10.type = "Income"
        category10.categoryIcon = "person.text.rectangle.fill"
        
        let category11 = Category(context: coreDataManager.viewContext)
        category11.name = "Direct Transfer"
        category11.type = "Income"
        category11.categoryIcon = "arrow.triangle.swap"
        
        let category4 = Category(context: coreDataManager.viewContext)
        category4.name = "Salary"
        category4.type = "Income"
        category4.categoryIcon = "dollarsign"
        
        return [category9, category8, category1, category2, category6, category5, category7, category11, category3, category4, category10]
    }
}
