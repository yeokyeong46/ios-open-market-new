//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

private enum Section: Hashable {
    case main
}

class ViewController: UIViewController {
    
    // api data
    let networkController = NetworkConnector()
    var testProductList: ProductList? = nil
    var products: [Product] = []
    
    // storyboard
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // custom cell list view
    private var collectionListView: UICollectionView! = nil
    private var collectionGridView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProductListData(page: 1, num: 20)
        setSegmentControl()
    }
}

// for fetch data
extension ViewController {
    func fetchProductListData(page pageNumber: Int, num itemsPerPage: Int) {
        self.networkController.requestGET(path: "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)", type: ProductList.self) {
            result in
            switch result {
            case .success(let data):
                self.testProductList = data
                self.products = data.products
                self.configureCollectionView()
                self.configureGridCollectionView()
                self.configureDataSource()
                self.configureGridDataSource()
                self.collectionListView.alpha = 1.0
                self.collectionGridView.alpha = 0.0
                
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

extension ViewController {
    // list
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionListView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionListView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, item) in
            cell.update(with: item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionListView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    //grid
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height * 0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(8)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureGridCollectionView() {
        collectionGridView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        collectionGridView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionGridView)
        collectionGridView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionGridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductGridCell, Product> { (cell, indexPath, item) in
            cell.configCell(with: item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionGridView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController {
    // for segment controller
    func setSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlchanged), for: UIControl.Event.valueChanged)
    }
    
    @objc
    func segmentControlchanged() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            collectionListView.alpha = 1.0
            collectionGridView.alpha = 0.0
        case 1:
            collectionListView.alpha = 0.0
            collectionGridView.alpha = 1.0
        default:
            collectionListView.alpha = 1.0
            collectionGridView.alpha = 0.0
        }
    }
}




