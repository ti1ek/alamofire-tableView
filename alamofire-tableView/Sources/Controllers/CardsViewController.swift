//
//  ViewController.swift
//  alamofire-tableView-mvvm
//
//  Created by Zhuldyz Bukeshova on 28.05.2023.
//

import UIKit
import Alamofire

class CardsViewController: UIViewController {
    
    // MARK: - Outlets
    
    private var cards = [Card]()
    private var filteredCards = [Card]()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 150
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search name card..."
        return searchController
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cards"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        definesPresentationContext = true
        
        setupHierarchy()
        setupLayout()
        fetchData()
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        navigationItem.searchController = searchController
    }
    
    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - Fetching data
    
    func fetchData() {
        AF.request("https://api.magicthegathering.io/v1/cards").responseDecodable(of: Cards.self) { response in
            switch response.result {
            case .success(let cardData):
                self.cards = cardData.cards
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extensions

extension CardsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCards.count : cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath) as? CardTableViewCell else {
            return UITableViewCell()
        }
        
        let card = isFiltering ? filteredCards[indexPath.row] : cards[indexPath.row]
        cell.card = card
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let card = isFiltering ? filteredCards[indexPath.row] : cards[indexPath.row]
        let vc = CardDetailViewController()
        vc.cardItems = card
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CardsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            filteredCards = []
            tableView.reloadData()
            return
        }
        
        filteredCards = cards.filter { $0.name.lowercased().contains(searchText) }
        tableView.reloadData()
    }
}
