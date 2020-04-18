//
//  OnlineImageViewController.swift
//  ImageLoader
//
//  Created by Jin Lee on 15/4/20.
//  Copyright © 2020 Jin Lee. All rights reserved.
//

import UIKit

struct ImageFeed: Decodable {
    var width: Int
    var height: Int
    var imgPath: String
}

class OnlineImageViewController: UITableViewController {

    var feeds  = [ImageFeed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Online Images"
        
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        loadFeed { [weak self] result in
            switch result {
            case .success(let feeds):
                self?.feeds = feeds
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
        
        cell.feed = feeds[indexPath.row]
        return cell
    }

}

extension OnlineImageViewController {
    
    func loadFeed(completion: @escaping (Result<[ImageFeed], Error>) -> Void) {
        
        URLSession.shared.dataTask(with: URL(string: "https://restkittens.herokuapp.com/")!) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(DataResponseError.network))
                    }
                    return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            print("Feed: \(data)")

            guard let decodedResponse = try? jsonDecoder.decode([ImageFeed].self, from: data) else {
                DispatchQueue.main.async {
                    completion(.failure(DataResponseError.decoding))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(decodedResponse))
            }
            
        }.resume()
    }
}


enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data"
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}
