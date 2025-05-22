import Alamofire

// MARK: - HTTP Client Configuration

class APIClient {
    static let shared = APIClient()

    private let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // seconds
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        session = Session(configuration: configuration)
    }

    // MARK: - GET Request with Query Parameters

    func fetchUsers(completion: @escaping (Result<[User], AFError>) -> Void) {
        let url = "https://api.example.com/users"
        let parameters: Parameters = ["page": 1, "limit": 20]

        session.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300) // Only accept 2xx responses
            .responseDecodable(of: [User].self) { response in
                completion(response.result)
            }
    }

    // MARK: - POST Request with JSON Body and Headers

    func createUser(name: String, email: String, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "https://api.example.com/users"
        let parameters: Parameters = ["name": name, "email": email]

        let headers: HTTPHeaders = [
            "Authorization": "Bearer your_access_token",
            "Content-Type": "application/json"
        ]

        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: User.self) { response in
                completion(response.result)
            }
    }

    // MARK: - Network Reachability Monitoring

    let reachabilityManager = NetworkReachabilityManager()

    func startNetworkMonitoring() {
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                print("Network not reachable")
            case .reachable(.cellular):
                print("Network reachable via cellular")
            case .reachable(.ethernetOrWiFi):
                print("Network reachable via WiFi/Ethernet")
            case .unknown:
                print("Network status unknown")
            }
        })
    }
}

// MARK: - Model for Decoding API Response

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

// MARK: - Example Usage

APIClient.shared.startNetworkMonitoring()

APIClient.shared.fetchUsers { result in
    switch result {
    case .success(let users):
        print("Fetched users: \(users)")
    case .failure(let error):
        print("Error fetching users: \(error.localizedDescription)")
    }
}

APIClient.shared.createUser(name: "Alice", email: "alice@example.com") { result in
    switch result {
    case .success(let user):
        print("Created user: \(user)")
    case .failure(let error):
        print("Error creating user: \(error.localizedDescription)")
    }
}
