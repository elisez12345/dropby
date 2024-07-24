import SwiftUI
import MapKit

class MapScreenVM: ObservableObject {
  let locationService: LocationService
  @Published var region: MKCoordinateRegion = MKCoordinateRegion(.world)
  @Published var locations: [SelectedLocation] = [] { didSet {
    updateMapRegion()
  }}
  @Published var tappedMapLocation: SelectedLocation?

  init(locationService: LocationService) {
    self.locationService = locationService
  }

  func locationSearchResultTapped(_ location: MKLocalSearchCompletion) {
    let searchRequest = MKLocalSearch.Request(completion: location)
    let search = MKLocalSearch(request: searchRequest)
    search.start { response, _ in
      if let response = response,
          let mapItem = response.mapItems.first {
          let location = SelectedLocation(coordinate: mapItem.placemark.coordinate, placemark: mapItem.placemark, name: mapItem.placemark.name ?? "No Name")
        self.locations.append(location)
      }
    }
    locationService.idleSearch()
  }

  func updateMapRegion() {
    self.region = LocationUtilities.coordinateRegion(for: self.locations.compactMap(\.placemark.location?.coordinate))
  }

  func removeLocationTapped() {
    if let locationToRemove = tappedMapLocation {
      remove(location: locationToRemove)
    }
  }

  func remove(location: SelectedLocation) {
    if let index = locations.firstIndex(where: { $0.id == location.id }) {
      locations.remove(at: index)
    }
  }

}
