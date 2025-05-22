import SwiftUI

// MARK: - Dynamic UI Elements with SwiftUI: List + LazyVStack + ScrollView + Add/Remove Items

struct DynamicListView: View {
    @State private var items = ["Apple", "Banana", "Cherry"]

    var body: some View {
        VStack {
            // Scrollable list with dynamic data
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .contextMenu {
                                Button(role: .destructive) {
                                    remove(item: item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .padding()
            }
            .frame(maxHeight: 300)

            HStack {
                Button("Add Item") {
                    addItem()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    resetItems()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }

    func addItem() {
        items.append("New Item \(items.count + 1)")
    }

    func remove(item: String) {
        items.removeAll(where: { $0 == item })
    }

    func resetItems() {
        items = ["Apple", "Banana", "Cherry"]
    }
}

struct DynamicListView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicListView()
    }
}
