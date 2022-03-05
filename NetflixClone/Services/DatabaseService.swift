//
//  DatabaseService.swift
//  NetflixClone
//
//  Created by Олег Федоров on 05.03.2022.
//

import Foundation
import CoreData
import UIKit

class DatabaseService {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DatabaseService()
    private init() { }
    
    func downloadTitleWith(
        model: Title,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.originalTitle = model.originalTitle
        item.originalName = model.originalName
        item.id = Int64(model.id)
        item.overview = model.overview
        item.posterPath = model.posterPath
        item.firstAirDate = model.firstAirDate
        item.mediaType = model.posterPath
        item.releaseDate = model.releaseDate
        item.voteCount = Int64(model.voteCount)
        item.voteAverage = model.voteAverage
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchTitlesFromDatabase(
        completion: @escaping (Result<[TitleItem], Error>) -> Void
    ) {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(
        model: TitleItem,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
