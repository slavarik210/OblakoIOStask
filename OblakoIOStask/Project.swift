//
//  Project.swift
//  OblakoIOStask
//
//  Created by skarus on 27/01/2019.
//  Copyright © 2019 skarus. All rights reserved.
//

import Foundation
import SwiftyJSON

class Project{
    var title:String = "Undefined"
    var todos:[Todo] = []
    var id:Int = 0
    
    init(title: String, todos: [Todo]){
        self.title = title
        self.todos = todos
    }
    init(title:String){
        self.title = title
    }
    
    init(json: JSON){
        self.id = json["id"].int!
        self.title = json["title"].string!
    }
    func addTodo(todo: Todo){
        todos.append(todo)
    }
}
