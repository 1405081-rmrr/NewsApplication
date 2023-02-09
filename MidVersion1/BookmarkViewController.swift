import UIKit
class BookmarkViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var allNewsBookmark = [Bookmark]()
    var category = "\(Category.categories[1])"
    var url = ""
    var search = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        CoreDataNews.coreDataNews.bookmarkDelegate = self
        searchBar.delegate = self
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "identifier1" {
            let destinationVC = segue.destination as! WKWebViewViewController
            destinationVC.url = url
        }
    }
    
}
extension BookmarkViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(allNewsBookmark.count)
        return allNewsBookmark.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewBookmark") as! CustomTableViewCell
        cell.titleBookmarkLabel.text = allNewsBookmark[indexPath.row].title
        cell.authorbookmarkLabel.text = allNewsBookmark[indexPath.row].author
        cell.dateBookmarkLabel.text =  allNewsBookmark[indexPath.row].publishedAt
        let image = allNewsBookmark[indexPath.row].urlToImage
        if let image = image {
            cell.imgBookmarkView.sd_setImage(with: URL(string: image))
            print("SD Image: ", image)
        }
        else {
            cell.imgBookmarkView.image = UIImage(systemName: "trash")
        }
        return cell
        
    }
}
extension BookmarkViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewBookmark", for: indexPath) as! CustomCollectionViewCell
        cell.categoryBookmark.text = Category.categories[indexPath.row]
        return cell
    }
}

extension BookmarkViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if let newsLink = allNewsBookmark[indexPath.row].url {
            url = newsLink
        }
        performSegue(withIdentifier: "identifier1", sender: nil)
    }
}
extension BookmarkViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        category = Category.categories[indexPath.row]
        print("Category is ", category)
        CoreDataNews.coreDataNews.getDataFromBookmark(category: category, title: search)
        cell?.categoryBookmark.textColor = .green
        tableView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.categoryBookmark.textColor = .black
    }

}
extension BookmarkViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        search = searchBar.text!
        CoreDataNews.coreDataNews.getDataFromBookmark(category: category, title: search)
        return true
    }
}

