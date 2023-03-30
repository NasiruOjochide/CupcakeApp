//
//  CupcakeAppApp.swift
//  CupcakeApp
//
//  Created by Danjuma Nasiru on 28/01/2023.
//

import SwiftUI

@main
struct CupcakeAppApp: App {
    
    @StateObject var order = Order()
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
                .environmentObject(order)
        }
    }
}
