//
//  AddressView.swift
//  CupcakeApp
//
//  Created by Danjuma Nasiru on 28/01/2023.
//

import SwiftUI

struct AddressView: View {
    //testung for git
    @EnvironmentObject var order : Order
    @State private var showTestAlert = false
    var body: some View {
        Form{
            Section {
                TextField("Name", text: $order.name).disableAutocorrection(true)
                TextField("Street Address", text: $order.streetAddress).disableAutocorrection(true)
                TextField("City", text: $order.city).disableAutocorrection(true)
                TextField("Zip", text: $order.zip).disableAutocorrection(true)
                if order.hasValidAddress{
                    
                }else{
                    Text(order.addressErrorMsg)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .listRowBackground(Color.clear)
                }
            }
            
            Section{
                NavigationLink {
                    CheckoutView(order: _order)
                } label: {
                    Text("Check out")
                }
                .disabled(!order.hasValidAddress)
            }
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: order.city, perform: {cityText in
            showTestAlert = order.city.lowercased() == "lagos"
        })
        .alert("not lagos pleaseee", isPresented: $showTestAlert, actions: {})
    }
}

struct AddressView_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        NavigationView{
        AddressView()
                .environmentObject(order)
        }
    }
}
