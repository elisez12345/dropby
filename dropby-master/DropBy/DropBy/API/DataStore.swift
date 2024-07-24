//
//  DataStore.swift
//  DropBy
//
//  Created by Kassie Hamilton on 4/5/23.
//

import Foundation

class DataStore: ObservableObject {
    @Published var UserList: [User] = User.previewData
    @Published var publicEvents: [Event] = Event.previewData
    @Published var personalEvents: [Event] = []
    @Published var attendingDict = [User: [Event]]()
//    @Published var myEvents: [Event] = []
    
    func createUser(_ user: User) {
        UserList.append(user)
    }
    func getCurrentUser() -> User {
        return UserList.last!
    }
    
    func addToAttendingList(_ event: Event, user: User) {
        if var original = attendingDict[user] {
            original.append(event)
            attendingDict[user] = original
        } else {
            attendingDict[user] = [event]
        }
    }

    func deleteFromPublicList(_ event: Event) {
        if let index = publicEvents.firstIndex(where: { $0.id == event.id }) {
            publicEvents.remove(at: index)
        }
    }
    func deleteFromPersonalList(_ event: Event) {
        if let index = personalEvents.firstIndex(where: { $0.id == event.id}) {
            personalEvents.remove(at: index)
        }
    }

    func createEvent(_ event: Event) {
        publicEvents.append(event)
//        personalEvents.append(event)
    }
}


// figure out if you need more than these functions!!!
// if you want poeple to be able to delete public events that they made, you have to have a way for them to verify that they are the creator or have that information saved
