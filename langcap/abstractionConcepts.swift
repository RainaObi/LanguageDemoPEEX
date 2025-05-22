import SwiftUI

// MARK: - Protocols and Default Implementations

protocol Drivable {
    var speed: Double { get set }
    func drive()
}

extension Drivable {
    func drive() {
        print("🚗 Driving at speed \(speed)")
    }
}

protocol Electric {
    var batteryLevel: Int { get }
    func charge()
}

extension Electric {
    func charge() {
        print("🔋 Charging... Battery at \(batteryLevel)%")
    }
}

// MARK: - Protocol Inheritance and Conformance

protocol ElectricCar: Drivable, Electric {}

struct TeslaModelY: ElectricCar {
    var speed: Double
    var batteryLevel: Int
}

// MARK: - Runtime Protocol Check

func checkProtocolConformance(_ item: Any) {
    if let driveableItem = item as? Drivable {
        print("✅ Conforms to Drivable")
        driveableItem.drive()
    } else {
        print("❌ Does not conform to Drivable")
    }
}

// MARK: - Optional Methods via Protocol Extension

protocol OptionalMethods {
    func requiredAction()
}

extension OptionalMethods {
    func optionalAction() {
        print("🟡 Optional action provided")
    }
}

struct MyType: OptionalMethods {
    func requiredAction() {
        print("🟢 Required action executed")
    }
}

// MARK: - Protocol Composition

func handleElectricDrivable(item: Drivable & Electric) {
    item.drive()
    item.charge()
}

// MARK: - SwiftUI View for Triggering

struct AbstractionConceptsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Test Protocols") {
                let tesla = TeslaModelY(speed: 120, batteryLevel: 80)
                checkProtocolConformance(tesla)
                handleElectricDrivable(item: tesla)
            }

            Button("Test Optional Method") {
                let item = MyType()
                item.requiredAction()
                item.optionalAction()
            }
        }
        .padding()
    }
}
