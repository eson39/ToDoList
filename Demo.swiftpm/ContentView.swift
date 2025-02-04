import SwiftUI

struct ContentView: View {
    @StateObject var lists = ListManager()
    //variable for whenveer you want the alert to show (which is when user presses button)
    @State private var showAddListAlert = false
    //reset the name of the list to blank every time
    @State private var newListName = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(lists.lists) { list in
                    NavigationLink(list.name, destination: ListView(list: list))
                }
            }
            .navigationTitle("StudyBuddy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddListAlert = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New List", isPresented: $showAddListAlert) {
                TextField("Enter list name", text: $newListName)
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    //only add if user types something and then we can just use the constructor of the demo item and set it to not completed bc they just added it
                    if !newListName.isEmpty {
                        lists.lists.append(DemoList(name: newListName, items: []))
                        newListName = ""
                    }
                }
            }
        }
    }
}

struct ListView: View {
    @ObservedObject var list: DemoList
    @State private var showAddItemAlert = false
    @State private var newItemName = ""

    var body: some View {
        List {
            ForEach(list.items) { item in
                ItemRow(item: item)
            }
        }
        .navigationTitle(list.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddItemAlert = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("New Item", isPresented: $showAddItemAlert) {
            TextField("Enter item name", text: $newItemName)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                //only add if user types something and then we can just use the constructor of the demo item and set it to not completed bc they just added it
                if !newItemName.isEmpty {
                    list.items.append(DemoItem(name: newItemName, completed: false))
                    newItemName = ""
                }
            }
        }
    }
}

struct ItemRow: View {
    @ObservedObject var item: DemoItem

    var body: some View {
        HStack {
            Button(action: {
                item.completed.toggle()
            }) {
                //ternary operator if they click it thenn it gets green if not leave it blue
                Image(systemName: item.completed ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.completed ? .green : .blue)
                    .font(.title2)
            }
            
            Text(item.name)
        }
        .padding(.vertical, 5)
    }
}

class ListManager: ObservableObject {
    @Published var lists: [DemoList] = [
        DemoList(name: "Demo List", items: [
            DemoItem(name: "Item 1", completed: false),
            DemoItem(name: "Item 2", completed: false),
            DemoItem(name: "Item 3", completed: false)
        ])
    ]
}

class DemoList: ObservableObject, Identifiable {
    var name: String
    @Published var items: [DemoItem]
    
    init(name: String, items: [DemoItem]) {
        self.name = name
        self.items = items
    }
}

class DemoItem: ObservableObject, Identifiable {
    @Published var name: String
    @Published var completed: Bool
    
    init(name: String, completed: Bool) {
        self.name = name
        self.completed = completed
    }
}
