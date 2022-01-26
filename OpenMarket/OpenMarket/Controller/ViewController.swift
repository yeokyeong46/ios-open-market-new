//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    var testProductList: ProductList? = nil
    let networkController = NetworkConnector()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProductListData(page: 1, num: 5)
        setSegmentControl()
    }
    
    func fetchProductListData(page pageNumber: Int, num itemsPerPage: Int) {
        self.networkController.requestGET(path: "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)", type: ProductList.self) {
            result in
            switch result {
            case .success(let data):
                self.testProductList = data
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    func setSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlchanged), for: UIControl.Event.valueChanged)
    }
    
    @objc
    func segmentControlchanged() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            testLabel.text = "list!"
        case 1:
            testLabel.text = "grid!"
        default:
            testLabel.text = "sth wrong"
        }
    }
}







