//
//  ViewController.swift
//  SwiftScan
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit
import SwiftScanner

class ViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ScannerVC()
        
        switch indexPath.row {
        case 0:
            
            //默认(push)
            vc.setupScanner { (code) in
                
                print(code)
                
                self.navigationController?.popViewController(animated: true)
            }
            
            navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            
            //默认(present)
            vc.setupScanner() { (code) in
                
                print(code)
                
                self.dismiss(animated: true, completion: nil)
            }
            
            present(vc, animated: true, completion: nil)
            
        case 2:
            
            //微信
            vc.setupScanner("微信扫一扫", .green, .default, "将二维码/条码放入框内，即可自动扫描") { (code) in
                
                print(code)
                
                self.navigationController?.popViewController(animated: true)
            }
            
            navigationController?.pushViewController(vc, animated: true)
            
        case 3:
            
            //支付宝
            vc.setupScanner("支付宝扫一扫", .blue, .grid, "放入框内，自动扫描") { (code) in
                
                print(code)
                
                self.navigationController?.popViewController(animated: true)
            }
            
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
        
        
    }
    
}

