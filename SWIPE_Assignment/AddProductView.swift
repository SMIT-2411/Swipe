//
//  ContentView.swift
//  SWIPE_Assignment
//
//  Created by Smit Patel on 17/05/24.
//

import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var productName = ""
    @State private var productType = ""
    @State private var price = ""
    @State private var tax = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isUploading = false // State to control the visibility of the progress bar
    
    let productTypes = ["Electronics", "Clothing", "Home Appliances", "Books", "Other"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("creamDark").ignoresSafeArea() // Set the background color
                
                Form {
                    Section(header: Text("Product Details")) {
                        Picker("Product Type", selection: $productType) {
                            ForEach(productTypes, id: \.self) {
                                Text($0)
                            }
                        }
                        .foregroundColor(Color("orange"))
                        
                        TextField("Product Name", text: $productName)
                        
                        TextField("Selling Price", text: $price)
                            .keyboardType(.decimalPad)
                        
                        TextField("Tax Rate", text: $tax)
                            .keyboardType(.decimalPad)
                    }
                    .foregroundColor(Color("brown"))
                    
                    Section(header: Text("Product Image")) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Rectangle())
                        } else {
                            Button("Select Image") {
                                showingImagePicker = true
                            }.foregroundColor(Color("orange"))
                        }
                    }
                    .foregroundColor(Color("brown"))
                    
                    Button {
                        submitProduct()
                    } label: {
                        HStack {
                            Spacer()
                            Text("SUBMIT")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Add Product")
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Feedback"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
                if isUploading {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        ProgressView("Uploading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1)
                    }
                }
            }
        }
    }
    
    private func submitProduct() {
        guard !productType.isEmpty else {
            showAlert(message: "Please select a product type.")
            return
        }
        
        guard !productName.isEmpty else {
            showAlert(message: "Please enter a product name.")
            return
        }
        
        guard let priceValue = Double(price), priceValue >= 0 else {
            showAlert(message: "Please enter a valid selling price.")
            return
        }
        
        guard let taxValue = Double(tax), taxValue >= 0 else {
            showAlert(message: "Please enter a valid tax rate.")
            return
        }
        
        isUploading = true
        
        // Prepare the request
        var request = URLRequest(url: URL(string: "https://app.getswipe.in/api/public/add")!)
        request.httpMethod = "POST"
        
        // Create form data
        var body = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Add parameters
        body.append(convertFormField(named: "product_name", value: productName, using: boundary))
        body.append(convertFormField(named: "product_type", value: productType, using: boundary))
        body.append(convertFormField(named: "price", value: price, using: boundary))
        body.append(convertFormField(named: "tax", value: tax, using: boundary))
        
        // Add image if available
        if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            body.append(convertFileData(fieldName: "files[]",
                                        fileName: "image.jpg",
                                        mimeType: "image/jpeg",
                                        fileData: imageData,
                                        using: boundary))
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isUploading = false
                if let error = error {
                    showAlert(message: "Error: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    showAlert(message: "Product added successfully.")
                } else {
                    showAlert(message: "Failed to add product.")
                }
            }
        }.resume()
    }
    
    private func convertFormField(named name: String, value: String, using boundary: String) -> Data {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
        fieldString += "\(value)\r\n"
        return fieldString.data(using: .utf8)!
    }
    
    private func convertFileData(fieldName: String,
                                 fileName: String,
                                 mimeType: String,
                                 fileData: Data,
                                 using boundary: String) -> Data {
        var fileDataString = "--\(boundary)\r\n"
        fileDataString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        fileDataString += "Content-Type: \(mimeType)\r\n\r\n"
        var data = Data()
        data.append(fileDataString.data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        return data
    }
    
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            alertMessage = message
            showingAlert = true
        }
    }
}

#Preview {
    AddProductView()
}
