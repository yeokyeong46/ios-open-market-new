//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkConnector.checkHealth()
        
        let pageNumber = 1
        let itemsPerPage = 10
        NetworkConnector.requestGET(api: "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)", type: ProductList.self)
        
        let productId = 522
        NetworkConnector.requestGET(api: "api/products/\(productId)", type: ProductDetail.self)
    }


}



