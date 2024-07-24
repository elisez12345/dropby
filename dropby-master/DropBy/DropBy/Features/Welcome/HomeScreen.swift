//
//  HomeScreen.swift
//  DropBy
//
//  Created by Kassie Hamilton on 4/20/23.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var dataStore: DataStore
    @State var newUserFormData = User.FormData()
    @State var isPresentingWelcomeForm: Bool = true
    @ObservedObject var userVM: UserEventViewModel
//    @State var isPresentingWelcomeForm: Bool {
//        userId.isEmpty
//    }
    var body: some View {
        VStack{
            Spacer()
            Text("Welcome to DropBy!")
//            + Text(newUserFormData.firstName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            Spacer()
            Button("Logout") {
                isPresentingWelcomeForm = true
//                userVM.user.events.removeAll()
            }.foregroundColor(.white)
            Spacer()
                .frame(height: 50)
        }.background(Image("vert_bg").resizable().frame(width: 500,height:1000))
        .sheet(isPresented: $isPresentingWelcomeForm) {
            NavigationStack {
                Welcome(data: $newUserFormData)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                let newUser = User.create(from: newUserFormData)
                                dataStore.createUser(newUser)
                                isPresentingWelcomeForm = false
                                newUserFormData = User.FormData()
                            }
                        }
                    }
            }
            .padding()
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(userVM: UserEventViewModel(User.previewData[0]))
            .environmentObject(DataStore())
    }
}


//basic welcome message
//attach is presenting welcome form, have is presenting set to true, and then set to false on submit
//add tab container
