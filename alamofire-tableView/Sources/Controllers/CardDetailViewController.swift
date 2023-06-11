//
//  CardDetailViewController.swift
//  alamofire-tableView-mvvm
//
//  Created by Zhuldyz Bukeshova on 11.06.2023.
//

import UIKit
import Alamofire

class CardDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    private lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    private lazy var name: UILabel = {
        var name = UILabel()
        name.font = .boldSystemFont(ofSize: 20)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var type: UILabel = {
        var type = UILabel()
        type.font = .systemFont(ofSize: 15)
        type.translatesAutoresizingMaskIntoConstraints = false
        return type
    }()
    
    private lazy var imageUrl: UIImageView = {
        var imageUrl = UIImageView()
        imageUrl.translatesAutoresizingMaskIntoConstraints = false
        return imageUrl
    }()
    
    var cardItems: Card? {
        didSet {
            self.name.text = cardItems?.name
            self.type.text = cardItems?.type
            
            guard let imagePath = cardItems?.imageUrl, let imageUrl = URL(string: imagePath) else {
                self.imageUrl.image = UIImage(named: "noPicture")
                return
            }
            
            AF.request(imageUrl).responseData { [weak self] response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.imageUrl.image = UIImage(data: data)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.imageUrl.image = UIImage(named: "noPicture")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setups
    
    private func setupHierarchy() {
        view.addSubview(mainStackView)
        mainStackView.addSubview(name)
        mainStackView.addSubview(type)
        mainStackView.addSubview(imageUrl)
    }
    
    private func setupLayout() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        imageUrl.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
        imageUrl.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 7).isActive = true
        
        name.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: imageUrl.bottomAnchor, constant: 30).isActive = true
        
        type.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
        type.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30).isActive = true
    }
}
