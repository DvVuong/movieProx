//
//  PopupConfirmVC.swift
//  Moffy
//
//  Created by MRX on 25/12/2023.
//

import UIKit

class PopupConfirmVC: BaseViewController {
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    var handler: Handler? = nil
    
    @IBAction func didTapNoButton(_ sender: Any) {
        noButton.applyGradientForText(to: "No")
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapYesButton(_ sender: Any) {
        handler?()
        yesButton.applyGradientForText(to: "Yes")
        self.dismiss(animated: true)
    }
}
