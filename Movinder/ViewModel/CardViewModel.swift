//
//  CardViewModel.swift
//  Movinder
//
//  Created by Max on 26.02.21.
//

import UIKit


class CardViewModel {
    
    
    
    let movie: Movie
    
    private var imageIndex = 0
    let userInfoText: NSAttributedString
    
    
    var imageUrl: URL?

    
    init(movie: Movie){
        self.movie = movie
        
        let attributedText = NSMutableAttributedString(string: movie.name, attributes: [.font: UIFont.systemFont(ofSize: 32,weight: .heavy), .foregroundColor: UIColor.white])
        
//        attributedText.append(NSAttributedString(string: "  \(movie.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        
        self.userInfoText = attributedText
        
        self.imageUrl = URL(string: movie.coverImageUrl)
    }
    
    func showNextPhoto(){
        //guard imageIndex < user.images.count - 1 else { return }
        //imageIndex += 1
        //self.imageToShow = user.images[imageIndex]
    }
    
    func showPreviousPhoto(){
        //guard imageIndex > 0 else { return }
        //imageIndex -= 1
        //self.imageToShow = user.images[imageIndex]
    }
}
