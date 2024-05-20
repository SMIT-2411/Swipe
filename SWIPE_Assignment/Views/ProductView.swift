//
//  ProductView.swift
//  SWIPE_Assignment
//
//  Created by Smit Patel on 18/05/24

import Foundation

import SwiftUI

struct ProductView: View {
    let product: ProductDetails
    let defaultImage = Image(systemName: "paperclip.badge.ellipsis")
    
    var body: some View {
        
        ZStack{
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("cream")) // Fill the rectangle with a background color
            
            
            HStack {
                if let imageURL = URL(string: product.image), product.image.count != 0 { //checking image url is empty or not
                    AsyncImage(url: imageURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                } else {
                    defaultImage // default image ,  clip symbol from SF symbol
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
                
                //Information abount the product name , type , price , tax ..
                VStack(alignment: .leading) {
                    Text(product.productName)
                        .font(.system(size: 22))
                    
                    Text(product.productType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack{
                        Text("Price: \(product.price,specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Tax: \(product.tax , specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.leading, 8)
                
                Spacer()
            }
            .padding()
            
        }
        
        
        
    }
}
