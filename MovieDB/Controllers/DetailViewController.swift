//
//  DetailViewController.swift
//  MovieDB
//
//  Created by Scaltiel Gloria on 11/03/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    let contentView = UIView()

    private let displayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry potter"
        return label
    }()
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "2022-10-12"
        return label
    }()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "This is the best movie ever to watch as a kid!"
        return label
    }()
    private let voteCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "10"
        return label
    }()
    private let voteAverage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "5"
        return label
    }()
    var tapped = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(displayImageView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(overviewLabel)
        view.addSubview(voteCount)
        view.addSubview(voteAverage)
        configureConstraints()
    }
    func configureConstraints() {
        let displayImageViewConstraints = [
            displayImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            displayImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayImageView.heightAnchor.constraint(equalToConstant: 350)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: displayImageView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        let releaseDateLabelConstraints = [
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        let voteCountConstraints = [
            voteCount.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            voteCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            voteCount.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        let voteAverageConstraints = [
            voteAverage.topAnchor.constraint(equalTo: voteCount.bottomAnchor, constant: 5),
            voteAverage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            voteAverage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(displayImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(releaseDateLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(voteCountConstraints)
        NSLayoutConstraint.activate(voteAverageConstraints)
    }
    public func configure(with model: DetailViewModel) {
        titleLabel.text = model.title
        releaseDateLabel.text = model.releaseDate
        overviewLabel.text = model.titleOverview
        voteCount.text = "Vote Count: \(model.voteCount)"
        voteAverage.text = "Rating: \(model.voteAverage)/10"
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.imageURL)") else {
            return
        }
        displayImageView.sd_setImage(with: url, completed: nil)
    }
}
