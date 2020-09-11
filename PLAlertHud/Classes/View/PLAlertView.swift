//
//  PLAlertView.swift
//  PLAlertHud
//
//  Created by za on 2020/9/8.
//

import UIKit

class PLAlertView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: PLAlertHudDelegate?
    var textTableView: UITableView?
    var leftButton: UIButton?
    var rightButton: UIButton?
    var actionTableView: UITableView?
    var alertData: PLAlertData?
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.setupUI()
    }
    
    func reloadUI(with alertData: PLAlertData) {
        self.alertData = alertData
        textTableView?.reloadData()
        createActionView()
        updateFrame()
    }
    
    func updateFrame() {
        
        layoutIfNeeded()
        
        var y: CGFloat = 0
        let actionCount: Int = alertData?.actions.count ?? 0
        
        if textCount() == 0 {
            textTableView?.removeFromSuperview()
        } else {
            let textContentHeight = textTableView?.contentSize.height ?? 0
            var actionHeight: CGFloat = 0
            if actionCount > 0 {
                actionHeight = (actionCount > 3 ? 3.5 : (actionCount < 3 ? 1 : CGFloat(actionCount))) * CGFloat.Alert.ActionHeight
            }
            let textTableHeight: CGFloat = min(CGFloat.ScreenHeight-CGFloat.Alert.AlertVerticalMargin*2-actionHeight-CGFloat.Alert.TitleTopMargin*2, textContentHeight)
            
            textTableView?.bounces = textTableHeight != textContentHeight
            textTableView?.showsVerticalScrollIndicator = textTableHeight != textContentHeight
            textTableView?.frame = CGRect(origin: CGPoint(x: 0, y: CGFloat.Alert.TitleTopMargin), size: CGSize(width: CGFloat.Alert.Width, height: textTableHeight))
            y += (textTableHeight + CGFloat.Alert.TitleTopMargin*2)
            
            let whiteLayer: CALayer = CALayer()
            whiteLayer.backgroundColor = UIColor.Backgroud.Alert.cgColor
            whiteLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat.Alert.Width, height: y))
            layer.insertSublayer(whiteLayer, below: textTableView?.layer)
        }
        
        if actionCount > 0 {
            y += CGFloat.Alert.SeparatorHeight
            
            if actionCount == 1 {
                leftButton?.frame = CGRect(x: 0, y: y, width: CGFloat.Alert.Width, height: CGFloat.Alert.ActionHeight)
                y += CGFloat.Alert.ActionHeight
            } else if actionCount == 2 {
                let width: CGFloat = (CGFloat.Alert.Width-CGFloat.Alert.SeparatorHeight)/2
                leftButton?.frame = CGRect(x: 0, y: y, width: width, height: CGFloat.Alert.ActionHeight)
                rightButton?.frame = CGRect(x: width+CGFloat.Alert.SeparatorHeight, y: y, width: width, height: CGFloat.Alert.ActionHeight)
                y += CGFloat.Alert.ActionHeight
            } else {
                let actionContentHeight = CGFloat.Alert.ActionHeight*CGFloat(actionCount)
                let actionTableHeight: CGFloat = min(CGFloat.ScreenHeight-CGFloat.Alert.AlertVerticalMargin*2-y, actionContentHeight)
                
                actionTableView?.bounces = actionTableHeight != actionContentHeight
                actionTableView?.showsVerticalScrollIndicator = actionTableHeight != actionContentHeight
                actionTableView?.frame = CGRect(x: 0, y: y, width: CGFloat.Alert.Width, height: actionTableHeight)
                y += actionTableHeight
        
                if let _ = alertData?.cancelAction, let count = alertData?.actions.count {
                    actionTableView?.scrollToRow(at: NSIndexPath(row: count-1, section: 0) as IndexPath, at: .bottom, animated: false)
                }
            }
        }
        
        frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat.Alert.Width, height: y))
    }
    
    
    func setupUI() {
        
        backgroundColor = UIColor.SeparatorColor
        layer.cornerRadius = CGFloat.Alert.CornerRadius
        layer.masksToBounds = true
        
        textTableView = PLAlertView.createTableView(delegate: self)
        textTableView?.frame = CGRect(x: 0, y: 0, width: CGFloat.Alert.Width, height: CGFloat.Alert.TitleTopMargin*2)
        textTableView?.rowHeight = UITableViewAutomaticDimension
        addSubview(textTableView!)
        
    }
    
    func createActionView() {
        
        let actionCount: Int = alertData?.actions.count ?? 0
        
        if actionCount > 2 {
            actionTableView = PLAlertView.createTableView(delegate: self)
            actionTableView?.rowHeight = CGFloat.Alert.ActionHeight
            addSubview(actionTableView!)
        } else if actionCount == 2 || actionCount == 1 {
            
            let width: CGFloat = (CGFloat.Alert.Width-CGFloat.Alert.SeparatorHeight)/CGFloat(actionCount)
            leftButton = PLAlertView.createButton(width: width, action: alertData!.actions.first!)
            leftButton?.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
            addSubview(leftButton!)
            
            if actionCount == 2 {
                rightButton = PLAlertView.createButton(width: width, action: alertData!.actions.last!)
                rightButton?.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
                addSubview(rightButton!)
            }
        }
        
    }
    
    //MARK: 创建列表视图
    class func createTableView(delegate: UIView?) -> UITableView {
        
        let tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        if let tableDelegate = delegate {
            tableView.delegate = tableDelegate as? UITableViewDelegate
            tableView.dataSource = tableDelegate as? UITableViewDataSource
        }
        tableView.register(UINib(nibName: "PLAlertHud.bundle/PLTextCell", bundle: Bundle.init(for: PLTextCell.self)), forCellReuseIdentifier: String(describing: PLTextCell.self))
        tableView.backgroundColor = UIColor.Backgroud.Alert
        tableView.estimatedRowHeight = CGFloat.Alert.TitleTopMargin*2
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }
    
    //MARK: 创建按钮
    class func createButton(width: CGFloat, action: PLAlertAction) -> UIButton {
        
        let button: UIButton = UIButton(type: .custom)
        button.backgroundColor = UIColor.Backgroud.Alert
        button.setBackgroundImage(PLAlertAction.highlightedImage(color: UIColor.SeparatorColor, size: CGSize(width: width, height: CGFloat.Alert.ActionHeight)), for: .highlighted)
        button.titleLabel?.minimumScaleFactor = 0.7
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.setTitle(action.title, for: .normal)
        button.setTitleColor(action.titleColor, for: .normal)
        button.titleLabel?.font = action.titleFont
        
        return button
    }
    
    //MARK: 点击按钮
    @objc
    func buttonClick(button: UIButton) {
        self.delegate?.alertActionDidClick(action: button.currentTitle)
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == actionTableView ? alertData?.actions.count : textCount()) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == actionTableView {
            let textCell: PLTextCell = self.textCell(with: .Action, action: alertData?.actions[indexPath.row])
            textCell.line.isHidden = indexPath.row == alertData!.actions.count-1
            return textCell
        } else {
            
            if indexPath.row == 0 && (alertData?.title != nil || alertData?.titelAttributeString != nil) {
                return textCell(with: .Title)
            }
            return textCell(with: .Message)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == actionTableView {
            let textCell: PLTextCell = tableView.cellForRow(at: indexPath) as! PLTextCell
            self.delegate?.alertActionDidClick(action: textCell.contentLabel.text)
        }
    }
    
    func textCell(with type: PLTextCellType, action: PLAlertAction? = nil) -> PLTextCell {
        
        let tableView: UITableView = (type == .Action ? actionTableView : textTableView)!
        let textCell: PLTextCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PLTextCell.self)) as! PLTextCell
        textCell.setType(type: type)
        
        if let alertAction = action {
            textCell.contentLabel.text = alertAction.title
            textCell.contentLabel.textColor = alertAction.titleColor
            textCell.contentLabel.font = alertAction.titleFont
        } else {
            if case .Title = type {
                if let attributeString = alertData?.titelAttributeString {
                    textCell.contentLabel.attributedText = attributeString
                }
            } else {
                
                if alertData?.title != nil || alertData?.titelAttributeString != nil {
                    textCell.labelTopMargin.constant = CGFloat.Alert.MessageTopMargin
                }
                
                if let attributeString = alertData?.messageAttributeString {
                    textCell.contentLabel.attributedText = attributeString
                } 
            }
        }
        
        return textCell
    }
    
    func textCount() -> Int {
        var count: Int = 0
        
        if alertData?.title != nil || alertData?.titelAttributeString != nil {
            count += 1
        }
        
        if alertData?.message != nil || alertData?.messageAttributeString != nil {
            count += 1
        }
        return count
    }
    
}
