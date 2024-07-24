import SwiftUI
import MapKit

struct LocationMapScreen: View {
  @EnvironmentObject var locationService: LocationService
  @StateObject var viewModel: LocationMapScreenVM

  var body: some View {
    if viewModel.selectedLocation != nil {
      MapContainer(viewModel: viewModel)
    }
    List(locationService.searchResults, id: \.self) { location in
      VStack(alignment: .leading) {
        Text(location.title)
        Text(location.subtitle)
          .font(.caption)
      }
      .onTapGesture {
        viewModel.locationSearchResultTapped(location)
      }
    }
  }
}

struct MapContainer: View {
  @ObservedObject var viewModel: LocationMapScreenVM

  var body: some View {
    Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.annotationItems()) { location in
      MapAnnotation(coordinate: location.coordinate) {
        LocationAnnotation(viewModel: viewModel, selectedLocation: location) }
    }
  }
}

struct LocationAnnotation: View {
  @ObservedObject var viewModel: LocationMapScreenVM
  let selectedLocation: SelectedLocation

  var body: some View {
    VStack {
      Button("Confirm") { viewModel.annotationSelectButtonTapped() }
      Image(systemName: "mappin")
      Text(selectedLocation.name)
      Button(role: .destructive, action: { viewModel.cancelSelectionButtonTapped() }, label: { Text("Reject") })
    }
    .font(.headline)
    .contentShape(Rectangle())
    .padding(5)
    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color(white: 0.9, opacity: 0.8)))

  }
}

struct MapScreen_Previews: PreviewProvider {
  static let locationService = LocationService()
  static let viewModel = LocationMapScreenVM(locationService: locationService, confirmedLocation: Binding.constant(nil))
  static var previews: some View {
    LocationMapScreen(viewModel: viewModel)
      .environmentObject(locationService)
  }
}

