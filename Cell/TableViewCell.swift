//
//  TableViewCell.swift
//  OleksiyNewsAPI
//
//  Created by User on 02.04.2021.
//

import UIKit
import SDWebImageSwiftUI

class TableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var descriptLb: UILabel!
    @IBOutlet weak var sourceLb: UILabel!
    @IBOutlet weak var authorLb: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    
    func setUp(article: Article) {
        titleLb.text = article.title
        sourceLb.text = article.source.name
        authorLb.text = article.author
        descriptLb.text = article.description
        if let imgUrl = article.urlToImage,
           let url = URL(string: imgUrl) {
            imgCell.sd_setImage(with: url)
        }
    }
}
