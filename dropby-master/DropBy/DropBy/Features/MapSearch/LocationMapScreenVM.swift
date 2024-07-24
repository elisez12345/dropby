import SwiftUI
import MapKit

class LocationMapScreenVM: ObservableObject {
  let locationService: LocationService
  @Published var region: MKCoordinateRegion = MKCoordinateRegion(.world)
  @Published var selectedLocation: SelectedLocation? { didSet {
    self.updateMapRegion()
  }}
  @Published var confirmedLocation: Binding<SelectedLocation?>

  init(locationService: LocationService, confirmedLocation: Binding<SelectedLocation?>) {
    self.locationService = locationService
    self.confirmedLocation = confirmedLocation
  }
  
  func locationSearchResultTapped(_ searchCompletion: MKLocalSearchCompletion) {
    locationService.populateLocation(for: searchCompletion) { mapItem in
      if let mapItem = mapItem {
        self.selectedLocation = SelectedLocation.create(from: mapItem)
      }
    }
  }


  func annotationItems() -> [SelectedLocation] {
    guard let selectedLocation = selectedLocation else { return [] }
    return [selectedLocation]
  }

  func annotationSelectButtonTapped() {
    self.confirmedLocation.wrappedValue = selectedLocation
    self.selectedLocation = nil
    self.locationService.clearSearchFragment()
    self.locationService.idleSearch()
  }

  func cancelSelectionButtonTapped() {
    self.selectedLocation = nil
  }

  func updateMapRegion() {
    if let location = selectedLocation {
      self.region = LocationUtilities.coordinateRegion(for: [location.coordinate])
    } else {
      self.region = MKCoordinateRegion(.world)
    }
  }

}
