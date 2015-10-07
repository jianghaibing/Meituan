//
//  DealCell.swift
//  Meituan
//
//  Created by baby on 15/10/2.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit

class DealCell: UICollectionViewCell {
    
    @IBOutlet weak var newDealIcon: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var currenPriceLabel: UILabel!
    @IBOutlet weak var oriPriceLabel: UILabel!
    @IBOutlet weak var soldCountLabel: UILabel!
    
    var deal:DealsModel!{
        didSet{
            self.image.sd_setImageWithURL(deal.image_url, placeholderImage: UIImage(named: "placeholder_deal"))
            self.titleLable.text = deal.title
            self.descLabel.text = deal.desc
            let currentPrice = deal.current_price
            let listPrice = deal.list_price
            self.currenPriceLabel.text = "￥" + NumberFormatStringTool.leaveNumberToTwoDecimal(currentPrice)
            self.oriPriceLabel.text = "￥" + NumberFormatStringTool.leaveNumberToTwoDecimal(listPrice)
            self.soldCountLabel.text = "已售\(deal.purchase_count)"
            
            let format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let nowString = format.stringFromDate(NSDate())
            self.newDealIcon.hidden = (deal.publish_date.compare(nowString) == .OrderedAscending)
        }
    }
    
    
}
