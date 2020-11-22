//
//  GenericNavigationController.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import UIKit

class MasterNavigationController: UINavigationController {
    
    private weak var loadingLayer: LoadingLayer?
    
    public var isLoadingInterfaceRunning: Bool = false {
        didSet {
            if isLoadingInterfaceRunning {
                startLoadingInterface()
            } else {
                stopLoadingInterface()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        navigationBar.prefersLargeTitles = true
        applyDesign()
    }
    
    private func startLoadingInterface() {
        let loadingLayer = LoadingLayer()
        view.addSubview(loadingLayer)
        loadingLayer.start()
        self.loadingLayer = loadingLayer
    }
    
    private func stopLoadingInterface() {
        loadingLayer?.stop()
    }
}

extension MasterNavigationController {
    func applyDesign() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .systemBlue
        UINavigationBarAppearance().shadowImage = nil
        UINavigationBarAppearance().shadowColor = nil
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = navBarAppearance
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = .white
    }
}

fileprivate final class LoadingLayer: UIView {
    
    private var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
        addSubview(indicator)
        indicator.center = center
    }
    
    public func start() {
        self.indicator.startAnimating()
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        }
    }
    
    public func stop() {
        indicator.stopAnimating()
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    deinit {
        if Environment.isDebug {
            print("Loading layer is done out here.")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Stop right there, criminal!")
    }
    
}
