# SwiftUI Core Data Parent-refresh issue

When editing a child item in a parent-child relationship in Core Data and SwiftUI, SwiftUI does not update the list after an edit.
This sample app demonstrates the issue. 

## Sample app
This app extends the basic app structure generated when you create a new SwiftUI project with Core Data in XCode. I extended the Core Data model, adding a 1-many between Item (Parent) and ChildItem (Child). Check out `ParentChildExample.xcdatamodel`:

### Item

One attribute: timestamp (Date), one relationship: children (1-m with childItem) 
###  ChildItem
Two attributes: title (String), subTitle (String)

### App logic
When adding or editing a child item, if a child item exists with the same title, edit it, and save to Core Data view context. If the child item does not exist, add it, and save to Core Data to View Context.
Once saved, the changes should be reflected in the SwiftUI List

### Core Data changes
I modified `Persistence.swift` to generate a single Parent item, by changing the static `preview` variable:
```
for _ in 0..<1 {
```
I also modified `ParentChildExampleApp` to use the `preview` instance of the Peristence class, which would re-create items in-memory on every app launch
let persistenceController = PersistenceController.preview


## Steps to Reproduce
* Add a child item. Title 'A', Sub-title 'B'. Hit 'Save'
* The list is updated with the new child record (works). One item: A:B
* Add another child item. Title 'B', sub-title 'C'. Hit 'Save'
* The list is updated with the new child record (works). Two items: A:B, B:C
* Now edit child item. Title 'A', Sub-title 'E'. Hit 'Save'
* Expected: The list is updated: Two items: A:E, B:C. 
 * Actual: A:B, B:C


## Code workaround
When adding or editing a child item, if a child item exists with the same title, delete, then add it again. Save to Core Data view context. If the child item does not exist, add it, and save to Core Data to View Context.

### Upsert doesn't work
In ContentView, editing doesn't work

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

Workaround is at `ContentView.swift`, line `73`. Delete than add:

	if existingChildItems.count > 0 {
	    print("deleting!! \(title)")
	    let childItem = existingChildItems[0]
	    //delete
	    viewContext.delete(childItem)
	    item.removeFromChildren(childItem)
	}
	//now add
	print("adding!! \(title)")
	let childItem = ChildItem(context: viewContext)
	childItem.title = title
	childItem.subTitle = subTitle
	item.addToChildren(childItem)


## Xcode version
v 12.5.1
