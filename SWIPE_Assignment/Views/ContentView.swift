//
//  ContentView.swift
//  SWIPE_Assignment
//
//  Created by Smit Patel on 17/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var queryString = ""
    @State private var showingAddProductView = false
    
    // Computed property to filter products based on the search query
    var filteredProducts: [ProductDetails] {
        if queryString.isEmpty
        {
            return viewModel.productDetails
        }
        else
        {
            return viewModel.productDetails.filter { product in
                product.productName.lowercased().hasPrefix(queryString.lowercased())// Filter products that start with the search query
            }
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            
            Group {
                
                ZStack{
                    
                    Color("creamDark").ignoresSafeArea() // Set the background color
                    
                    if viewModel.isLoading {
                        ProgressView("Loading...") // Display loading indicator if data is not yet fetched
                            .progressViewStyle(CircularProgressViewStyle())
                    }else {
                        ZStack(alignment: .bottomTrailing) {
                            
                            
                            
                            List {
                                ForEach(filteredProducts, id: \.self) { product in
                                    ProductView(product: product)
                                        .listRowSeparator(.hidden)
                                        .padding(.vertical, 8)
                                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                                        .listRowBackground(Color("creamDark")) // Set row background color
                                    
                                }
                            }
                            .listStyle(PlainListStyle())
                            
                            
                            
                            NavigationLink(destination: AddProductView(), isActive: $showingAddProductView) {
                                EmptyView()
                            }
                            
                            // Menu button to show AddProductView
                            
                            Menu{
                                Button(action: {
                                    showingAddProductView.toggle()
                                }) {
                                    Label("Add a Product", systemImage: "folder")
                                }
                                
                                
                            }label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color("brown"))
                                    .font(.system(size: 60))
                                
                            }
                            
                        }
                        
                    }
                    
                }
                .onAppear {
                    viewModel.fetch() // Fetch product details when the view appears
                }
                .navigationTitle("Product Details")
                .searchable(text: $queryString, prompt: "Search Products")// Add search bar
                .toolbarBackground(
                    
                    // 1
                    Color("creamDark"),
                    // 2
                    for: .navigationBar)
            }
        }
    }
}

#Preview {
    ContentView()
}
