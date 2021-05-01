//
//  NotificationsSettings.swift
//  My Receipts (iOS)
//
//  Created by Robert Adamczyk on 28.04.21.
//

import SwiftUI

struct NotificationsSettings: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    @AppStorage("daysNotification") var daysNotification = 7
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var receipts: FetchedResults<Receipts>
    
    var body: some View {
        Form{
            if !viewModel.notificationAllowed {
                Section(header: Text("Info")){
                    VStack(spacing: 10){
                        HStack{
                            Spacer()
                            Text("❗️❗️❗️")
                            Spacer()
                        }
                        Text("You haven't allowed this app to show notifications.")
                        
                        Text("You can enable this functionality in IPhone:")
                        Text("Settings → My Receipts → Notifications → Allow")
                    }.font(.footnote)
                }
            }
            
            Section(header: Text("Notification"), footer: Text("The alert will come \(daysNotification) days before the warranty expires.")){
                Picker("Number of days", selection: $daysNotification) {
                    ForEach(0..<51) { i in
                        Text("\(i)")
                    }
                }
            }
        
            
        }
        .navigationBarTitle("Notifications", displayMode: .inline)
        .onChange(of: daysNotification) { _ in
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            viewModel.checkNotifications(array: receipts)
        }
    }
}

struct NotificationsSettings_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettings()
            .environmentObject(SettingsViewModel())
    }
}
