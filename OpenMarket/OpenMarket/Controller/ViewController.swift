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
    private var collectionView: UICollectionView! = nil
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
                self.configureDataSource()
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

// custom cell list view
extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, item) in
            cell.update(with: item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
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

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
            collectionView.alpha = 1.0
        case 1:
            collectionView.alpha = 0.0
            print("grid")
        default:
            collectionView.alpha = 1.0
        }
    }
}




