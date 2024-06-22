//
//  File.swift
//  
//
//  Created by Daniel Ishida on 21/06/24.
//

import Foundation
import Fluent

final class Book : Model{
    static let schema = "books"
    
    @ID(key: .id)
    var id : UUID?
    
    @Field(key: "BOOK_NAME")
    var name: String
    
    @Field(key: "BOOK_AUTHOR")
    var author : String
    

    init(){}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
}
