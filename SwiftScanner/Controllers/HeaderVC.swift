//
//  HeaderVC.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

public protocol HeaderViewControllerDelegate: class{
    
    func didClickedCloseButton()
    
}


public class HeaderVC: UIViewController {
    
    
    /// 设置present方式时的导航栏标题
    public override var title: String? {
        didSet{
            titleItem.title = title
        }
    }
    
    public lazy var closeImage = imageNamed("icon_back")
    
    @IBOutlet weak public var navigationBar: UINavigationBar!
    
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    public weak var delegate:HeaderViewControllerDelegate?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        let bundle = Bundle(for: HeaderVC.self)
        
        super.init(nibName: nibNameOrNil, bundle: bundle)
        
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: statusHeight + navigationBar.frame.height)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setupUI()
        
    }
    
    @IBAction func closeBtnClick(_ sender: Any) {
        
        delegate?.didClickedCloseButton()
    }
    
    
}




// MARK: - CustomMethod
extension HeaderVC{
    
    func setupUI() {
        
        closeBtn.setBackButtonBackgroundImage(closeImage, for: .normal, barMetrics: .default)
        
    }
}


extension HeaderVC:UINavigationBarDelegate {
    
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}
