import SwiftUI

struct AttendingList: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var user: User
    @ObservedObject var userVM: UserEventViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Keep Track of Your Attendance")
                    .fontWeight(.bold)
                    .font(.title2)
                //                    .padding()
                    .accentColor(.purple)
                    .foregroundColor(.purple)
                List($userVM.user.events) {$event in
                    let _ = print("user.events")
                    let _ = print(user.events)
                    let _ = print("user.events")
                    let _ = print(userVM.user.events)
                    if userVM.user.events.contains(where: {$0.id == $event.id}){
                        NavigationLink(destination: EventDetail(event: $event, user: $user, userVM: userVM)){
                            EventRow(event: $event)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        if let index = userVM.user.events.firstIndex(where: { $0.id == event.id }) {
                                            userVM.user.events.remove(at: index)
                                        }
                                    } label: { Label("Delete", systemImage: "trash") }
                                    
                                }
                        }
                    }
                }
            }
        }
    }
}

struct AttendingList_Previews: PreviewProvider {
    static var previews: some View {
        AttendingList(user: Binding.constant( User.previewData[0]), userVM: UserEventViewModel(User.previewData[0])).environmentObject(DataStore())
    }
}
