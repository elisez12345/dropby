import SwiftUI
import MapKit

struct SimpleMap: View {
    @EnvironmentObject var dataStore: DataStore
    @StateObject var viewModel = SimpleMapViewModel()
    @ObservedObject var userVM: UserEventViewModel
    
//    let events: [Event] = dataStore.publicEvents

  var body: some View {
      Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: dataStore.publicEvents) { location in
      MapAnnotation(coordinate: location.location) {
          MySimpleAnnotation(event: location, userVM: userVM)
      }
    }
//      .task { updateMapRegion() }
      .ignoresSafeArea()
      .accentColor(Color(.systemPurple))
      .onAppear{
          viewModel.checkIfLocationServicesIsEnabled()
      }
  }

//  func updateMapRegion() {
//      self.viewModel.region = LocationUtilities.coordinateRegion(for: self.locations.map(\.coordinate))
//  }
}

struct MySimpleAnnotation: View {
    let event: Event
    @State var display: Bool = false
    @ObservedObject var userVM: UserEventViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "mappin")
                .foregroundColor(.red)
                .font(.largeTitle)
            Button(event.name){
                display.toggle()
            }.padding(2)
                .background(Rectangle()
                    .foregroundColor(Color(white: 1)))
            //        if display {
            //            if let blurb = event.description {
            //                Text(blurb)
            //                    .padding(2)
            //                    .background(Rectangle()
            //                    .foregroundColor(Color(white: 1)))
            //            }
            //        }
        }.sheet(isPresented: $display) {
            VStack {
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
                }.padding(2).background(Rectangle().foregroundColor(.white)).opacity(0.9).cornerRadius(30)}
                .background(Image("vert_bg").resizable().frame(width: 500,height:1000))
            }.frame(maxWidth: 300,alignment: .center)
            .padding()
        }
    }

    
struct SimpleMap_Previews: PreviewProvider {
        static var previews: some View {
            SimpleMap(userVM: UserEventViewModel(User.previewData[0])).environmentObject(DataStore())
        }
}
    
final class SimpleMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.001312, longitude: -78.944745), span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006))
        
        var locationManager: CLLocationManager?
        
        func checkIfLocationServicesIsEnabled() {
            if CLLocationManager.locationServicesEnabled(){
                locationManager = CLLocationManager()
                locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager!.delegate = self
                
            } else {
                print("Location services are off")
            }
        }
        
        func checkLocationAuthorization() {
            guard let locationManager = locationManager else {return}
            
            switch locationManager.authorizationStatus{
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted likely due to parental controls.")
            case .denied:
                print("You have denied this app location permission. Go into settings to change permission status.")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006))
            @unknown default:
                break
                
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
}
    
