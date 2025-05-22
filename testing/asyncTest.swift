import XCTest

// MARK: - Service Under Test

class UserService {
    func fetchUsername(completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if Bool.random() {
                completion(.success("LuisM"))
            } else {
                completion(.failure(NSError(domain: "UserServiceError", code: 1, userInfo: nil)))
            }
        }
    }
}

// MARK: - Unit Tests

final class UserServiceTests: XCTestCase {
    var service: UserService!

    override func setUp() {
        super.setUp()
        service = UserService()
    }

    func testFetchUsername() {
        let expectation = self.expectation(description: "Async fetch completes")

        service.fetchUsername { result in
            switch result {
            case .success(let username):
                XCTAssertEqual(username, "LuisM")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
