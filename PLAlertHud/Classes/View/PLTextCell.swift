//
//  PLTextCell.swift
//  PLAlertHud
//
//  Created by za on 2020/9/8.
//

import UIKit

enum PLTextCellType: Int {
    case Message = 0, Title, Action
}


class PLTextCell: UITableViewCell {
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var labelLeftMargin: NSLayoutConstraint!
    @IBOutlet var labelRightMargin: NSLayoutConstraint!
    @IBOutlet var labelTopMargin: NSLayoutConstraint!
    @IBOutlet var labelBottomMargin: NSLayoutConstraint!
    
    @IBOutlet var line: UIView!
    @IBOutlet var lineHeight: NSLayoutConstraint!
    
    var cellType: PLTextCellType = .Message
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        line.backgroundColor = UIColor.SeparatorColor
        lineHeight.constant = CGFloat.Alert.SeparatorHeight
        contentLabel.minimumScaleFactor = 0.7
        contentLabel.lineBreakMode = .byTruncatingMiddle
    }
    
    
    func setType(type: PLTextCellType) -> Void {
        cellType = type
        line.isHidden = type != .Action
        contentLabel.numberOfLines = type == .Action ? 1 : 0;
        contentLabel.adjustsFontSizeToFitWidth = type == .Action
        
        labelLeftMargin.constant = (type == .Action ? CGFloat.Alert.ActionHorizontalMargin : CGFloat.Alert.TextHorizontalMargin)
        labelRightMargin.constant = (type == .Action ? CGFloat.Alert.ActionHorizontalMargin : CGFloat.Alert.TextHorizontalMargin)
        labelTopMargin.constant = 0
        labelBottomMargin.constant = 0
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if case .Action = cellType {
            if highlighted {
                self.contentView.backgroundColor = UIColor.SeparatorColor
            } else {
                UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.contentView.backgroundColor = UIColor.clear
                }, completion: nil)
            }
        }
    }
    
}
