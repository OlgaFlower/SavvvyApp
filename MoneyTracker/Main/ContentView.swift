//
//  ContentView.swift
//  MoneyTracker
//
//  Created by Olha Bereziuk on 15.03.24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = .tabBarInactive
    }
    
    var body: some View {
        TabView {
            ///Home
            NavigationStack {
                HomeView()
                    .navigationTitle("TODAY'S BUDGET")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label(
                    title: {},
                    icon: {
                        self.makeTabBarIcon("expenses")
                    }
                )
            }
            
            ///Test
            NavigationStack {
                BankAccountsView(viewModel: BankAccountsViewModel())
            }
            .tabItem {
                Label(
                    title: {  },
                    icon: {
                        self.makeTabBarIcon("wallet")
                    }
                )
            }
            
            ///Test
            NavigationStack {
                TestView2()
            }
            .tabItem {
                Label(
                    title: {  },
                    icon: {
                        self.makeTabBarIcon("chart")
                    }
                )
            }
        }
        .accentColor(.white)
    }
    
    // MARK: - Views
    
    private func makeTabBarIcon(_ iconName: String) -> some View {
        Image(iconName)
            .renderingMode(.template)
    }
}

#Preview {
    return ContentView()
}
