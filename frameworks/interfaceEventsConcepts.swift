import SwiftUI

// MARK: - ViewModel for Gesture State

class GestureViewModel: ObservableObject {
    @Published var tapCount = 0
    @Published var dragOffset: CGSize = .zero
    @Published var textFieldContent = ""
}

// MARK: - Main View with Gesture Handling and Keyboard Management

struct GestureHandlingView: View {
    @StateObject private var viewModel = GestureViewModel()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 30) {

            // MARK: - Tap Gesture
            Text("Tap count: \(viewModel.tapCount)")
                .padding()
                .background(Color.blue.opacity(0.2))
                .onTapGesture {
                    viewModel.tapCount += 1
                }

            // MARK: - Drag Gesture
            Text("Drag me")
                .padding()
                .background(Color.green.opacity(0.2))
                .offset(viewModel.dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { viewModel.dragOffset = $0.translation }
                        .onEnded { _ in viewModel.dragOffset = .zero }
                )

            // MARK: - TextField + Keyboard Handling
            TextField("Enter text", text: $viewModel.textFieldContent)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .padding()

            Button("Dismiss Keyboard") {
                isTextFieldFocused = false
            }
        }
        .padding()
        .onTapGesture {
            isTextFieldFocused = false // dismiss keyboard on background tap
        }
    }
}
