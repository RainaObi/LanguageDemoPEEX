import SwiftUI
import Foundation

// MARK: - Localization Keys
// Supposing we have the following keys mapped on the localizationstrings file
// "greeting" = "Hello!";
// "price" = "Price";
// "date_label" = "Today is %@";


// MARK: - ViewModel for Localization

class LocalizationViewModel: ObservableObject {
    @Published var formattedPrice: String = ""
    @Published var formattedDate: String = ""

    func updateLocalizedData() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        formattedPrice = numberFormatter.string(from: 29.99)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: Date())
        formattedDate = String(format: NSLocalizedString("date_label", comment: ""), dateString)
    }
}

// MARK: - Main View

struct InternationalisationView: View {
    @StateObject private var viewModel = LocalizationViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text(NSLocalizedString("greeting", comment: "Greeting message"))

            Text("\(NSLocalizedString("price", comment: "")): \(viewModel.formattedPrice)")

            Text(viewModel.formattedDate)

            Button("Update Locale Info") {
                viewModel.updateLocalizedData()
            }
        }
        .padding()
        .onAppear {
            viewModel.updateLocalizedData()
        }
    }
}
