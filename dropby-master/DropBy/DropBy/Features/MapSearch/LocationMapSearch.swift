import SwiftUI
import MapKit

struct LocationMapSearch: View {
  @EnvironmentObject var locationService: LocationService
  @Binding var confirmedLocation: SelectedLocation?

  @State var region: MKCoordinateRegion = MKCoordinateRegion(.world)
  @State var selectionInProcess: Bool = false { didSet {
    self.updateMapRegion()
  }}
  @State var selectedLocation: SelectedLocation?

  var body: some View {
    if selectionInProcess {
      Map(coordinateRegion: $region, annotationItems: annotationItems()) { location in
        MapAnnotation(coordinate: location.coordinate) {
          LocationMapAnnotation(selectedLocation: location, confirmedLocation: $confirmedLocation, selectionInProcess: $selectionInProcess) }
      }
    }
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

  func locationSearchResultTapped(_ searchCompletion: MKLocalSearchCompletion) {
    locationService.populateLocation(for: searchCompletion) { mapItem in
      if let mapItem = mapItem {
        self.selectedLocation = SelectedLocation.create(from: mapItem)
        self.selectionInProcess = true
      }
    }
  }

  func annotationItems() -> [SelectedLocation] {
    guard let selectedLocation = selectedLocation else { return [] }
    return [selectedLocation]
  }

  func updateMapRegion() {
    if selectionInProcess,
    let location = selectedLocation {
      self.region = LocationUtilities.coordinateRegion(for: [location.coordinate])
    } else {
      self.region = MKCoordinateRegion(.world)
    }
  }
}

struct LocationMapAnnotation: View {
  @EnvironmentObject var locationService: LocationService

  let selectedLocation: SelectedLocation
  @Binding var confirmedLocation: SelectedLocation?
  @Binding var selectionInProcess: Bool

  var body: some View {
      VStack {
        Button("Confirm") { annotationSelectButtonTapped() }
        Image(systemName: "mappin")
        Text(selectedLocation.name)
        Button(role: .destructive, action: { cancelSelectionButtonTapped() }, label: { Text("Reject") })
      }
      .font(.headline)
      .contentShape(Rectangle())
      .padding(5)
      .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color(white: 0.9, opacity: 0.8)))
  }

  func annotationSelectButtonTapped() {
    confirmedLocation = selectedLocation
    selectionInProcess = false
    locationService.clearSearchFragment()
    locationService.idleSearch()
  }

  func cancelSelectionButtonTapped() {
    selectionInProcess = false
  }
}

struct LocationMapScreen_Previews: PreviewProvider {
  static let locationService = LocationService()
  static var previews: some View {
    LocationMapSearch(confirmedLocation: Binding.constant(nil))
      .environmentObject(locationService)
  }
}


