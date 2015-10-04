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
            self.currenPriceLabel.text = "￥" + leaveNumberToTwoDecimal(currentPrice)
            self.oriPriceLabel.text = "￥" + leaveNumberToTwoDecimal(listPrice)
            self.soldCountLabel.text = "已售\(deal.purchase_count)"
            
            let format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let nowString = format.stringFromDate(NSDate())
            self.newDealIcon.hidden = (deal.publish_date.compare(nowString) == .OrderedAscending)
        }
    }
    
    ///如果大于2位小数保留2位小数，其余都等于本身
    private func leaveNumberToTwoDecimal(number:NSNumber) -> String{
        if let dotLocation = number.stringValue.rangeOfString(".")?.last,let length = number.stringValue.rangeOfString(number.stringValue)?.last{
            if Int(String(length))! - Int(String(dotLocation))! > 2 {
                let stringValue = String(format: "%.2f", number.floatValue)
                return stringValue
            }else{
                return number.stringValue
            }
        }else{
            return number.stringValue
        }
    }
    
}
