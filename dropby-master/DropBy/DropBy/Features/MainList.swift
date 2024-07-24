import SwiftUI

struct MainList: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var dataStore: DataStore
    @State var newEventFormData = Event.FormData()
    @State var isPresentingEventForm: Bool = false
    @Binding var user: User
    @ObservedObject var userVM: UserEventViewModel
    
    var body: some View {
        NavigationStack{
            //            if let uniEvents = dataStore.publicEvents.filter({$0.event_university == user.university}){
            List($dataStore.publicEvents){ $event in
                if user.university == event.event_university{
                    NavigationLink(destination: EventDetail(event: $event, user: $user, userVM: userVM)){
                        EventRow(event: $event)
                    }
                }
            }
            //            List(dataStore.publicEvents.filter($user.university == $0.event_university)) {$event in
            //                NavigationLink(destination: EventDetail(event: $event, user: $user, userVM: userVM)){
            //                    EventRow(event: $event)
            //                }
            //            }
            //            .filter($user.university == $0.event_university)
            .navigationTitle("Events Near You")
            .foregroundColor(.purple)
            .toolbar {
                ToolbarItem(placement:
                        .navigationBarTrailing) {
                            Button("Create") {
                                isPresentingEventForm
                                    .toggle()
                            }
                        }
            }
            .sheet(isPresented: $isPresentingEventForm) {
                NavigationStack {
                    EventFormContainer(data: $newEventFormData)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    isPresentingEventForm = false
                                    newEventFormData = Event.FormData()
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Save") {
                                    let newEvent = Event.create(from: newEventFormData)
                                    userVM.user.hostedEvents.append(newEvent)
                                    dataStore.createEvent(newEvent)
                                    isPresentingEventForm = false
                                    newEventFormData = Event.FormData()
                                    
                                }
                            }
                        }
                    
                        .padding()
                }
            }
        }
        
    }}


struct EventRow: View {
    @Binding var event: Event
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Spacer()
                Text(event.type.rawValue)
                    .textCase(.uppercase)
                    .font(.system(size:12))
                Text(event.name)
                    .bold()
                    .font(.title3)
                HStack{
                    Text(event.date, style: .date)
                    Text(event.date, style: .time)
                }
                Spacer()
            }
            Spacer()
        }
    }
}
struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        MainList(user: Binding.constant( User.previewData[1]), userVM: UserEventViewModel(User.previewData[0]))
            .environmentObject(DataStore())
                .environmentObject(LocationService())
    }
}
