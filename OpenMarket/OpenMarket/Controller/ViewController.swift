//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var testProductList: ProductList? = nil
    let networkController = NetworkConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        networkController.checkHealth() {
            result in
            switch result {
            case .success(let data):
                if data == true {
                    let pageNumber = 1
                    let itemsPerPage = 20
                    self.networkController.requestGET(path: "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)", type: ProductList.self) {
                        result in
                        switch result {
                        case .success(let data):
                            self.testProductList = data
                            self.myTableView.reloadData()
                        case .failure(let error):
                            print(error.description)
                        }
                    }
                    let productId = 522
                    self.networkController.requestGET(path: "api/products/\(productId)", type: ProductDetail.self) {
                        result in
                        switch result {
                        case .success(let data):
                            print(data)
                        case .failure(let error):
                            print(error.description)
                        }
                    }
                } else {
                    print("check state of the api")
                }
            case .failure(let error):
                print(error.description)
            }
        } 
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testProductList?.products.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TmpTableViewCell = myTableView.dequeueReusableCell(withIdentifier: "TmpTableViewCell", for: indexPath) as! TmpTableViewCell
        cell.myLabel.text = testProductList?.products[indexPath.row].name
        return cell
    }
}



