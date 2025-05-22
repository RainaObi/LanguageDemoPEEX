import Foundation

// Model conforming to Codable for JSON encoding/decoding
struct User: Codable {
    var id: Int
    var name: String
    var email: String

    // Custom CodingKeys example
    enum CodingKeys: String, CodingKey {
        case id
        case name = "full_name"  // Maps JSON key "full_name" to property "name"
        case email
    }
}

// MARK: Codable encoding and decoding using JSONEncoder/JSONDecoder
func encodeUserToJSON(user: User) -> Data? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return try? encoder.encode(user)
}

func decodeUserFromJSON(data: Data) -> User? {
    let decoder = JSONDecoder()
    return try? decoder.decode(User.self, from: data)
}

// MARK: JSONSerialization example: manual JSON to Dictionary and back
func serializeUsingJSONSerialization(user: User) -> Data? {
    let dict: [String: Any] = [
        "id": user.id,
        "full_name": user.name,
        "email": user.email
    ]
    return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
}

func deserializeUsingJSONSerialization(data: Data) -> User? {
    guard
        let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []),
        let dict = jsonObj as? [String: Any],
        let id = dict["id"] as? Int,
        let name = dict["full_name"] as? String,
        let email = dict["email"] as? String
    else {
        return nil
    }
    return User(id: id, name: name, email: email)
}

// MARK: Property List encoding/decoding example
func encodeUserToPlist(user: User) -> Data? {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    return try? encoder.encode(user)
}

func decodeUserFromPlist(data: Data) -> User? {
    let decoder = PropertyListDecoder()
    return try? decoder.decode(User.self, from: data)
}

// Example usage
func example() {
    let user = User(id: 1, name: "Alice", email: "alice@example.com")

    // Codable JSON encode/decode
    if let jsonData = encodeUserToJSON(user: user) {
        print(String(data: jsonData, encoding: .utf8)!)
        if let decodedUser = decodeUserFromJSON(data: jsonData) {
            print("Decoded User from JSON:", decodedUser)
        }
    }

    // JSONSerialization encode/decode
    if let serializedData = serializeUsingJSONSerialization(user: user) {
        print(String(data: serializedData, encoding: .utf8)!)
        if let deserializedUser = deserializeUsingJSONSerialization(data: serializedData) {
            print("Deserialized User from JSONSerialization:", deserializedUser)
        }
    }

    // Property List encode/decode
    if let plistData = encodeUserToPlist(user: user) {
        print(String(data: plistData, encoding: .utf8)!)
        if let decodedPlistUser = decodeUserFromPlist(data: plistData) {
            print("Decoded User from Plist:", decodedPlistUser)
        }
    }
}

example()
