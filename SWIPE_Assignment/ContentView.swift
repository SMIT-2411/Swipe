//
//  ContentView.swift
//  SWIPE_Assignment
//
//  Created by Smit Patel on 17/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    
    var body: some View {
        List {
            ForEach(viewModel.productDetails , id: \.self) { product in
                
                VStack {
                    Text(product.productName)
                }
                .padding()
                
            }
        }.onAppear{
            viewModel.fetch()
        }
        
    }
}

#Preview {
    ContentView()
}
