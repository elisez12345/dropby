import SwiftUI

struct PersonalList: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var user: User
    @ObservedObject var userVM: UserEventViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Manage your Events")
                    .fontWeight(.bold)
                    .font(.title2)
                    .padding()
                    .accentColor(.purple)
                    .foregroundColor(.purple)
                List($userVM.user.hostedEvents) {$event in
                    if user.email == event.email{
                        NavigationLink(destination: EventDetail(event: $event, user: $user, userVM: userVM)){
                            EventRow(event: $event)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        dataStore.deleteFromPublicList(event)
                                        //                                    dataStore.deleteFromPersonalList(event)
                                        if let index = userVM.user.events.firstIndex(where: { $0.id == event.id }) {
                                            userVM.user.events.remove(at: index)
                                        }
                                        if let index = userVM.user.hostedEvents.firstIndex(where: { $0.id == event.id }) {
                                            userVM.user.hostedEvents.remove(at: index)
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


struct PersonalList_Previews: PreviewProvider {
    static var previews: some View {
        PersonalList(user: Binding.constant( User.previewData[0]), userVM: UserEventViewModel(User.previewData[0])).environmentObject(DataStore())
    }
}
