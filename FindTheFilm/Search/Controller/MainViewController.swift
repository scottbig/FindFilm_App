//
//  MainViewController.swift
//  FindTheFilm
//
//  Created by  石明杰 on 2020/10/21.
//

import UIKit

private enum State {
    case loading
    case populated([Search])
    case empty
    case error(Error)
    case paging([Search], next: Int)

    var currentRecording: [Search] {
        switch self {
        case .populated(let recordings):
            return recordings
        case .paging(let recordings, _):
            return recordings
        default:
            return []
        }
    }
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    let networkingService = NetworkingService()
    private var state = State.loading {
        didSet {
            setFooterView()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find The Film"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // hide keyboard when scrolling
        tableView.keyboardDismissMode = .onDrag
        activityIndicator.color = UIColor.gray
        prepareNavigationBar()
        prepareSearchBar()
        prepareTableView()
        loadRecordings()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 19)!]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Loading recordings
    
    @objc private func loadRecordings() {
        state = .loading
        loadPage(1)
    }
    
    private func update(response: RecordingsResult) {
        if let error = response.error {
            state = .error(error)
            return
        }
        
        guard let newRecordings = response.recordings, !newRecordings.isEmpty else {
            state = .empty
            setFooterView()
            tableView.reloadData()
            return
        }
        
        var allRecordings = state.currentRecording
        allRecordings.append(contentsOf: newRecordings)
        
        if response.hasMorePages {
            state = .paging(allRecordings, next: response.nextPage)
        } else {
            state = .populated(allRecordings)
        }
        
        setFooterView()
        tableView.reloadData()
    }
    
    func setFooterView() {
        switch state {
        case .loading:
            tableView.tableFooterView = loadingView
            activityIndicator.startAnimating()
        case .error(let error):
            errorLabel.text = error.localizedDescription
            tableView.tableFooterView = errorView
        case .empty:
            tableView.tableFooterView = emptyView
        case .populated:
            tableView.tableFooterView = nil
        case .paging:
            tableView.tableFooterView = loadingView
        }
    }
    
    func loadPage(_ page: Int) {
        
        let query = searchController.searchBar.text
        networkingService.fetchSearchRecordings(matching: query, page: page) { [weak self] response in
            
            guard let `self` = self else {
                return
            }
            
//            self.searchController.searchBar.endEditing(true)
            self.update(response: response)
        }
        
    }
    
    // MARK: - View Configuration
    
    func prepareSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        
        let whiteTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let textFieldInSearchBar = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        textFieldInSearchBar.defaultTextAttributes = whiteTitleAttributes
        
        navigationItem.searchController = searchController
        searchController.searchBar.becomeFirstResponder()
      
        // hide seachbar when it goes to another VC
        definesPresentationContext = true
    }
    
    func prepareNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.gray
        
        let whiteTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = whiteTitleAttributes
    }
    
    func prepareTableView() {
        tableView.dataSource = self
        
        let nib = UINib(nibName: FilmsTableViewCell.NibName, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: FilmsTableViewCell.ReuseIdentifier)
    }
    
}

// MARK: -

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(loadRecordings),
                                               object: nil)
        
        perform(#selector(loadRecordings), with: nil, afterDelay: 0.5)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        loadPage(1)
        self.tableView.reloadData()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.currentRecording.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmsTableViewCell.ReuseIdentifier)
            as? FilmsTableViewCell else {
                return UITableViewCell()
        }
        
        cell.load(search: state.currentRecording[indexPath.row])
        
        if case .paging(_, let nextPage) = state, indexPath.row == state.currentRecording.count - 1 {
            loadPage(nextPage)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilmTableViewController") as! FilmTableViewController

        self.navigationController?.pushViewController(vc, animated: true)
        
        let search = state.currentRecording[indexPath.row]
        
        vc.chosenFilm = search
    }
    
}
