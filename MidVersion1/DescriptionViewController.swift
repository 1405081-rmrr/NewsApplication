//
//  DescriptionViewController.swift
//  MidVersion1
//
//  Created by Bjit on 18/1/23.
//

import UIKit

class DescriptionViewController: UIViewController {

    
    @IBOutlet weak var titleDesc: UILabel!
    var url: String?
    @IBOutlet weak var imgViewDesc: UIImageView!
    @IBOutlet weak var descriptionDesc: UILabel!
    var newsContent : String?
    var newsDesc : String?
    var imgDesc : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleDesc.text = newsContent
        descriptionDesc.text = newsDesc
        if let image = imgDesc {
            imgViewDesc.sd_setImage(with: URL(string: image))
            print("SD Image: ", image)
        }
       

    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "identifier3" {
                let destinationVC = segue.destination as! WKWebViewViewController
                destinationVC.url = url
            }
        }
    @IBAction func continueButton(_ sender: Any) {
            performSegue(withIdentifier: "identifier3", sender: nil)
    }
    
}
