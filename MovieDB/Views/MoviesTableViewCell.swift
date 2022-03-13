//
//  MoviesTableViewCell.swift
//  MovieDB
//
//  Created by Scaltiel Gloria on 10/03/22.
//
// swiftlint:disable line_length empty_enum_arguments

import UIKit

protocol MoviesTableViewCellDelegate: AnyObject {
    func moviesTableViewCellCellTapped(_ cell: MoviesTableViewCell, viewModel: DetailViewModel)
}

class MoviesTableViewCell: UITableViewCell {
    static let identifier = "MoviesTableViewCell"
    private var titles: [Movies] = [Movies]()
    weak var delegate: MoviesTableViewCellDelegate?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBlue
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    public func configure(with titles: [Movies]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    public func favoriteMovies(indexPath: IndexPath) {
        DataPersistenceManager.shared.favoriteTapped(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
                print("favorited to the core data")
                NotificationCenter.default.post(name: NSNotification.Name("favorited"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MoviesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        let voteCount = String(title.vote_count)
        let voteAverage = String(title.vote_average)
        let viewModel = DetailViewModel(title: titleName, imageURL: title.poster_path ?? "", titleOverview: title.overview ?? "", releaseDate: title.release_date ?? "", voteCount: voteCount, voteAverage: voteAverage )
        delegate?.moviesTableViewCellCellTapped(self, viewModel: viewModel)
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let configuratrion = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let favoriteTapped = UIAction(title: "Favorite", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.favoriteMovies(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [favoriteTapped])
            }

        return configuratrion
    }
}
