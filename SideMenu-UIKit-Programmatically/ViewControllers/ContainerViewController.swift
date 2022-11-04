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
        toggleMenu { [weak self] in
            switch menuItem {
            case .home:
                break
            case .info:
                // Add into child
                guard let vc = self?.infoVC else { return }
                self?.addChild(vc)
                self?.homeVC.view.addSubview(vc.view)
                vc.view.frame = self?.homeVC.view.bounds ?? .zero
                vc.didMove(toParent: self)
            case .appRating:
                break
            case .shareApp:
                break
            case .settings:
                break
            }
        }
    }
}

