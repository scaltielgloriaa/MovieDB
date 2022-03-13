//
//  MoviesCollectionViewCell.swift
//  MovieDB
//
//  Created by Scaltiel Gloria on 10/03/22.
//

import UIKit
import SDWebImage

class MoviesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MoviesCollectionViewCell"
    private let displayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(displayImageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        displayImageView.frame = contentView.bounds
    }
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        displayImageView.sd_setImage(with: url, completed: nil)
    }
}
