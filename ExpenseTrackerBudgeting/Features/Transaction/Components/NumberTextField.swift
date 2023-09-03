import SwiftUI

struct NumberTextField: View {
    @Binding var value: Double
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en-US")
        return formatter
    }()
    
    var body: some View {
        TextField("\(value)", value: $value, formatter: formatter)
            .frame(width: 150)
            .multilineTextAlignment(.trailing)
            .keyboardType(.decimalPad)
            .padding(.horizontal, 0)
            .ignoresSafeArea(.keyboard)
    }
}
