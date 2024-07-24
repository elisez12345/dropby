import SwiftUI
import MapKit

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
////    Toggle(isOn: $locationService.usePointOfInterestFilter,
////           label: {
////      Text("Use point of interest filter").font(.caption)
////    })
////    .padding(.horizontal, 10)
//  }
//}

struct SearchView: View {
  @EnvironmentObject var locationService: LocationService
  @Binding var locations: [SelectedLocation]

  var body: some View {
    List(locationService.searchResults, id: \.self) { location in
      VStack(alignment: .leading) {
        Text(location.title)
        Text(location.subtitle)
          .font(.caption)
      }
      .onTapGesture {
        locationSearchResultTapped(location)
      }
    }
  }

  func locationSearchResultTapped(_ location: MKLocalSearchCompletion) {
    locationService.getMapItemForCompletion(location) { mapItem in
        let location = SelectedLocation(coordinate: mapItem.placemark.coordinate, placemark: mapItem.placemark, name: mapItem.placemark.name ?? "No Name")
      self.locations.append(location)
    }
  }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
      SearchView(locations: Binding.constant([]))
        .environmentObject(LocationService())

    }
}

