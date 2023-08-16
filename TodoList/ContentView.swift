//
//  ContentView.swift
//  TodoList
//
//  Created by Gunarathna Deshan on 2023-03-13.
//

import SwiftUI

struct ListModel : Identifiable {
    let id = UUID()
    let item : String
}

class ListView : ObservableObject{
    @Published var arraylist: [ListModel] = []
    
    init() {
        getList()
    }
    
    func getList() {
        let item1 = ListModel(item: "buy milk")
        let item2 = ListModel(item: "go shopping")
        let item3 = ListModel(item: "do homework")
        
        arraylist.append(item1)
        arraylist.append(item2)
        arraylist.append(item3)
    }
    
    func addtoList(listItem: String){
        arraylist.append(ListModel(item: listItem))
    }
    
    func deleteFromList(index : IndexSet) {
        arraylist.remove(atOffsets: index)
    }
}

struct ContentView: View {
    @StateObject var listViewModel: ListView = ListView()
    @State private var showingAlert = false
    @State private var task : String = ""
    
    
    var body: some View {
        VStack {
            NavigationView{
                List {
                    ForEach(listViewModel.arraylist) { task in
                        Text(task.item)
                    }.onDelete { index in
                        listViewModel.deleteFromList(index: index)
                    }
                }
                .navigationTitle("To-do List")
                .toolbar{
                    Button {
                        print("Edit button was tapped")
                        showingAlert = true
                    } label: {
                        Image(systemName: "plus")
                        
                    }
                    .alert("Add new task",isPresented:$showingAlert) {
                        TextField("Task", text: $task).autocorrectionDisabled().keyboardType(.default)
                        Button("Add", action: {
                            listViewModel.addtoList(listItem: task)
                            task = ""
                        })
                        Button("Cancel", role: .cancel, action: {
                            task = ""
                        })
                    }
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
