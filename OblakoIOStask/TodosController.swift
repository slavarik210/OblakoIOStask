//
//  TodosController.swift
//  OblakoIOStask
//
//  Created by skarus on 26/01/2019.
//  Copyright © 2019 skarus. All rights reserved.
//

import UIKit;

import M13Checkbox;

import Alamofire;

import SwiftyJSON;

class TodosController: CustomTableview, UpdateTodosDelegate {

    @IBOutlet weak var todoTableView: UITableView!
    
    var projects: [Project] = []
    
    @IBOutlet weak var addTodoButton: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(
            UINib(nibName: "CustomCheckboxCell", bundle: nil),
            forCellReuseIdentifier: "customCheckboxCell"
        )
        getTodosData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.projects.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.projects[section].title
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects[section].todos.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCheckboxCell") as! CustomCheckboxCell
        let sectionId = projects[indexPath.section].id
        let todo = self.projects[indexPath.section].todos[indexPath.row]
        let todoText = todo.text
        let todoCompleted = todo.isCompleted
        cell.todoText?.text = todoText
        cell.todoCheckbox.setCheckState(checkBoxStateFromBoolean(state: todoCompleted), animated: false)
        if todoCompleted == true {
            cell.todoText?.attributedText = String.makeSlashText((cell.todoText?.text)!)
        }
        
        return cell
    }
    func checkBoxStateFromBoolean(state: Bool) -> M13Checkbox.CheckState {
        return (state == true) ? .checked : .unchecked
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: CustomCheckboxCell = tableView.cellForRow(at: indexPath) as! CustomCheckboxCell
        let todo = self.projects[indexPath.section].todos[indexPath.row]
        
        cell.todoCheckbox.toggleCheckState()
        slash(cell: cell)
        
        updateTodoState(todoId: todo.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        (nav.topViewController as! AddTodoController).delegate = self
    }

    func slash(cell: CustomCheckboxCell){
        if cell.todoCheckbox.checkState == .checked {
            cell.todoText?.attributedText = String.makeSlashText((cell.todoText?.text)!)
        } else {
            cell.todoText?.attributedText = String.makePlainText((cell.todoText?.attributedText)!)
        }
    }
    
    func getTodosData(){
            Alamofire.request("https://mytaskoblako.herokuapp.com/projects/all.json").responseJSON(completionHandler:{ response in
            switch response.result{
                case .success:
                    self.projects = []
                    let json = JSON(response.result.value!)
                    for (_,project) in json["projects"] {
                        self.projects.append(Project(json: project))
                    }
                    for (_,todo) in json["todos"] {
                        self.projects[todo["projectId"].int! - 1].addTodo(todo: Todo(json: todo))
                    }
                    self.todoTableView.reloadData()
                case .failure:
                    print("Error")
                }
        })
    }
    func updateTodoState(todoId: Int) {
        Alamofire.request("https://mytaskoblako.herokuapp.com/todos/\(todoId)", method: .put)
    }
    
    
    
}
extension String {
    static func makeSlashText(_ text:String) -> NSAttributedString {
        
        let attr: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attr.length))
        
        return attr
        
    }
    static func makePlainText(_ text: NSAttributedString) -> NSAttributedString {
        let attr: NSMutableAttributedString =  NSMutableAttributedString(attributedString: text)
        attr.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attr.length))
        return attr
    }
}
