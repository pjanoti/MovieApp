//
//  Movie+CoreDataProperties.swift
//  MovieApp
//
//  Created by prema janoti on 3/1/18.
//  Copyright © 2018 prema. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var rating: Float
    @NSManaged public var releaseYear: Int16
    @NSManaged public var image: String?
    @NSManaged public var genre: NSObject?

}
