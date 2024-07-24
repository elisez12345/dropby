import SwiftUI
import MapKit

struct EventFormContainer: View {
    @EnvironmentObject var locationService: LocationService
    @State var confirmedLocation: SelectedLocation?
    @Binding var data: Event.FormData
    
    var body: some View {
        switch locationService.status {
        case .idle: EventForm(data: $data, confirmedLocation: $confirmedLocation)
        default: LocationMapSearch(confirmedLocation: $confirmedLocation)
        }
    }
}

struct EventForm: View {
    @Binding var data: Event.FormData
    @EnvironmentObject var locationService: LocationService
    @Binding var confirmedLocation: SelectedLocation?
    
    //    var locationCoordinate: CLLocationCoordinate2D? {
    //            return confirmedLocation?.coordinate
    //        }
    @State private var searchTerm: String = ""
    @StateObject var dataLoader = DataLoader()

    var filteredUnis: [String] {
        dataLoader.universityNames.filter {
                searchTerm.isEmpty ? true : $0.lowercased().contains(searchTerm.lowercased())
            }
        }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Create an Event to Share with Others!").bold().font(.largeTitle).padding().foregroundColor(.purple)
            Form {
                TextFieldWithLabel(label: "Event Name", text: $data.name, prompt: "Enter a name for your event!")
                TextFieldWithLabel(label: "Email of Host", text: $data.email, prompt: "Enter your email")
                    .autocapitalization(.none)
                DatePicker("When?", selection: $data.date, displayedComponents: [.date, .hourAndMinute]).foregroundColor(.purple)
                TextFieldWithLabel(label: "Description", text: $data.description, prompt: "What's going on?")
                VStack(alignment: .leading) {
                    Text("Max Number of Attendees")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.purple)
                    TextField("Enter your attendee capacity", value: $data.max_attendees, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                Picker(selection: $data.type, label: Text("Event Category")) {
                    ForEach(Event.EventType.allCases) {
                        type in Text(type.rawValue)
                    }
                }.pickerStyle(.menu)
                    .accentColor(.purple)
                    .foregroundColor(.purple)
                Picker(selection: $data.event_university, label: Text("University")) {
                    SearchBar(text: $searchTerm, placeholder: "Search Universities")
                                ForEach(filteredUnis, id: \.self){ uni in
                                    Text(uni)
                                }
                            }
                .pickerStyle(.navigationLink)
                .accentColor(.purple)
                .foregroundColor(.purple)
                HStack {
                    TextField("Search Location", text: $locationService.searchFragment)
                    Button(action: { locationService.clearSearchFragment() }, label: {
                        //                      Text("Search").foregroundColor(.purple)
                        Image(systemName: "x.circle").foregroundColor(.gray)
                    })
                }.onReceive(confirmedLocation.publisher) { location in
                    data.location = location.coordinate
                }
                if let location = confirmedLocation {
                    Text(location.name)
                }
            }
        }
//        .onDisappear {
//            self.locationService.status = .idle
//        }
    }
}



//struct LocationSearchWidget: View {
//  @EnvironmentObject var locationService: LocationService
//
//  var body: some View {
//    HStack {
//      TextField("Search", text: $locationService.searchFragment)
//      Button(action: { locationService.clearSearchFragment() }, label: {
//        Image(systemName: "x.circle").foregroundColor(.gray)
//      })
//    }
//    .padding(10)
//  }
//}

struct TextFieldWithLabel: View {
    let label: String
    @Binding var text: String
    var prompt: String? = nil
    var body: some View {
        VStack(alignment: .leading) {
          Text(label)
            .bold()
            .font(.caption)
            .foregroundColor(.purple)
          TextField(label, text: $text, prompt: prompt != nil ? Text(prompt!) : nil)
            .padding(.bottom, 20)
        }
    }
}

struct EventForm_Previews: PreviewProvider {
    static var previews: some View {
        EventFormContainer(data:
                            Binding.constant(Event.previewData[0].dataForForm)).environmentObject(LocationService())
    }
}
