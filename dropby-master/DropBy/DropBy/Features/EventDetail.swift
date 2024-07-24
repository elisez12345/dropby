import SwiftUI
import UIKit

struct EventDetail: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var dataStore: DataStore
    @Binding var event: Event
    @Binding var user: User
    @ObservedObject var userVM: UserEventViewModel
    
//    var eventIDs = UserDefaults.standard.array(forKey: "eventIDs") as? [UUID] ?? []
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                    .frame(height: 50)
                Text(event.name)
                    .foregroundColor(.purple)
                    .font(.largeTitle)
                    .bold()
            }
            VStack{
                Spacer()
                    .frame(height:10)
                Group{
                    HStack{
                        Text(event.date, style: .date)
                        + Text(",")
                        Text(event.date, style: .time)
                    }.padding([.top, .leading, .trailing], 6.0)
                }
                Spacer()
                    .frame(height: 50)
                Text(event.description ?? "")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing], 20.0)
                Group{Spacer()
                        .frame(height: 50)
                    Text("Event Details:")
                    HStack{
                        Text("Event Type: ")
                        Text(event.type.rawValue)
                    }
                    
                    Text("Max. Number of Attendees: ")
                    + Text(String(event.max_attendees ?? 0) )
                    
                }.padding([.top, .leading, .trailing], 10.0)
                Spacer()
                Group{Text("If you have questions about this event, email: ").foregroundColor(.purple)
                    + Text(event.email)
                        .foregroundColor(.purple)
                }.padding([.top, .leading, .trailing], 6.0)
                Spacer()
                    .frame(height:50)
                //
                
            }.padding(2).background(Rectangle().foregroundColor(.white)).opacity(0.9).cornerRadius(30)}.frame(maxWidth: 300,alignment: .center)
            .background(Image("vert_bg").resizable().frame(width: 500,height:1000))
//        .foregroundColor(.purple)
        .toolbar {
            ToolbarItem(placement:
                    .navigationBarTrailing) {
                        
                        if userVM.user.events.filter({ $0.name == event.name }).isEmpty {
                            Button("Attending Event") {
                                userVM.user.events.append(event)
//                                user.addEvent(event: event)
//                                dataStore.addToAttendingList(event, user: user)
                            }
                        } else {
                            Button("No Longer Attending") {
                                if let index = userVM.user.events.firstIndex(where: { $0.id == event.id }) {
                                    userVM.user.events.remove(at: index)
//                                    user.addEvent(event: event)
                                }
                            }
                        }
            }
        }
    }
}
class UserEventViewModel: ObservableObject {
   @Published var user: User
   init(_ user: User) {
     self.user = user
   }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: Binding.constant( Event.previewData[0]), user: Binding.constant(User.previewData[0]), userVM: UserEventViewModel(User.previewData[0]))
            .environmentObject(DataStore()).environmentObject(LocationService())
    }
}
