import SwiftUI

struct TabViewExampleView: View {
    @ObservedObject var overviewViewModel: OverviewViewModel
    @ObservedObject var transactionViewModel: TransactionViewModel
    @State private var selectedTabIndex = 0
    @State private var oldSelectedTabIndex = 0
    @State private var showModal = false
    @State var submitted = false
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            OverviewView(overviewViewModel: overviewViewModel, transactionViewModel: transactionViewModel)
                .tabItem {
                    Label("Overview", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)
            
            Text("Tab 2")
                .tabItem {
                    Label("Add Transaction", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            InsightView()
                .tabItem {
                    Label("Insight", systemImage: "chart.pie.fill")
                }
                .tag(2)
        }
        .tint(accentsColor)
        //change background of tabbar
        .onAppear() {
            UITabBar.appearance().unselectedItemTintColor = UIColor.black.withAlphaComponent(0.6)
            UITabBar.appearance().backgroundColor = .white
        }
        .onChange(of: submitted) { _ in
            if submitted {// Hide the modal
                selectedTabIndex = 0 // Switch to the first tab
                showModal = false
                submitted = false
            }
        }
        .onChange(of: selectedTabIndex) { newValue in
            withAnimation(.easeInOut) {
                if newValue == 1 {
                    showModal = true
                    selectedTabIndex = oldSelectedTabIndex
                } else if (showModal == false) {
                    oldSelectedTabIndex = newValue
                }
            }
        }
        .sheet(isPresented: $showModal, onDismiss: {
            overviewViewModel.fetchRecentTransactions()
            transactionViewModel.fetchTransactions()
            overviewViewModel.fetchTotalSpentToday()
            overviewViewModel.fetchTotalSpentWeek()
            overviewViewModel.getPercentageDifferenceWeek()
            overviewViewModel.getPercentageDifferenceDay()
            overviewViewModel.fetchTotalSpentMonth()
        }, content: {
            AddTransactionModal(overviewViewModel: overviewViewModel, submitted: $submitted)
        })
        
    }
}

//struct TabViewExampleView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabViewExampleView()
//    }
//}
