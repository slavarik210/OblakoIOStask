//
//  AddTodoControllerCell.swift
//  OblakoIOStask
//
//  Created by skarus on 29/01/2019.
//  Copyright © 2019 skarus. All rights reserved.
//

import UIKit

class AddTodoControllerCell: UITableViewCell {
    
    @IBOutlet weak var todoTitleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension UITextField {
    open override func draw(_ rect: CGRect) {
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
}
