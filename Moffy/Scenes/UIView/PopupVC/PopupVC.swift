//
//  PopupVC.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit

class PopupVC: BaseViewController {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var titlePopup: String = ""
    
    convenience init(with title: String) {
        self.init()
        self.titlePopup = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = titlePopup
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss(animated: true)
        
    }
    
    override func setProperties() {
        subView.conerRadius()
    }
}
