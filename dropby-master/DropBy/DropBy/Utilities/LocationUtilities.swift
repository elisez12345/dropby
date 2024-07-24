import Foundation
import MapKit

struct LocationUtilities {
  static func coordinateRegion(for coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
    guard coordinates.count > 0 else { return MKCoordinateRegion() }
    var region: MKMapRect = MKMapRect.null
    if coordinates.count == 1 {
      let point = MKMapPoint(coordinates[0])
      region = region.union(MKMapRect(x: point.x, y: point.y, width: 1000, height: 1000))
    } else {
      for coord in coordinates {
        let point = MKMapPoint(coord)
        region = region.union(MKMapRect(x: point.x, y: point.y, width: 0, height: 0))
      }
    }
    let zoomOutPercent = 1.0
    let zoomOutRegion = MKMapRect(x: region.origin.x - region.size.width*zoomOutPercent,
                                  y: region.origin.y - region.size.height*zoomOutPercent,
                                  width: region.size.width*(1+zoomOutPercent*2),
                                  height: region.size.height*(1+zoomOutPercent*2))
    return MKCoordinateRegion(zoomOutRegion)
  }
}
