//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by prema janoti on 3/1/18.
//  Copyright © 2018 prema. All rights reserved.
//

import UIKit
import CoreData

class MovieViewModel: NSObject {
    @IBOutlet weak var apiClient: APIClient!
    
    func getMovies(completion: @escaping () -> Void) {
        apiClient.getDataWith { (result) in
            switch result {
            case .success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
                completion()
            case .error(let message):
                DispatchQueue.main.async {
                    print(message)
                    completion()
                }
            }
        }
    }

    private func createMovieEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context) as? Movie {
            movieEntity.title = dictionary["title"] as? String
            movieEntity.rating = (dictionary["rating"] as? Float)!
            movieEntity.image = dictionary["image"] as? String
            movieEntity.releaseYear = (dictionary["releaseYear"] as? Int16)!
            let genres = dictionary["genre"] as? [String]
            movieEntity.genre = genres! as NSObject
            return movieEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
      _ = array.map{self.createMovieEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Movie.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}





