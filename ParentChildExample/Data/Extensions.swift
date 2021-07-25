//
//  Item+Extensions.swift
//  ParentChildExample
//
//  Created by Jonny Sagorin on 24/7/21.
//

import Foundation

extension Item {
    public var childrenArray: [ChildItem] {
        let set = children as? Set<ChildItem> ?? []
        return set.sorted(by: { itemOne, itemTwo in
            return itemOne.title! < itemTwo.title!
        })
    }
    
    func childItem(with title:String) -> [ChildItem]
    {
        let set = children as? Set<ChildItem> ?? []
        return set.filter({ childItem in
            return childItem.title == title
        })
    }

}
