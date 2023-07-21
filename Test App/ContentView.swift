//
//  ContentView.swift
//  Test App
//
//  Created by Cameron Coles on 22/06/2023.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Item: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var content: String
}

struct ContentView: View {
    @State private var showImmersiveSpace = false
    @State private var arrayOfItems: [Item] = []
    @State private var newItemTitle = ""
    @State private var selectedItem: Item? = nil
    @State private var contentInput: String = ""
    @State private var inputText: String = ""
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(selection: $selectedItem) {
                    ForEach(arrayOfItems) { item in
                        Text(item.title)
                            .tag(item)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(SidebarListStyle())
                
                .toolbar {
                    ToolbarItemGroup(placement: .automatic) {
                        TextField("New Item", text: $newItemTitle, onCommit: addItem)
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            },
            detail: {
                if let selectedItem = selectedItem {
                    ItemContentView(selectedItem: $selectedItem, content: $contentInput)
                } else {
                    Text("No item selected")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
        )
        .onChange(of: selectedItem) { newValue in
            contentInput = newValue?.content ?? ""
        }
    }

    
    private func addItem() {
        guard !newItemTitle.isEmpty else {
            return
        }
        
        let newItem = Item(title: newItemTitle, content: "")
        arrayOfItems.append(newItem)
        newItemTitle = ""
    }
    
    private func deleteItems(at offsets: IndexSet) {
        arrayOfItems.remove(atOffsets: offsets)
        selectedItem = nil
    }
}

struct ItemContentView: View {
    @Binding var selectedItem: Item?
    @Binding var content: String
    
    var body: some View {
        VStack {
            if let item = selectedItem {
                
                if item.content.isEmpty {
                    VStack {
                        TextField("Enter Content", text: $content)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            addItemContent()
                        }) {
                            Text("Add Content")
                                .foregroundColor(.white)
                                .padding()
                                .cornerRadius(10)
                        }
                    }
                } else {
                    ScrollView {
                        Text(item.content)
                            .padding()
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle(selectedItem?.title ?? "")
    }
    
    private func addItemContent() {
        guard let selectedItem = selectedItem, !content.isEmpty else {
            return
        }
        
        var modifiedItem = selectedItem
        modifiedItem.content.append(contentsOf: content)
        content = ""
        
        self.selectedItem = modifiedItem
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

