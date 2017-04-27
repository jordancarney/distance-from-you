//
//  SearchTextField.swift
//  DynamiCare
//
//  Created by Jordan Carney on 4/26/17.
//  Copyright © 2017 Jordan Carney. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        self.leftViewMode = .always
        self.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("Search for destination", comment: ""),
            attributes: [
                NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.5),
                NSFontAttributeName: StyleManager.bodyFont(ofSize: 16.0),
            ]
        )
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
        
        let searchImageView = UIImageView(image: UIImage(named: "search"))
        searchImageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        leftView.addSubview(searchImageView)
        
        self.leftView = leftView
    }
}
