//
//  ViewModel.swift
//  SWIPE_Assignment
//
//  Created by Smit Patel on 17/05/24.
//

import Foundation


struct ProductDetails: Hashable, Codable {
    var image: String
    let price: Double // Assuming price can be a decimal number
    let productName: String // Changed to camelCase as per Swift convention
    let productType: String // Changed to camelCase as per Swift convention
    let tax: Double // Assuming tax can be a decimal number
}

class ViewModel: ObservableObject {
    @Published var productDetails: [ProductDetails] = []
    
    func fetch() {
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // Convert snake_case to camelCase
                let productDetails = try decoder.decode([ProductDetails].self, from: data)
                DispatchQueue.main.async {
                    self?.productDetails = productDetails
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
