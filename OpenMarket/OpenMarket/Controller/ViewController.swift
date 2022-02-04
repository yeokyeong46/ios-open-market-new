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
    
    let networkController = NetworkConnector()
    var productList: ProductList? = nil
    var products: [Product] = []
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loadingLabel: UILabel!
    
    private var collectionListView: UICollectionView! = nil
    private var collectionGridView: UICollectionView! = nil
    private var listDataSource: UICollectionViewDiffableDataSource<Section, Product>! = nil
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, Product>! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()

    override func viewDidLoad() {
        super.viewDidLoad()
        snapshot.appendSections([.main])
        makeListView()
        makeGridView()
        setSegmentControl()
        
        fetchProductListData(page: 1, num: 3)
        fetchProductListData(page: 2, num: 3)
        fetchProductListData(page: 3, num: 3)
    }
}

extension ViewController {
    func fetchProductListData(page pageNumber: Int, num itemsPerPage: Int) {
        self.networkController.requestGET(path: "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)", type: ProductList.self) {
            result in
            switch result {
            case .success(let data):
                
                self.setProductData(with: data)
                self.appendDatasToSnapshot(products: data.products)
                
                self.collectionListView.alpha = 1.0
                self.collectionGridView.alpha = 0.0
                
                self.loadingLabel.isHidden = true
                
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

extension ViewController {
    private func setProductData(with data: ProductList) {
        self.productList = data
        self.products = data.products
    }
    
    private func makeListView() {
        self.configureListHierarchy()
        self.configureListDataSource()
    }
    
    private func makeGridView() {
        self.configureGridHierarchy()
        self.configureGridDataSource()
    }
}

extension ViewController {
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

extension ViewController {
    // list
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureListHierarchy() {
        collectionListView = UICollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: createListLayout())
        collectionListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionListView)
        collectionListView.delegate = self
    }
    
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, item) in
            cell.update(with: item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        listDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionListView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
    }
    
    //grid
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(view.bounds.height*0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(8)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureGridHierarchy() {
        collectionGridView = UICollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: createGridLayout())
        collectionGridView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionGridView)
        collectionGridView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionGridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionGridView.delegate = self
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductGridCell, Product> { (cell, indexPath, item) in
            cell.configCell(with: item)
        }
        
        gridDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionGridView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func appendDatasToSnapshot(products: [Product]) {
        
        snapshot.appendItems(products)
        gridDataSource.apply(snapshot, animatingDifferences: true)
        listDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionListView.deselectItem(at: indexPath, animated: true)
        collectionGridView.deselectItem(at: indexPath, animated: true)
        print(indexPath)
        print(products[indexPath.row])
    }
}






