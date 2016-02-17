//
//  Parser.swift
//  SwiftCharms
//
//  Created by Ruoyu Fu on 15/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//

struct Parser<T> {

    let trunk: String throws-> (T, String)

    init(trunk: String throws-> (T, String)){
        self.trunk = trunk
    }

    func parse(input:String) -> Result<T> {
        do{
            return try .Success(trunk(input).0)
        }catch let e{
            return .Failure(e)
        }
    }
}

extension Parser {

    static func unit(x:T) -> Parser<T> {
        return Parser{(x,$0)}
    }

    func map<U>(f:T throws-> U) -> Parser<U> {
        return flatMap{.unit(try f($0))}
    }

    func flatMap<U>(f:T throws-> Parser<U>) -> Parser<U> {
        return Parser<U>{
            let result = try self.trunk($0)
            return try f(result.0).trunk(result.1)
        }
    }

    func apply<U>(rf:Parser<T throws-> U>) -> Parser<U> {
        return rf.flatMap(map)
    }
}