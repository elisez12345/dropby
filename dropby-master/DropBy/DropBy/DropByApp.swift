//
//  DropByApp.swift
//  DropBy
//
//  Created by Kassie Hamilton on 4/4/23.
//

import SwiftUI

@main
struct DropByApp: App {
    @StateObject var locationService = LocationService()
    @StateObject var dataStore = DataStore()
    
    var body: some Scene {
        WindowGroup {
//            MainList(user: Binding.constant( User.previewData[0]))
//                .environmentObject(DataStore())
//                    .environmentObject(LocationService())
            TabContainer(user: Binding.constant( User.previewData[0]), userVM: UserEventViewModel(User.previewData[0]), currentUser: User.previewData[0])
                .environmentObject(DataStore())
                .environmentObject(LocationService())
        }
    }
}
