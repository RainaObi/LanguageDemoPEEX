import SwiftUI

// MARK: - 1. async/await basic API call
struct ContentView: View {
    @State private var result: String = "Loading..."

    var body: some View {
        VStack {
            Text(result)
                .padding()
        }
        .task {
            result = await fetchData()
        }
    }

    func fetchData() async -> String {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return "Data loaded"
    }
}

// MARK: - 2. Completion Handler Example
func fetchDataWithCompletion(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        completion("Data from completion handler")
    }
}

struct CompletionView: View {
    @State private var text = "Waiting..."

    var body: some View {
        Text(text)
            .onAppear {
                fetchDataWithCompletion { result in
                    text = result
                }
            }
    }
}

// MARK: - 3. DispatchQueue and OperationQueue
func heavyComputation() {
    DispatchQueue.global(qos: .userInitiated).async {
        let result = (1...10_000).reduce(0, +)
        print("Computed: \(result)")
    }

    let queue = OperationQueue()
    queue.addOperation {
        print("OperationQueue task running in background")
    }
}

// MARK: - 4. async let usage
func loadTwoResources() async -> (String, String) {
    async let first = fetchFirst()
    async let second = fetchSecond()

    return await (first, second)
}

func fetchFirst() async -> String {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    return "First done"
}

func fetchSecond() async -> String {
    try? await Task.sleep(nanoseconds: 500_000_000)
    return "Second done"
}

// MARK: - 5. Async Sequences using AsyncStream
struct StreamView: View {
    @State private var logs: [String] = []

    var body: some View {
        List(logs, id: \.self) { Text($0) }
            .task {
                for await log in logGenerator() {
                    logs.append(log)
                }
            }
    }

    func logGenerator() -> AsyncStream<String> {
        AsyncStream { continuation in
            for i in 1...5 {
                continuation.yield("Log \(i)")
                try? await Task.sleep(nanoseconds: 500_000_000)
            }
            continuation.finish()
        }
    }
}

// MARK: - 6. Task Groups
func fetchUsingTaskGroup() async -> [String] {
    await withTaskGroup(of: String.self) { group in
        for i in 1...3 {
            group.addTask {
                try? await Task.sleep(nanoseconds: UInt64(i) * 500_000_000)
                return "Result \(i)"
            }
        }

        var results: [String] = []
        for await value in group {
            results.append(value)
        }
        return results
    }
}

// MARK: - 7. sync vs async concept
func synchronousCall() -> String {
    sleep(2) // Blocks the current thread
    return "Sync Done"
}

func asynchronousCall(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        completion("Async Done")
    }
}
