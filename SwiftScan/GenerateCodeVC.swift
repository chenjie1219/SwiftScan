//
//  GenerateCodeVC.swift
//  SwiftScan
//
//  Created by Jason on 2018/12/4.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

class GenerateCodeVC: UIViewController {

    @IBOutlet weak var QRCodeView: UIImageView!
    
    @IBOutlet weak var barCodeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        
        let myWechat = "https://u.wechat.com/EOgrqGHTuducITFPPMgka4M"
        
        let myWechatNum = "4234115"

        QRCodeView.image = UIImage.generateQRCode(myWechat, screenWidth - 80, UIImage(named: "avatar"), .orange)
        
        barCodeView.image = UIImage.generateCode128(myWechatNum, CGSize(width: screenWidth - 80, height: (screenWidth - 80)/3), .blue)
        
    }
    

 

}
