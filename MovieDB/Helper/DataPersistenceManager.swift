//
//  DataPersistenceManager.swift
//  MovieDB
//
//  Created by Scaltiel Gloria on 12/03/22.
//

import UIKit
import CoreData

class DataPersistenceManager {
    enum DatabasError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    static let shared = DataPersistenceManager()
    func favoriteTapped(model: Movies, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let item = MovieItem(context: context)
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToSaveData))
        }
    }
    func fetchingMoviesFromDataBase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(DatabasError.failedToFetchData))
        }
    }
    func deleteFavorite(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
        }
    }
}
