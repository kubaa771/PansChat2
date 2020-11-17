//
//  Loader.swift
//  PansChat2
//
//  Created by Jakub Iwaszek on 18/10/2020.
//

import Foundation
import UIKit

class Loader {
    static var loaderView: UIView?
    
    static func start(view: UIView) {
        loaderView = UIView(frame: UIScreen.main.bounds)
        loaderView!.backgroundColor = UIColor(white:0, alpha: 0.5)
        let activityIndicatior: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatior.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicatior.center = loaderView!.center
        activityIndicatior.hidesWhenStopped = true
        loaderView!.addSubview(activityIndicatior)
        activityIndicatior.startAnimating()
        view.addSubview(loaderView!)
    }
    
    static func stop() {
        loaderView?.removeFromSuperview()
    }
}
