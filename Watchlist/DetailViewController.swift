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

        titleLabel.text = movie["title"] as? String
        overviewLabel.text = movie["overview"] as? String
        print(self.movieInfoView.frame.origin.y)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.movieInfoView.frame.origin.y = 350
        })
        print(self.movieInfoView.frame.origin.y)
        print(self.movieInfoView.frame.size.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: self.movieInfoView.frame.origin.y + self.movieInfoView.frame.size.height)

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
