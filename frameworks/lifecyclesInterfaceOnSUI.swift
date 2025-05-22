import SwiftUI

// MARK: - ViewModel

class LifecycleViewModel: ObservableObject {
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @Published var hasAppeared = false
}

// MARK: - View

struct LifecycleHandlingView: View {
    @StateObject private var viewModel = LifecycleViewModel()
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass

    var body: some View {
        VStack(spacing: 20) {
            Text("Horizontal size class: \(hSizeClass == .compact ? "Compact" : "Regular")")
            Text("Vertical size class: \(vSizeClass == .compact ? "Compact" : "Regular")")
            Text("Orientation: \(viewModel.orientation.isLandscape ? "Landscape" : "Portrait")")
            Text("Has appeared: \(viewModel.hasAppeared ? "Yes" : "No")")
        }
        .padding()
        .onAppear {
            viewModel.hasAppeared = true
            viewModel.orientation = UIDevice.current.orientation
        }
        .onDisappear {
            viewModel.hasAppeared = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            viewModel.orientation = UIDevice.current.orientation
        }
    }
}
