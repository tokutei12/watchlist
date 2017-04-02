//
//  MoviesViewController.swift
//  Watchlist
//
//  Created by Kim Toy (Personal) on 3/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import ChameleonFramework

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    var movies: [NSDictionary]?
    var endpoint: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        self.networkRequest(requestCompleteCallback: { _ in })
    }
    
    func networkRequest(requestCompleteCallback: @escaping () -> Void) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)/?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    self.errorView.isHidden = true
                    self.errorView.frame.size.height = 0
                    
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                    }
                }
                
                if error != nil {
                    self.errorView.isHidden = false
                    self.errorView.frame.size.height = 44
                }
                
                MBProgressHUD.hide(for: self.view, animated: true)
                requestCompleteCallback()
            }
        );
        task.resume()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        networkRequest(requestCompleteCallback: {
            () -> Void in
                refreshControl.endRefreshing()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String

        cell.titleLabel.text = title
        cell.overviewLabel.text = movie["overview"] as? String
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)

            let imageUrlRequest = URLRequest(url: imageUrl!)
            cell.posterView.setImageWith(
                imageUrlRequest,
                placeholderImage: nil,
                success: {(imageRequest, imageResponse, image) -> Void in
                    if imageResponse != nil {
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        cell.posterView.image = image
                    }
                },
                failure: {(imageRequest, imageResponse, error) -> Void in
                    // do nothing
                }
            )
        }

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        self.tableView.deselectRow(at: indexPath!, animated: true)
        
        let movie = movies![indexPath!.row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }

}
