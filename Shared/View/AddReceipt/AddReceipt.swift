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
    @StateObject var coreData = CoreDataViewModel()
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
                if !coreData.categories.isEmpty {
                    NavigationLink(destination:
                                    ChooseCategorieView(categories: coreData.categories)
                                        .environmentObject(viewModel)
                                        .environmentObject(homeViewModel)
                    ){
                        HStack{
                            Text("Categorie")
                            Spacer()
                            Text(viewModel.newReceipt.categorie?.title ?? "")
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                    }
                    
                }
                NavigationLink(destination: WarrantyView()
                                .environmentObject(viewModel)
                                .environmentObject(homeViewModel)
                ){
                    HStack{
                        Text("Guarantee")
                        Spacer()
                        Text(viewModel.warranty ? "\(viewModel.newReceipt.endOfWarranty, style: .date)" : "")
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                }
            }
            
            Section(header: Text("Purchase")){
                DatePicker("Date of Purchase", selection: $viewModel.newReceipt.dateOfPurchase, displayedComponents: .date)
                    .accentColor(.blue)
            }
            
                        
        }
        .padding(.top, 50)
        .navigationBarHidden(true)
        .overlay(
            NavigationTopBar(title: homeViewModel.editReceipt == nil ? "New Receipt".localized() : "Edit Receipt".localized(), backButton: false)
                .overlay(
                    Button(action:{
                        if viewModel.checkTitleAndImage() {
                            if homeViewModel.editReceipt == nil {
                                viewModel.save()
                            }else {
                                viewModel.edit(editReceipt: homeViewModel.editReceipt)
                            }
                            
                            homeViewModel.view = .list
                        }
                    }){
                        Text("Done")
                            .font(.title2)
                            .padding(20)
                    }
                    ,alignment: .bottomTrailing
                )
                .ignoresSafeArea()
                
            
            , alignment: .top)
        .environmentObject(viewModel)
        .onAppear(){
            coreData.fetchCategories()
            viewModel.loadReceipt(editReceipt: homeViewModel.editReceipt)
        }
        .onChange(of: takedPhotoData){ _ in
            if let taked = takedPhotoData {
                viewModel.inputImage = UIImage(data: taked)
                viewModel.loadImage()
            }
        }
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
