//
//  UIUtilities.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit

class UIUtilities: NSObject {

    static func createLoadingIndicator() -> UIAlertController {
        let alert = createAlert(title: nil, message: "Por favor, aguarde...")

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        return alert
    }
    
    static func createDefaultAlert(title: String?,
                            message: String) -> UIAlertController {
        let alert = createAlert(title: title, message: message)
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: "Ação padrão"),
            style: .default, handler: nil))
        return alert
    }
    
    static func createAlert(title: String?,
                            message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message,
                                 preferredStyle: .alert)
    }
    
    static func showAlert(controller: UIViewController,
                          alert: UIAlertController) -> Void {
        let controller = controller.navigationController != nil ?
            controller.navigationController! : controller
        controller.present(alert, animated: true, completion: nil)
    }
}
