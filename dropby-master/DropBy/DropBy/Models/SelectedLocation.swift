import Foundation
import CoreLocation
import MapKit

struct SelectedLocation: Identifiable, Equatable {
  static func == (lhs: SelectedLocation, rhs: SelectedLocation) -> Bool {
    lhs.id == rhs.id
  }

  let id: UUID = UUID()
  let coordinate: CLLocationCoordinate2D
  let placemark: MKPlacemark
    let name: String
    
    static func create(from mapItem: MKMapItem) -> SelectedLocation {
      let placemark = mapItem.placemark
      let street = [placemark.subThoroughfare, placemark.thoroughfare].compactMap { $0 }.joined(separator: " ")
        return SelectedLocation(
            coordinate: placemark.coordinate, placemark: placemark, name: placemark.name ?? "No name")
    }
}
