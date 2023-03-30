//
//  CheckoutView.swift
//  CupcakeApp
//
//  Created by Danjuma Nasiru on 28/01/2023.
//

//reqres.in; api for testing. It basically acts as a server that sends back to us as response whatever we send to it, so it basically just mirrors our request data
import SwiftUI

struct CheckoutView: View {
    
    @EnvironmentObject var networkMonitor : NetworkMonitor
    
    @State private var confirmationTitle = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmationAlert = false
    
    @State private var networkAlertTitle = ""
    @State private var netWorkAlertMsg = "jkjl"
    @State private var showNetworkAlert = false
    
    @State private var showProgressView = false
    
    @EnvironmentObject var order : Order
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .accessibilityHidden(true)
                } placeholder: {
                    ProgressView()
                        .accessibilityHidden(true)
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order", action: {
                    Task{
                        await placeOrder()
                    }
                })
                    .padding()
            }.overlay{
                if showProgressView{
                    ProgressView().offset(x: 0, y: 200)
                }else{
                    
                }
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
//        .onChange(of: networkMonitor.isConnected, perform: {connection in
//            showNetworkAlert = connection == false
//            networkAlertTitle = "Offline!"
//            netWorkAlertMsg = "Kindly check your internet connection"
//        })
        .alert(confirmationTitle, isPresented: $showingConfirmationAlert) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
//        .sheet(isPresented: $showNetworkAlert, content: {
//            Text(networkAlertTitle).font(.largeTitle)
//            Text(netWorkAlertMsg).font(.caption)
//        })
    }
    
    func placeOrder() async {
        
        showProgressView = true
        
        guard let encoded = try? JSONEncoder().encode(order) else{
            print("encoding failed")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do{
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            confirmationTitle = "Thank You!"
            confirmationMessage = "Your order for \(decodedOrder.quantity)*\(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showProgressView = false
            showingConfirmationAlert = true
        }catch {
            if !networkMonitor.isConnected{
                confirmationTitle = "Bad Network"
                confirmationMessage = "kindly check your internet connection"
                showingConfirmationAlert = true
                showProgressView = false
            }else{
                confirmationTitle = "Failed!"
                confirmationMessage = "Somthing went wrong! Try again!"
                showingConfirmationAlert = true
                showProgressView = false
                print("Checkout failed.")
            }
            
        }
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        CheckoutView()
            .environmentObject(order)
    }
}
