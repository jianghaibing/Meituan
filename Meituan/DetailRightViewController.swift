//
//  DetailRightViewController.swift
//  Meituan
//
//  Created by baby on 15/10/5.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class DetailRightViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var detailWebView: UIWebView!
    var deal:DealsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rangeIndex = deal.deal_id.rangeOfString("-")?.endIndex
        let urlStr = "http://m.dianping.com/tuan/deal/moreinfo/" + deal.deal_id.substringFromIndex(rangeIndex!)
        let url = NSURL(string: urlStr)
        print(deal.deal_id)
        detailWebView.loadRequest(NSURLRequest(URL: url!))
        MBProgressHUD.showHUDAddedTo(splitViewController!.view, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //删除H5页面中不要的元素
        let js1 = "var header = document.getElementsByTagName('header')[0];"
        let js2 = "header.parentNode.removeChild(header);"
        let js3 = "var box = document.getElementsByClassName('cost-box')[0];"
        let js4 = "box.parentNode.removeChild(box);"
        let js5 = "var bottom = document.getElementsByClassName('buy-now')[0];"
        let js6 = "bottom.parentNode.removeChild(bottom);"
        let js7 = "var footer = document.getElementsByTagName('footer')[0];"
        let js8 = "footer.parentNode.removeChild(footer);"
        let js = js1+js2+js3+js4+js5+js6+js7+js8
        webView.stringByEvaluatingJavaScriptFromString(js)
        MBProgressHUD.hideHUDForView(splitViewController!.view, animated: true)
    }
    
}
