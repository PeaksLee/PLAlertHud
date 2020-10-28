//
//  ViewController.swift
//  PLAlertHud
//
//  Created by lifengfeng on 09/08/2020.
//  Copyright (c) 2020 lifengfeng. All rights reserved.
//

import UIKit
import PLAlertHud

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func clickButton(_ sender: Any) {
    
        let _ = PLAlertHud.show("标题", message: "信息", .alert, cancelTitle: "取消", ["确定"]) { (hud, isCancel, titile) in
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

