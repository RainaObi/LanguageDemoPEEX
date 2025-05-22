import SwiftUI
import Foundation

// MARK: - 1. Serial and Concurrent Queues
func testQueues() {
    let serialQueue = DispatchQueue(label: "com.example.serial")
    let concurrentQueue = DispatchQueue(label: "com.example.concurrent", attributes: .concurrent)

    serialQueue.async {
        print("🔵 Serial Task 1")
    }

    serialQueue.async {
        print("🔵 Serial Task 2")
    }

    concurrentQueue.async {
        print("🟢 Concurrent Task 1")
    }

    concurrentQueue.async {
        print("🟢 Concurrent Task 2")
    }
}

// MARK: - 2. Custom Operation Queue with Dependencies and Cancellation

class CustomOperation: Operation {
    let id: Int

    init(id: Int) {
        self.id = id
    }

    override func main() {
        if isCancelled { return }
        print("🧩 Running operation \(id)")
        Thread.sleep(forTimeInterval: 1)
    }
}

func testOperationQueue() {
    let op1 = CustomOperation(id: 1)
    let op2 = CustomOperation(id: 2)
    let op3 = CustomOperation(id: 3)

    op2.addDependency(op1) // op2 waits for op1
    op3.addDependency(op2) // op3 waits for op2

    let queue = OperationQueue()
    queue.addOperations([op1, op2, op3], waitUntilFinished: false)

    // Cancel operation 2 before it runs
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
        op2.cancel()
        print("❌ Cancelled operation 2")
    }
}

// MARK: - 3. Quality of Service (QoS)
func qosExamples() {
    let utilityQueue = DispatchQueue(label: "com.example.utility", qos: .utility)
    let userInteractiveQueue = DispatchQueue(label: "com.example.ui", qos: .userInteractive)

    utilityQueue.async {
        print("⚙️ Utility QoS task running")
    }

    userInteractiveQueue.async {
        print("⚡️ User Interactive QoS task running")
    }
}

// MARK: - 4. KVO (Key-Value Observing) Compliant Property
class ObservableOperation: Operation {
    @objc dynamic private(set) var finishedExecuting = false

    override func main() {
        print("🧠 ObservableOperation started")
        Thread.sleep(forTimeInterval: 2)
        willChangeValue(for: \.finishedExecuting)
        finishedExecuting = true
        didChangeValue(for: \.finishedExecuting)
        print("🧠 ObservableOperation finished")
    }
}

class Observer: NSObject {
    private var observation: NSKeyValueObservation?

    func start() {
        let operation = ObservableOperation()
        observation = operation.observe(\.finishedExecuting, options: [.new]) { op, change in
            if change.newValue == true {
                print("✅ Observed operation completion")
            }
        }

        let queue = OperationQueue()
        queue.addOperation(operation)
    }
}

// MARK: - Usage Preview in SwiftUI
struct ConcurrencyExamplesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Run GCD Queues") {
                testQueues()
            }
            Button("Run Operation Queue with Cancel") {
                testOperationQueue()
            }
            Button("Run QoS Example") {
                qosExamples()
            }
            Button("Observe Operation Completion") {
                Observer().start()
            }
        }
        .padding()
    }
}
