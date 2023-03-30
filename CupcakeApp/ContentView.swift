//
//  ContentView.swift
//  CupcakeApp
//
//  Created by Danjuma Nasiru on 28/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var order : Order
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Picker("Select your cake type", selection: $order.type){
                        ForEach(Order.types.indices){
                            Text(Order.types[$0])
                        }
                    }.pickerStyle(.automatic)
                    
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section{
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())
                    
                    if order.specialRequestEnabled{
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                    
                }
                
                Section{
                    NavigationLink{
                        AddressView(order: _order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }.navigationTitle("Cupcake Corner").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        ContentView()
            .environmentObject(order)
    }
}
