//
//  MainTabbarVC.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit
import SnapKit

class MainTabbarVC: UITabBarController {
    
    private lazy var createButtonPlan: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.setBackgroundImage(UIImage(named: "addPlan"), for: .normal)
        btn.addTarget(self, action: #selector(didTapButtonCreate(_:)), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupViewController()
        self.view.addSubview(createButtonPlan)
        
        self.createButtonPlan.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalTo(self.tabBar)
            make.bottom.equalTo(self.tabBar.snp.top).offset(50)
        }
    }
    
    private func setupUI() {
        self.tabBar.layer.cornerRadius = 16
        self.tabBar.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.backgroundColor = UIColor(rgb: 0x040404)
    }
    
    private func setupViewController() {
        let homeVC = HomeVC()
        let homeTabBarItem = UITabBarItem(title: "",
                                          image: UIImage(named: "ic_home")?.withRenderingMode(.alwaysOriginal),
                                          selectedImage: UIImage(named: "ic_homeSelected")?.withRenderingMode(.alwaysOriginal))
        homeVC.tabBarItem = homeTabBarItem
        
        
        let movieVC = MovieVC()
        let movieTabBarItem = UITabBarItem(title: "",
                                                   image: UIImage(named: "ic_movie")?.withRenderingMode(.alwaysOriginal),
                                                   selectedImage: UIImage(named: "ic_MovieSelected")?.withRenderingMode(.alwaysOriginal))
        movieVC.tabBarItem = movieTabBarItem
        
        let tvshowVC = TvShowVC()
        let tvShowTabBarItem =  UITabBarItem(title: "",
                                                     image: UIImage(named: "ic_tvShow")?.withRenderingMode(.alwaysOriginal),
                                                     selectedImage: UIImage(named: "ic_tvShowSelected")?.withRenderingMode(.alwaysOriginal))
        tvshowVC.tabBarItem = tvShowTabBarItem
        
        let selifeVC = SelifeVC()
        
        let selifeTabBarItem = UITabBarItem(title: "",
                                                    image: UIImage(named: "ic_Selfile")?.withRenderingMode(.alwaysOriginal),
                                                    selectedImage: UIImage(named: "ic_SelfileSelected")?.withRenderingMode(.alwaysOriginal))
        selifeVC.tabBarItem = selifeTabBarItem
        
        
        let createPlanVC = CreatePlanVC()
        let createPlanTabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil)
        createPlanVC.tabBarItem = createPlanTabBarItem
        
        self.setViewControllers([homeVC, movieVC, createPlanVC, tvshowVC, selifeVC], animated: true)
    }
    
    @objc private func didTapButtonCreate(_ sender: UIButton) {
        let vc = CreatePlanVC()
        vc.hidesBottomBarWhenPushed = true
        self.push(to: vc, animated: true)
    }
}
