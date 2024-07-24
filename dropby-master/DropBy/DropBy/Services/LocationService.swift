import Combine
import MapKit

class LocationService: NSObject, ObservableObject {
  private var cancellables : Set<AnyCancellable> = []
  private let searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
  @Published var searchFragment: String = ""
  @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
  @Published public var status: SearchStatus = .idle

  @Published var usePointOfInterestFilter: Bool = true
    
    public func setStatus(_ status: SearchStatus) {
        self.status = status
    }

  enum SearchStatus {
    case idle
    case noResults
    case isSearching
    case error(String)
    case resultsFound
  }

  override init() {
    super.init()
    searchCompleter.delegate = self

    $searchFragment
      .receive(on: DispatchQueue.main)
      .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
      .sink(receiveValue: { fragment in
        self.status = .isSearching
        if fragment.isEmpty {
          self.status = .idle
          self.searchResults = []
        } else {
          if self.usePointOfInterestFilter {
            self.searchCompleter.pointOfInterestFilter = .some(MKPointOfInterestFilter.includingAll)
            self.searchCompleter.resultTypes = .pointOfInterest
          } else {
            self.searchCompleter.pointOfInterestFilter = .none
            self.searchCompleter.resultTypes = .query
          }
          self.searchCompleter.queryFragment = fragment
        }
      })
      .store(in: &cancellables)
  }

  func idleSearch() {
    self.status = .idle
  }

  func clearSearchFragment() {
    self.searchFragment = ""
  }

    func populateLocation(for searchCompletion: MKLocalSearchCompletion, onPopulation: @escaping (MKMapItem?) -> Void) {
      let searchRequest = MKLocalSearch.Request(completion: searchCompletion)
      let search = MKLocalSearch(request: searchRequest)
      search.start { response, _ in
        onPopulation(response?.mapItems.first)
      }
    }

  func getMapItemForCompletion(_ location: MKLocalSearchCompletion, onCompletion: @escaping (MKMapItem) -> Void) {
    let searchRequest = MKLocalSearch.Request(completion: location)
    let search = MKLocalSearch(request: searchRequest)
    search.start { response, _ in
      if let response = response,
          let mapItem = response.mapItems.first {
            onCompletion(mapItem)
        self.idleSearch()
      }
    }
  }
}

extension LocationService: MKLocalSearchCompleterDelegate {

  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    if completer.results.isEmpty {
      self.status = .noResults
    } else {
      self.status = .resultsFound
      self.searchResults = completer.results
    }
  }

  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    self.status = .error(error.localizedDescription)
  }
}


