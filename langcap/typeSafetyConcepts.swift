import SwiftUI

// MARK: - Protocol

protocol Purchasable {
    var name: String { get }
}

// MARK: - Structs Conforming to Protocol

struct Book: Purchasable {
    let name: String
    let author: String
}

struct Game: Purchasable {
    let name: String
    let platform: String
}

// MARK: - Store Class Using Type Checking and Casting

class Store {
    var inventory: [Any] = []

    func addItem(_ item: Any) {
        inventory.append(item)
    }

    func listPurchasables() {
        for item in inventory {
            if let purchasable = item as? Purchasable {
                print("✅ \(purchasable.name)")
            } else {
                print("❌ Not a purchasable item")
            }
        }
    }

    func checkType(_ item: Any) {
        if item is Book {
            print("📘 Item is a Book")
        } else if item is Game {
            print("🎮 Item is a Game")
        } else {
            print("🧐 Unknown type")
        }
    }
}

// MARK: - SwiftUI View

struct TypeSafetyConceptsView: View {
    var body: some View {
        Button("Run Type Safety Test") {
            let store = Store()
            let book = Book(name: "Swift Programming", author: "Apple")
            let game = Game(name: "Elden Ring", platform: "PS5")
            let randomItem = 123

            store.addItem(book)
            store.addItem(game)
            store.addItem(randomItem)

            store.listPurchasables()

            store.checkType(book)
            store.checkType(randomItem)
        }
        .padding()
    }
}
