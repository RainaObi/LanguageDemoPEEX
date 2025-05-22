import SwiftUI
import CoreLocation
import CoreLocationUI

// MARK: - ViewModel

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var status: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkPermissions()
    }

    func checkPermissions() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}

// MARK: - View

struct LocationTrackingView: View {
    @StateObject private var viewModel = LocationViewModel()

    var body: some View {
        VStack(spacing: 20) {
            if let location = viewModel.location {
                Text("Lat: \(location.coordinate.latitude)")
                Text("Lon: \(location.coordinate.longitude)")
            } else {
                Text("Getting location…")
            }

            Text("Permission status: \(viewModel.status.description)")
        }
        .padding()
    }
}

// MARK: - CLAuthorizationStatus description extension

extension CLAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDetermined: return "Not determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Authorized Always"
        case .authorizedWhenInUse: return "Authorized When In Use"
        @unknown default: return "Unknown"
        }
    }
}
