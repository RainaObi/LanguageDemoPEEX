import SwiftUI
import PhotosUI
import LocalAuthentication
import Security

// MARK: - Keychain Helper

class KeychainHelper {
    static func savePassword(_ password: String, account: String) {
        guard let data = password.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    static func deletePassword(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - ViewModel Handling Permissions and Security

class SecurityViewModel: ObservableObject {
    @Published var hasPhotoAccess = false

    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.hasPhotoAccess = (status == .authorized || status == .limited)
            }
        }
    }

    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access your secure data") { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            completion(false)
        }
    }

    func storeSecureData() {
        KeychainHelper.savePassword("super_secret", account: "user_token")
    }

    func removeSecureData() {
        KeychainHelper.deletePassword(account: "user_token")
    }
}

// MARK: - SwiftUI View

struct SecurityPracticesView: View {
    @StateObject private var viewModel = SecurityViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Button("Request Photo Access") {
                viewModel.requestPhotoLibraryAccess()
            }

            Button("Authenticate with Face ID / Touch ID") {
                viewModel.authenticateWithBiometrics { success in
                    print(success ? "Authenticated" : "Authentication Failed")
                }
            }

            Button("Save Sensitive Data") {
                viewModel.storeSecureData()
            }

            Button("Remove Sensitive Data") {
                viewModel.removeSecureData()
            }
        }
        .padding()
    }
}
