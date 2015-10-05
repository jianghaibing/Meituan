//
//  SearchDealsCollectionViewController.swift
//  Meituan
//
//  Created by baby on 15/10/4.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class SearchDealsCollectionViewController: BaseDealsViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var keyword:String?

    @IBAction func backbuttonClick(sender: UIButton) {
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func setupParams(params: NSMutableDictionary) {
        super.setupParams(params)
        params["city"] = cityName
        params["keyword"] = keyword
    }

    //MARK: - 搜索框代理
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        keyword = searchBar.text
        searchBar.resignFirstResponder()
        requestNewDeals()
    }
    
}
