//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by prema janoti on 3/1/18.
//  Copyright © 2018 prema. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var separatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setMoviewCellWith(movie: Movie) {
            self.movieTitleLabel.text = movie.title
            self.ratingLabel?.text = "Raiting: " + String(describing: movie.rating)
            self.releaseYearLabel?.text = "Release In: " + String(describing: movie.releaseYear)
            if let url = movie.image {
                self.movieImage.downloadImageFrom(link: url, contentMode: .scaleToFill)
            }
    }
    
    func configureNoMovieFoundCell() {
        self.movieTitleLabel.text = "No Movie found"
        self.ratingLabel?.text = nil
        self.releaseYearLabel?.text = nil
        self.movieImage.image = nil
        self.separatorLabel.backgroundColor = UIColor.clear
    }
}
