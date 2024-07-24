//
//  Event.swift
//  DropBy
//
//  Created by Kassie Hamilton on 4/5/23.
//

import Foundation
import CoreLocation
import MapKit


struct Event: Identifiable {
    var id = UUID()
    var name: String
    var email: String //figure out a way to get host to be from the username of whoever is making the event
    var date: Date = Date()
    var description: String?
    var max_attendees: Int?
    var type: EventType
    var location: CLLocationCoordinate2D
    var event_university: String
    
    enum EventType: String, CaseIterable, Identifiable {
        var id: Self { self }
        case social
        case academic
        case athletic
        case professional
        case arts
        case other
    }

    struct FormData {
        var name: String = ""
        var email: String = ""
        var date: Date = Date.now
        var description: String = ""
        var max_attendees: Int = 100
        var type: EventType = .social
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 36.001312, longitude: -78.944745)
        var event_university: String = ""
        //get host from username/name of user??
    }
    var dataForForm: FormData {
        FormData(
        name: name,
        date: date,
        description: description ?? "",
        type: type,
        location: location,
        event_university: event_university
        )
    }
    static func create(from formData: FormData) -> Event {
//        Book(id: formData.id, title: formData.title, author: formData.author)
        Event(name: formData.name, email: formData.email, date: formData.date, description: formData.description, type: formData.type, location: formData.location, event_university: formData.event_university)
      }
}

extension Event {
  static let previewData = [
    Event(name: "CS207 Study Hall", email: "kmh156@duke.edu", date: Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 23, hour:10))!, description: "Join us for a study session for CS207 in Gross Hall", max_attendees: 35, type: .academic, location: CLLocationCoordinate2D(latitude: 36.001312, longitude: -78.944745), event_university: "Duke University"),
    Event(name: "Flunch with Dr. Phillips", email: "elise.a.zhang@duke.edu",date: Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 27, hour:12))!, description: "Come eat Panera with Dr. Phillips and your classmates", max_attendees: 12, type: .social, location: CLLocationCoordinate2D(latitude: 36.000720, longitude: -78.939482), event_university: "Duke University"),
    Event(name: "LDOC Concert", email: "kmh156@duke.edu", date: Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 26, hour:20))!, description: "See NLE Choppa and other performers on the quad for LDOC", max_attendees: 600, type: .social, location: CLLocationCoordinate2D(latitude: 36.00042985230216, longitude: -78.93891366458439), event_university: "Duke University"),
    Event(name: "New Student Orientation", email: "johnny.appleseed@harvard.edu",date: Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 1, hour:11))!,
          description: "Learn everything you need to know about being a new student at our university!", max_attendees: 100, type: .academic,
          location: CLLocationCoordinate2D(latitude: 42.37449830975006,  longitude:-71.11743257967602), event_university: "Harvard University"),
    Event(name: "Career Fair",email: "johnny.appleseed@harvard.edu",date: Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 26, hour:15))!,
          description: "Meet with employers and explore career opportunities!", max_attendees: 200, type: .professional, location: CLLocationCoordinate2D(latitude: 42.37716138435686,   longitude:-71.11660645933247), event_university: "Harvard University")
  ]
}
