//
//  DetailViewController.swift
//  Watchlist
//
//  Created by Kim Toy (Personal) on 3/31/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieInfoView: UIView!

    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: movieInfoView.frame.origin.y + movieInfoView.frame.size.height)
        
        titleLabel.text = movie["title"] as? String
        overviewLabel.text = movie["overview"] as? String

        overviewLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            posterImageView.setImageWith(imageUrl!)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
