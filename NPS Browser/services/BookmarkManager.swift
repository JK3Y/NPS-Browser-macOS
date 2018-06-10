//
//  BookmarkManager.swift
//  NPS Browser
//
//  Created by JK3Y on 6/9/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class BookmarkManager {
    
    let cd = CoreDataIO()
    var bookmarkList: [Bookmark] = []
    
    init() {
        
    }
    
    func getBookmarkList() -> [Bookmark] {
        return self.bookmarkList
    }

    func addBookmark(_ bookmark: Bookmark) {
        bookmarkList.append(bookmark)
    }
    
    func removeBookmark(_ bookmark: Bookmark) {
        let index = bookmarkList.index(where: { (item) -> Bool in
            item.title_id == bookmark.title_id
        })

        self.bookmarkList.remove(at: index!)
    }
    
    func saveBookmarks() {
        let entity = cd.getEntity(entityName: "Bookmarks")
        bookmarkList.forEach({ item in
            let bookmark = cd.getObject(entity: entity)
            bookmark.setValue(item.name, forKey: "name")
            bookmark.setValue(item.title_id, forKey: "title_id")
            bookmark.setValue(item.type, forKey: "type")
            bookmark.setValue(item.zrif, forKey: "zrif")
            bookmark.setValue(item.url, forKey: "url")
//            bookmark.setValue(item.refObjectID, forKey: "item")

            do {
                try cd.getContext().save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        })
    }
}
