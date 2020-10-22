//
//  FilmTableViewController.swift
//  FindTheFilm
//
//  Created by  石明杰 on 2020/10/21.
//

import UIKit

private enum State {
    case loading
    case populated(Film?)
    
    var currentRecording: Film? {
        switch self {
        case .populated(let recordings):
            return recordings
        default:
            return nil
        }
    }
}

class FilmTableViewController: UITableViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let networkingService = NetworkingService()
    
    var chosenFilm: Search!
    
    private var state = State.loading {
        didSet {
            setFooterView()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.gray
        
        navigationItem.title = chosenFilm.title.capitalized
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 18)!]
        
        loadFilm(chosenFilm.imdbID)
        
        setFooterView()
        tableView.estimatedRowHeight = 5
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    private func loadFilm(_ filmImbdbID: String) {
        
        //        weak var aBlockSelf = self another way to create a self link???
        
        networkingService.fetchFilmRecording(matching: filmImbdbID) { [weak self] response in
            
            guard let `self` = self else {
                return
            }
            
            self.state = .populated(response.recordings)
            
            self.tableView.reloadData()
        }
    }
    
    private func setFooterView() {
        switch state {
        case .loading:
            tableView.tableFooterView = loadingView
        case .populated:
            tableView.tableFooterView = UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //count number of properties in Film Class for counting cells by custom func propertyNames()
        // count -1 because of poster property
        guard let count = state.currentRecording?.propertyNames().count else { return 0 }
        return count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilmTableViewCell
        
        guard let film = state.currentRecording else { return cell }
        
        if let imageUrl = URL(string: film.poster) {
            if let data = try? Data(contentsOf: imageUrl) {
                let image = UIImage(data: data)
                posterView.image = image
            } else {
                posterView.image = #imageLiteral(resourceName: "imageNotFound")
            }
        }
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Title"
            cell.valueLabel.text = film.title
        case 1:
            cell.keyLabel.text = "Year"
            cell.valueLabel.text = film.year
        case 2:
            cell.keyLabel.text = "Director"
            cell.valueLabel.text = film.director
        case 3:
            cell.keyLabel.text = "Actors"
            cell.valueLabel.text = film.actors
        case 4:
            cell.keyLabel.text = "Country"
            cell.valueLabel.text = film.country
        case 5:
            cell.keyLabel.text = "Rating"
            cell.valueLabel.text = film.rating
        case 6:
            cell.keyLabel.text = "Plot"
            cell.valueLabel.text = film.plot
        default:
            break
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
