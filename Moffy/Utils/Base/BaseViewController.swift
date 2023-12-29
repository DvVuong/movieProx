//
//  BaseViewController.swift
//  Moffy
//
//  Created by macbook on 14/12/2023.
//

import UIKit
import Combine

class BaseViewController: UIViewController, ViewProtocol {
    var subscriptions = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        setProperties()
        binding()
        //print("====> \(self.className) viewDidLoad")
    }
    
    deinit {
        //print("<==== \(self.className) deinit")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setColor()
    }
    
    func addComponents() {}
    
    func setConstraints() {}
    
    func setProperties() {}
    
    func setColor() {}
    
    func binding() {}
}
