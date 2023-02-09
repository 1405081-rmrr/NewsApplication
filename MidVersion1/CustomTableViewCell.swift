//
//  CustomTableViewCell.swift
//  MidVersion1
//
//  Created by Bjit on 12/1/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imgBookmarkView: UIImageView!
    @IBOutlet weak var dateBookmarkLabel: UILabel!
    @IBOutlet weak var authorbookmarkLabel: UILabel!
    @IBOutlet weak var titleBookmarkLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func configure(with data: Article) {
//        guard let image = data.urlToImage else{return }
//        guard let url = URL(string: image) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if error != nil {
//                print(error!)
//                return
//            }
//            DispatchQueue.main.async {
//                self.imgView.image = UIImage(data: data!)
//            }
//        }
//        task.resume()
//    }

}
