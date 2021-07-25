//
//  ContentView.swift
//  ParentChildExample
//
//  Created by Jonny Sagorin on 24/7/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State var isPresented = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    Section(header: Text("Parent Item: \(item.timestamp!, formatter: itemFormatter)")) {
                        ForEach(item.childrenArray, id: \.self) { childItem in
                            Text(childItem.title! + ":" + childItem.subTitle!)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .sheet(isPresented: $isPresented) {
                AddEditChildItemView {isCancelled, title, subTitle in
                    self.addEditChildItem(cancelled: isCancelled, title: title, subTitle: subTitle)
                    self.isPresented = false
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: { self.isPresented.toggle() }) {
                                        Text("Add/Edit")
                                    }
            )
        }
    }
    
    func addEditChildItem(cancelled:Bool, title: String, subTitle: String) {
        guard !cancelled else {
            return
        }
        
        //grab first parent item
        let item = items[0]
        
        let existingChildItems = item.childItem(with: title)
        /*UPSERT: DOES NOT WORK. Editing the existing parent item's child record
         doess not result in a refresh on screen for the child record */
        
        if existingChildItems.count > 0 {
            //edit
            print("editing!! \(title)")
            let childItem = existingChildItems[0]
            childItem.subTitle = subTitle
        } else {
            //add
            print("adding!! \(title)")
            let childItem = ChildItem(context: viewContext)
            childItem.title = title
            childItem.subTitle = subTitle
            let item = items[0]
            item.addToChildren(childItem)
        }
        
        /*DELETE: WORKS. deleting the child item, then adding it back again works */
//        if existingChildItems.count > 0 {
//            //edit
//            print("deleting!! \(title)")
//            let childItem = existingChildItems[0]
//            viewContext.delete(childItem)
//            item.removeFromChildren(childItem)
//        }
//        //now add
//        print("adding!! \(title)")
//        let childItem = ChildItem(context: viewContext)
//        childItem.title = title
//        childItem.subTitle = subTitle
//        item.addToChildren(childItem)
//
        saveContext()
    }
    
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            debugPrint("Error saving managed object context: \(error)")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
