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
    var todosarr: [Todo] = []
    
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
        let projectTitle = projects[section].title
        return projectTitle
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionId = projects[section].id
        var sectionRows: Int = 0
        todosarr.forEach { (todo) in
            if todo.projectId == sectionId {
                sectionRows += 1
            }
        }
        return sectionRows
//        return self.projects[section].todos.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCheckboxCell") as! CustomCheckboxCell
        let sectionId = projects[indexPath.section].id
        let todo = todoForIndexInSection(index: indexPath.row, section: sectionId)
        let todoText = todo.text
        cell.todoText?.text = todoText
        updateCheckbox(cell: cell, todo: todo)
        
        return cell
    }
    
    func checkBoxStateFromBoolean(state: Bool) -> M13Checkbox.CheckState {
        return (state == true) ? .checked : .unchecked
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: CustomCheckboxCell = tableView.cellForRow(at: indexPath) as! CustomCheckboxCell
        let sectionId = projects[indexPath.section].id
        let todo = todoForIndexInSection(index: indexPath.row, section: sectionId)
        
        todo.isCompleted = !todo.isCompleted
        updateCheckbox(cell: cell, todo: todo)
        updateTodoState(todoId: todo.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        (nav.topViewController as! AddTodoController).delegate = self
    }

    func updateCheckbox(cell: CustomCheckboxCell, todo: Todo){
        cell.todoCheckbox.setCheckState(checkBoxStateFromBoolean(state: todo.isCompleted), animated: false)
        if cell.todoCheckbox.checkState == .checked {
            cell.todoText?.attributedText = String.makeSlashText((cell.todoText?.text)!)
        } else {
            cell.todoText?.attributedText = String.makePlainText((cell.todoText?.attributedText)!)
        }
    }
    
    func todoForIndexInSection (index: Int, section: Int) -> Todo{
        var todoForSection: [Todo] = []
        todosarr.forEach { (todo) in
            if todo.projectId == section {
                todoForSection.append(todo)
            }
        }
        return todoForSection[index]
    }
    
    func getTodosData(){
            Alamofire.request("https://mytaskoblako.herokuapp.com/projects/all.json").responseJSON(completionHandler:{ response in
            switch response.result{
                case .success:
                    self.projects = []
                    self.todosarr = []
                    let json = JSON(response.result.value!)
                    for (_,project) in json["projects"] {
                        self.projects.append(Project(json: project))
                    }
                    for (_,todo) in json["todos"] {
                        self.projects[todo["projectId"].int! - 1].addTodo(todo: Todo(json: todo))
                        self.todosarr.append(Todo(json: todo))
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
