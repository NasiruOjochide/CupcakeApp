//
//  NetWorkMonitor.swift
//  CupcakeApp
//
//  Created by Danjuma Nasiru on 30/01/2023.
//

import Foundation
import Network

class NetworkMonitor : ObservableObject{
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    @Published var isConnected = false
//    var isConnected = false{
//        willSet{
//            Task{
//                await MainActor.run{
//                    self.objectWillChange.send()
//                }
//            }
//        }
//    }
    
    init(){
        networkMonitor.pathUpdateHandler = {path in
            //use this below with published wrapper on isConnection
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied ? true : false
                        }
            
            //use this when not using published on isConnected
//            self.isConnected = path.status == .satisfied
//            Task{
//                await MainActor.run{
//                    self.objectWillChange.send()
//                }
//            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
