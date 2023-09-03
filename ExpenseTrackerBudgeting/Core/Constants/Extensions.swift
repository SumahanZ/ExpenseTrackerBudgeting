//
//  Extensions.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 12/05/23.
//

import Foundation
import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
//use extension on View to simplify design
