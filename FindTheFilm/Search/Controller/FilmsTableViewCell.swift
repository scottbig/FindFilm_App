//
//  FilmsTableViewCell.swift
//  FindTheFilm
//
//  Created by  石明杰 on 2020/10/21.
//

import UIKit

class FilmsTableViewCell: UITableViewCell {
    
    static let ReuseIdentifier = String(describing: FilmsTableViewCell.self)
    static let NibName = String(describing: FilmsTableViewCell.self)
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func load(search: Search) {
        titleLabel.text = search.title
        
        if let imageUrl = URL(string: search.poster) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.posterView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                    self.posterView.image = #imageLiteral(resourceName: "imageNotFound")
                    }
                }
            }
        }
    }
}

