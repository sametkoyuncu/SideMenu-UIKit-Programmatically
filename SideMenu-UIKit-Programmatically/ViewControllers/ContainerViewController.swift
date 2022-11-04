//
//  ViewController.swift
//  SideMenu-UIKit-Programmatically
//
//  Created by fmss on 3.11.2022.
//

import UIKit

class ContainerViewController: UIViewController {
    
    
    enum MenuState {
        case opened
        case closed
        
        mutating func toggle() {
            switch self {
            case .opened:
                self = .closed
            case .closed:
                self = .opened
            }
        }
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()
    lazy var infoVC = InfoViewController()
    var navVC: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        addChildVCs()
    }
    
    func addChildVCs() {
        // Menu
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // Home
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
 
}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
       toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        // Animate the menu
        switch menuState {
        case .closed:
            // open it
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
            } completion: { [weak self] done in
                if done {
                    self?.menuState.toggle()
                }
            }
        case .opened:
            // close it
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState.toggle()
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
    
}

extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menu menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem {
        case .home:
            resetToHome()
        case .info:
            addInfo()
        case .appRating:
            break
        case .shareApp:
            break
        case .settings:
            break
        }
    }
    
    func addInfo() {
        let vc = infoVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.bounds
        vc.didMove(toParent: homeVC)
        homeVC.title = vc.title 
    }
    
    func resetToHome() {
        infoVC.view.removeFromSuperview()
        infoVC.didMove(toParent: nil)
        homeVC.title = "Home"
    }
}

