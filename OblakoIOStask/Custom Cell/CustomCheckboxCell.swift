//
//  CustomCheckboxCell.swift
//  OblakoIOStask
//
//  Created by skarus on 26/01/2019.
//  Copyright © 2019 skarus. All rights reserved.
//
import M13Checkbox
import UIKit

class CustomCheckboxCell: UITableViewCell {
    
    @IBOutlet weak var todoCheckbox: M13Checkbox!
    @IBOutlet weak var todoText: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        todoCheckbox.boxType = .square
        //        todoCheckbox.animationDuration = 0
        todoCheckbox.stateChangeAnimation = .fill
        todoCheckbox.checkmarkLineWidth = 3
        todoCheckbox.cornerRadius = 0
        
        
    }
    
}
