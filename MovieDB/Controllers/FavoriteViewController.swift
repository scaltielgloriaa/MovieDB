//
//  Favorite.swift
//  MovieDB
//
//  Created by Scaltiel Gloria on 09/03/22.
//
// swiftlint:disable line_length empty_enum_arguments

import UIKit

class FavoriteViewController: UIViewController {
    private var movies: [MovieItem] = [MovieItem]()
    weak var delegate: MoviesTableViewCellDelegate?
    public let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(favoritesTableView)
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        fetchLocalStorageForFavorite()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("favorited"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForFavorite()
        }
    }
    private func fetchLocalStorageForFavorite() {
        DataPersistenceManager.shared.fetchingMoviesFromDataBase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.favoritesTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesTableView.frame = view.bounds
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        let movie = movies[indexPath.row]
        cell.configure(with: MoviesViewModel(titleName: (movie.original_title ?? movie.original_name) ?? "Unknown title name", posterURL: movie .poster_path ?? "", titleOverview: movie.overview ?? "", releaseDate: movie.release_date ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:

            DataPersistenceManager.shared.deleteFavorite(model: movies[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                let movie = movies[indexPath.row]
                guard let movieName = movie.original_title ?? movie.original_name else {
                    return
                }
                let voteCount = String(movie.vote_count)
                let voteAverage = String(movie.vote_average)
            let viewController = DetailViewController()
            viewController.configure(with: DetailViewModel(title: movieName, imageURL: movie.poster_path ?? "", titleOverview: movie.overview ?? "", releaseDate: movie.release_date ?? "", voteCount: voteCount, voteAverage: voteAverage ))
            self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FavoriteViewController: MoviesTableViewCellDelegate {
    func moviesTableViewCellCellTapped(_ cell: MoviesTableViewCell, viewModel: DetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            let viewController = DetailViewController()
            viewController.configure(with: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }

}
