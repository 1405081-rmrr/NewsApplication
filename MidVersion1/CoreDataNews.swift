//
//  CoreDataNews.swift
//  MidVersion1
//
//  Created by Bjit on 16/1/23.
//

import Foundation
import UIKit
import CoreData
class CoreDataNews
{
    var delegate : ViewController?
    var bookmarkDelegate : BookmarkViewController?
    var allNews = [NewsArticle]()
    static let coreDataNews = CoreDataNews()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private init(){}
    
    func getDataFromRecord(category : String, title : String) -> [NewsArticle]
    {
        
        
        do{
           // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NewsArticle>(entityName: "NewsArticle")
            if category == "All"
            {
                if (title == "") {
                    let predicate = NSPredicate(format: "category == %@", "General")
                     
                     fetchRequest.predicate = predicate
                } else {
                    let predicate = NSPredicate(format: "category == %@ && title CONTAINS [c] %@", "General", title)
                
                     fetchRequest.predicate = predicate
                }
                delegate?.allNews = try context.fetch(fetchRequest)
                print("ALL clicked")
                print("All Data is Here ", delegate?.allNews)
                DispatchQueue.main.async {
                    self.delegate?.tableView.reloadData()
                }
            }
            else{
            let predicate = NSPredicate(format: "category == %@ && title CONTAINS [c] %@", category, title)
            
            fetchRequest.predicate = predicate
            delegate?.allNews = try context.fetch(fetchRequest)
            if let allNewss = delegate?.allNews
                {
                allNews = allNewss
                print("All Data is here ", allNews)
                delegate?.tableView.reloadData()
                
            }
                else
                {
                 allNews = []
                }
            //delegate?.tableView.reloadData()
            }
        }
        catch
        {
            print(error.localizedDescription)
        }

        return allNews
    }
    func addRecordFromAPI(title : String, author : String, publishedAt : String, url : String, urlToImage : String, category : String, context : NSManagedObjectContext) -> [NewsArticle]
    {
        let item = NewsArticle(context: context)
        var newsArray = [NewsArticle]()
        do{
            item.title = title
            item.author = author
            item.publishedAt = publishedAt
            item.url = url
            item.category = category
            item.urlToImage = urlToImage
            item.bookMarked = false
            try context.save()
            newsArray.append(item)
        }
        catch{
            print("Adding Failed")
        }
    print("Added")
    return newsArray
    }
   
    
    func getDataFromBookmark(category : String, title : String) -> [Bookmark]
    {
        var allNews = [Bookmark]()
        
        do{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Bookmark>(entityName: "Bookmark")
            if category == "All"
            {
                bookmarkDelegate?.allNewsBookmark = try context.fetch(fetchRequest)
                print("ALL clicked")
                print("News is ", bookmarkDelegate?.allNewsBookmark)
                bookmarkDelegate?.tableView.reloadData()
            }
            else{
                let predicate = NSPredicate(format: "category == %@ && title CONTAINS [c] %@", category, title)
                
                fetchRequest.predicate = predicate
                do {
                    bookmarkDelegate?.allNewsBookmark = try context.fetch(fetchRequest)
                    print(bookmarkDelegate?.allNewsBookmark.count)
                }
                catch {
                    print(error)
                }
                bookmarkDelegate?.tableView.reloadData()
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        return allNews
    }
    func addRecordToBookmark(title : String, author : String, publishedAt : String, url : String, urlToImage : String, category : String, context : NSManagedObjectContext) -> [Bookmark]
    {
        let item = Bookmark(context: context)
        var newsArray = [Bookmark]()
        do{
            item.title = title
            item.author = author
            item.publishedAt = publishedAt
            item.url = url
            item.category = category
            item.urlToImage = urlToImage
            item.bookMarked = false
            try context.save()
            newsArray.append(item)
        }
        catch{
            print("Adding Failed")
        }
    print("Added")
    return newsArray
    }
    
    func matchURL(url : String, context : NSManagedObjectContext) -> Bool
    {
        var bool = false
        let fetchRequest = NSFetchRequest<Bookmark>(entityName: "Bookmark")
        let predicate = NSPredicate(format: "url == %@", url)
        fetchRequest.predicate = predicate
        
        let object = try! context.fetch(fetchRequest) as [NSManagedObject]
        if !object.isEmpty
        {
            bool = true
        }
        return bool
    }
    
    func deleteData(category : String)
    {
        for news in allNews
        {
            if (news.category!  == category)
            {
                context.delete(news)
            }
        }
        do
        {
            try context.save()
        }
        catch{
            print(error)
        }
    }
}
