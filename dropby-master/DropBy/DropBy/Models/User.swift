//
//  User.swift
//  DropBy
//
//  Created by Kassie Hamilton on 4/5/23.
//

import Foundation
struct User: Equatable, Hashable{
    var email: String
    var firstName: String
    var lastName: String
    var userId: String
    var university: String
    var events: [Event] = []
    var hostedEvents: [Event] = []
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
    mutating func addEvent(event: Event) {
        events.append(event)
    }
    func hash(into hasher: inout Hasher) {
            hasher.combine(email)
        }

  struct FormData {
//    var id: String = ""
//    var title: String = ""
//    var author: String = ""
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var userId: String = ""
    var university: String = ""
  }

  var dataForForm: FormData {
    FormData(
        email: email,
        firstName: firstName,
        lastName: lastName,
        userId: userId,
        university: university
    )
  }

  static func create(from formData: FormData) -> User {
//    Book(id: formData.id, title: formData.title, author: formData.author)
      User(email: formData.email, firstName: formData.firstName, lastName: formData.lastName, userId: formData.userId, university: formData.university)
  }
}

extension User{
    static let previewData = [
        User(email: "kassandra.hamilton@duke.edu", firstName: "Kassie", lastName: "Hamilton", userId: "kassiehamilton", university: "Duke University"),
        User(email: "elise.zhang@harvard.edu", firstName: "Elise", lastName: "Zhang", userId: "elisezhang", university: "Harvard University")]
}
