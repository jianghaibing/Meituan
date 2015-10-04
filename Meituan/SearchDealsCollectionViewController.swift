//
//  SearchDealsCollectionViewController.swift
//  Meituan
//
//  Created by baby on 15/10/4.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class SearchDealsCollectionViewController: BaseDealsViewController,UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backbuttonClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    //MARK: - 搜索框代理
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("点击了搜索按钮")
    }
    
}
