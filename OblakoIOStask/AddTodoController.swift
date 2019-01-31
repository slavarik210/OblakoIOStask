//
//  AddTodoController.swift
//  OblakoIOStask
//
//  Created by skarus on 26/01/2019.
//  Copyright © 2019 skarus. All rights reserved.
//

import UIKit
import Alamofire;
import SwiftyJSON;

protocol UpdateTodosDelegate {
    func getTodosData()
}

class AddTodoController: CustomTableview {
    
    @IBOutlet var addTodoTableView: UITableView!
    
    var projects: [Project] = []
    
    var selectedRow: Int = 0
    
    var delegate: UpdateTodosDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProjectsData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int
        if section == 0 {
            rows = 1
        } else {
            rows = projects.count
        }
        return rows
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let todoTitleCell = "TodoTitle"
        let todoCategoryCell = "TodoCell"
        
        if indexPath.section == 0 {
            let titleCell = tableView.dequeueReusableCell(withIdentifier: todoTitleCell) as! AddTodoControllerCell
            return titleCell
        } else {
            
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: todoCategoryCell)!
            categoryCell.textLabel?.text = projects[indexPath.row].title
            
            return categoryCell
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = ""
        if section == 0 {
            header = "ЗАДАЧА"
        } else {
            header = "КАТЕГОРИЯ"
        }
        return header
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            selectedRow = indexPath.row
            return indexPath
        } else {
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.delegate?.getTodosData()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addTodoPressed(_ sender: UIBarButtonItem) {
//        print(projects[selectedRow])
//
//        print(UITextField.text)
        let totalSection = addTodoTableView.numberOfSections
        for section in 0..<totalSection
        {
            let totalRows = addTodoTableView.numberOfRows(inSection: section)

            for row in 0..<totalRows
            {
                let cell = addTodoTableView.cellForRow(at: IndexPath(row: row, section: section))
                if let textField = cell?.viewWithTag(101) as? UITextField
                {
                    Alamofire.request(
                        "https://mytaskoblako.herokuapp.com/todos",
                        method: .post,
                        parameters: [
                            "todo": [
                                "project_id": projects[selectedRow].id,
                                "text":textField.text!
                            ]
                        ]
                    ).response{ response in
                        self.delegate?.getTodosData()
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func getProjectsData(){
        Alamofire.request("https://mytaskoblako.herokuapp.com/projects/all.json").responseJSON(completionHandler:{ response in
            switch response.result{
            case .success:
                let json = JSON(response.result.value!)
                for (_,project) in json["projects"] {
                    self.projects.append(Project(json: project))
                }
                self.addTodoTableView.reloadData()
             case .failure:
                print("Error")
            }
        })
        self.tableView.reloadData()
    }
}

//extension UITextField
//{
//    open override func draw(_ rect: CGRect) {
//
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.masksToBounds = true
//    }
//}
class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 10 , left: 10, bottom: 10, right: 10);
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
