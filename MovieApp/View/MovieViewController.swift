//
//  MovieViewController.swift
//  MovieApp
//
//  Created by prema janoti on 3/1/18.
//  Copyright © 2018 prema. All rights reserved.
//

import UIKit
import CoreData

class MovieViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet var movieViewModel: MovieViewModel!
    private var filteredMovies = [Movie]()
    
    let searchController = UISearchController(searchResultsController: nil)
   
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Movie.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchMovies()
        self.movieTableView.rowHeight = UITableViewAutomaticDimension
        self.movieTableView.estimatedRowHeight = 100.0
    }
    
    private func setupUI() {
        self.navigationItem.title = "Movies"
        searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Search by genre"
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        movieTableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchMovies() {
        do {
            try self.fetchedhResultController.performFetch()
        } catch let error  {
            print("ERROR: \(error)")
        }
        movieViewModel.getMovies {}
    }
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMovies.count != 0 ? filteredMovies.count : 1
        } else if let sections = fetchedhResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
         }
     return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        if searchController.isActive && searchController.searchBar.text != "" {
            if filteredMovies.count != 0 {
                cell.setMoviewCellWith(movie: filteredMovies[indexPath.row])
            } else {
                cell.configureNoMovieFoundCell()
            }
        } else {
        if let movie = fetchedhResultController.object(at: indexPath) as? Movie {
          cell.setMoviewCellWith(movie: movie)
         }
        }
        return cell
    }
}

extension MovieViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.movieTableView.insertRows(at: [newIndexPath!], with: .automatic)
            
        case .delete:
            self.movieTableView.deleteRows(at: [indexPath!], with: .automatic)
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       self.movieTableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.movieTableView.beginUpdates()
    }
}

extension MovieViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: serchBar delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.text = ""
       self.updateTable()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
           self.updateTable()
        }
    }
    
    // MARK: SearchResults delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = self.searchController.searchBar.text
        if searchText != "" {
            let searchPredicate = NSPredicate(format: "genre CONTAINS[c] %@", searchText!)
            filteredMovies = (self.fetchedhResultController.fetchedObjects?.filter() {
                return searchPredicate.evaluate(with: $0)
                } as! [Movie]?)!
                self.movieTableView.reloadData()
        }
    }
    
    // MARK: Private method
    
    private func updateTable() {
        self.fetchedhResultController.fetchRequest.predicate = nil
        do {
            try self.fetchedhResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.movieTableView.reloadData()
    }
}


