//
//  AddReceipt.swift
//  My Receipts (iOS)
//
//  Created by Robert Adamczyk on 23.04.21.
//

import SwiftUI

struct AddReceipt: View {
    @StateObject var viewModel = AddReceiptViewModel()
    @EnvironmentObject var homeViewModel: HomeViewModel
    @ObservedObject var coreData = CoreDataViewModel()
    @Binding var showPicker: Bool
    @Binding var takedPhotoData: Data?
    var body: some View {
        
        Form{
            Section{
                ZStack{
                    Color(UIColor.systemGroupedBackground)
                        
                    ImageRow()
                        .padding(5)
                }.listRowInsets(EdgeInsets())
            }
            Section(header: Text("Info")){
                TextField("Title", text: $viewModel.newReceipt.title)
                if let first = coreData.categories.first {
                    NavigationLink(destination:
                                    ChooseCategorieView(categories: coreData.categories)
                                        .environmentObject(viewModel)
                    ){
                        HStack{
                            Text("Categorie")
                            Spacer()
                            Text(viewModel.newReceipt.categorie?.title ?? "")
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                    }
                    .onAppear() {
                        if viewModel.newReceipt.categorie == nil {
                            viewModel.newReceipt.categorie = first
                        }
                    }
                    
                }
            }
            
            Section(header: Text("Dates")){
                DatePicker("Date of Purchase", selection: $viewModel.newReceipt.dateOfPurchase, displayedComponents: .date)
                DatePicker("End Of Warranty", selection: $viewModel.newReceipt.endOfWarranty, displayedComponents: .date)
            }
            
                        
        }
        .environmentObject(viewModel)
        .onAppear(){
            coreData.fetchCategories()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Done") {
                    if viewModel.checkTitleAndImage() {
                        viewModel.save()
                        homeViewModel.view = .list
                    }
                }
            }
        }
        .onChange(of: takedPhotoData){ _ in
            if let taked = takedPhotoData {
                viewModel.inputImage = UIImage(data: taked)
                viewModel.loadImage()
            }
        }
        .navigationTitle("New Receipt")
        .sheet(isPresented: $showPicker, onDismiss: viewModel.loadImage) {
            ImagePicker(image: $viewModel.inputImage)
        }
        
    }
}

struct AddReceipt_Previews: PreviewProvider {
    static var previews: some View {
        AddReceipt(showPicker: .constant(false), takedPhotoData: .constant(Data(count: 0)))
    }
}
