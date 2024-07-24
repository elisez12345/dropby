import SwiftUI

struct TabContainer: View {
  @StateObject var locationService = LocationService()
    @EnvironmentObject var dataStore: DataStore
  @State var newUserFormData = User.FormData()
  @Binding var user: User
  @ObservedObject var userVM: UserEventViewModel
  @State public var currentUser: User



  var body: some View {
    TabView {
        NavigationView{
            HomeScreen(userVM: userVM)
        }
        .tabItem{Label("Login", systemImage: "rectangle.and.pencil.and.ellipsis")}
        NavigationView {
            MainList(user: $user, userVM: userVM)
        }
        .tabItem {
          Label("Home", systemImage: "house")
        }
        NavigationView {
            SimpleMap(userVM: userVM)
        }
        .tabItem {
            Label("Map", systemImage: "mappin")
        }
        NavigationView {
//            AttendingList(user: $user, userVM: userVM)
            AttendingList(user: $currentUser, userVM: userVM)
                .onAppear {
                    currentUser = dataStore.getCurrentUser()
            }
        }
        .tabItem {
            Label("Attending", systemImage: "list.star")
        }
        NavigationView {
//            let user1 = dataStore.getCxurrentUser()
            PersonalList(user: $currentUser, userVM: userVM)
                .onAppear {
                    currentUser = dataStore.getCurrentUser()
            }
        }
        .tabItem {
            Label("Manage", systemImage: "person.crop.circle")
        }
    }
    .environmentObject(locationService)
  }
}

struct TabContainer_Previews: PreviewProvider {
  static var previews: some View {
      TabContainer(user: Binding.constant( User.previewData[0]), userVM: UserEventViewModel(User.previewData[0]), currentUser: User.previewData[0])
          .environmentObject(DataStore())
          .environmentObject(LocationService())
  }
}
