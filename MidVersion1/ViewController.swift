//
//  ViewController.swift
//  MidVersion1
//
//  Created by Bjit on 12/1/23.
//
import Foundation
import UIKit
import SDWebImage
//var result : Welcome?
class ViewController: UIViewController {
    
    var result : Welcome?
    var categoryIndex : IndexPath = IndexPath(item: 0, section: 0)
    @IBOutlet weak var searchbar: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var allNews = [NewsArticle]()
    var flag : Bool!
    var flag2 : Bool!
    var category = ""
    var search = " "
    var contentFromMainView = ""
    var descriptionFromMainView = ""
    var urlMainView = ""
    var imgFromMainView = ""
    override func viewDidLoad() {
        CoreDataNews.coreDataNews.delegate = self
        SearchBar.shared.createSearchBar(searchBar: searchbar)
        super.viewDidLoad()
        flag = UserDefaults.standard.bool(forKey: "UserDefaultsKey")
        flag2 = UserDefaults.standard.bool(forKey: "UserDefaultsKey1")
        print(flag!)
        if flag! == false {
            fetchDataFromAPI(cat: "")
            
            for i in 1..<8 {

                fetchDataFromAPI(cat: "\(Category.categories[i])")

            }
            
            UserDefaults.standard.set(!flag, forKey: "UserDefaultsKey")
        }
        CoreDataNews.coreDataNews.getDataFromRecord(category: "All", title: search)
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchbar.delegate = self
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "description" {
                let destinationVC = segue.destination as! DescriptionViewController
                destinationVC.newsContent = contentFromMainView
                destinationVC.newsDesc = descriptionFromMainView
                destinationVC.url = urlMainView
                destinationVC.imgDesc = imgFromMainView
                print(destinationVC.newsContent)
            }
        }
    
    func fetchDataFromAPI(cat : String)
    {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=1cb1fe49aacd433ea74301482f886b8c&category=\(cat.lowercased())")
                
        else{
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
            [weak self] data, response, error in
            guard let data = data, error == nil else
            {
                print("Fetching incorrect")
                return
            }
            do{
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                self?.result = try decoder.decode(Welcome.self, from: data)
                print(self?.result)
                
            }
            catch
            {
                print("Failed!!!!")
            }
            guard let jsonData = self?.result else
            {
                print("Fetching Error!!")
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            for i in 0..<jsonData.articles.count
            {
                CoreDataNews.coreDataNews.addRecordFromAPI(title: jsonData.articles[i].title ?? "", author: jsonData.articles[i].author ?? "", publishedAt: jsonData.articles[i].publishedAt ?? "", url: jsonData.articles[i].url ?? "", urlToImage: jsonData.articles[i].urlToImage ?? "", category: cat ?? "", context: self!.context)
            }
            CoreDataNews.coreDataNews.getDataFromRecord(category: "All", title: " ")
        })
        dataTask.resume()
        
    }
}
extension ViewController : UITableViewDelegate
{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        print(allNews[indexPath.row].title, allNews[indexPath.row].desc)

        if let newsContent = allNews[indexPath.row].title{
            contentFromMainView = newsContent
        }
        if let newsContent = allNews[indexPath.row].content{
            
            descriptionFromMainView = newsContent
        }
        if let url = allNews[indexPath.row].url
        {
            urlMainView = url
        }
        if let img = allNews[indexPath.row].urlToImage
        {
            imgFromMainView = img
        }
        
        performSegue(withIdentifier: "description", sender: nil)
    }
}
extension ViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as! CustomCollectionViewCell
        collectionCell.category.text = Category.categories[indexPath.row]
        collectionCell.category.textColor = .black
        if categoryIndex == indexPath
        {
            collectionCell.category.textColor = .systemGreen
            
        }
        return collectionCell
        
    }
}
extension ViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.category.textColor = .systemGreen
        categoryIndex = indexPath
        if indexPath.row == 0
        {

            CoreDataNews.coreDataNews.getDataFromRecord(category: "All", title: search)
            tableView.reloadData()

        }
        category = "\(Category.categories[indexPath.row])"
        CoreDataNews.coreDataNews.getDataFromRecord(category: category, title: search)
        collectionView.reloadData()

        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.category.textColor = .black
    }
}
extension ViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableView") as! CustomTableViewCell
        cell.authorLabel.text = allNews[indexPath.row].author
        cell.titleLabel.text = allNews[indexPath.row].title
        cell.dateLabel.text = allNews[indexPath.row].publishedAt
        let image = allNews[indexPath.row].urlToImage
        if let image = image {
            cell.imgView.sd_setImage(with: URL(string: image))
            print("SD Image: ", image)
        }
        else {
            cell.imgView.image = UIImage(systemName: "trash")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let bookmarkAction = UIContextualAction(style: .destructive, title: nil) {[weak self] _,_,completed in
            guard let self = self else {return}
            let fetchData = self.allNews[indexPath.row]
            print(fetchData.bookMarked)
            if CoreDataNews.coreDataNews.matchURL(url: fetchData.url ?? "", context: self.context)
            {
                return
            }
            CoreDataNews.coreDataNews.addRecordToBookmark(title: fetchData.title ?? "", author: fetchData.author ?? "", publishedAt: fetchData.publishedAt ?? "", url: fetchData.url ?? "", urlToImage: fetchData.urlToImage ?? "", category: fetchData.category ?? "", context: self.context)
        }
        bookmarkAction.image = UIImage(systemName: "bookmark")
        bookmarkAction.backgroundColor = .systemBlue
        
        let swipAction = UISwipeActionsConfiguration(actions: [bookmarkAction])
        return swipAction
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        search = searchbar.text!
        CoreDataNews.coreDataNews.getDataFromRecord(category: category, title: search)
        return true
    }
}
