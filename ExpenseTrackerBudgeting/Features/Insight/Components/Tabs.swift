//
//  Tabs.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 11/05/23.
//

import SwiftUI

struct Tabs: View {
    var fixed = true
    var tabs: [Tab]
    @Binding var selectedTab: Int
    var geoWidth: CGFloat {
        return CGFloat(tabs.count * 160)
    }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            Button(action: {
                                selectedTab = row
                            }, label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        // Text
                                        Text(tabs[row].title)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 15))
                                    }
                                    .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 52)
                                    .background(accentsColor)
                                    // Bar Indicator
                                    Rectangle().fill(selectedTab == row ? accentsColor : Color.clear)
                                        .frame(height: 2)
                                        .animation(.easeInOut, value: selectedTab)
                                }.fixedSize()
                            })
                            .accentColor(Color.white)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .frame(height: 55)
        .onAppear(perform: {
            UIScrollView.appearance().bounces = fixed ? false : true
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
    }
}
//struct Tabs_Previews: PreviewProvider {
//    static var previews: some View {
//        Tabs(fixed: true,
//             tabs: [.init(icon: Image(systemName: ""), title: "01/2023"),
//                    .init(icon: Image(systemName: ""), title: "02/2023"),
//                    .init(icon: Image(systemName: ""), title: "03/2023"),
//                    .init(icon: Image(systemName: ""), title: "04/2023"),
//                    .init(icon: Image(systemName: ""), title: "05/2023"),
//                    .init(icon: Image(systemName: ""), title: "06/2023"),
//                    .init(icon: Image(systemName: ""), title: "07/2023"),
//                    .init(icon: Image(systemName: ""), title: "08/2023"),
//                    .init(icon: Image(systemName: ""), title: "09/2023"),
//                    .init(icon: Image(systemName: ""), title: "10/2023"),
//                    .init(icon: Image(systemName: ""), title: "THIS MONTH"),
//                    .init(icon: Image(systemName: ""), title: "LAST MONTH"),
//                    
//             ],
//             selectedTab: .constant(0))
//    }
//}
