//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var testProductList: ProductList? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        NetworkConnector.checkHealth() {
            output in
            if output == true {
                let pageNumber = 1
                let itemsPerPage = 20
                NetworkConnector.requestGET(apiPath: "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)", type: ProductList.self) {
                    (errorStatus, output) in
                    guard let output = output else {
                        print(errorStatus?.description)
                        return
                    }
                    self.testProductList = output
                    self.myTableView.reloadData()
                    print(output)
                }
                
                let productId = 522
                NetworkConnector.requestGET(apiPath: "api/products/\(productId)", type: ProductDetail.self) {
                    (errorStatus, output) in
                    guard let output = output else {
                        print(errorStatus?.description)
                        return
                    }
                    print(output)
                }
            }
            else { print("check state of the api") }
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



