//
//  Result.swift
//  SwiftCharms
//
//  Created by Ruoyu Fu on 15/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//


enum Result<T>{
    case Success(T)
    case Failure(ErrorType)
}

func ==<T:Equatable>(lhs:Result<T>, rhs:Result<T>) -> Bool{
    if case (.Success(let l), .Success(let r)) = (lhs, rhs){
        return l == r
    }
    return false
}

extension Result{

    static func unit(x:T) -> Result<T> {
        return .Success(x)
    }

    func map<U>(f:T throws-> U) -> Result<U> {
        return flatMap{.unit(try f($0))}
    }

    func flatMap<U>(f:T throws-> Result<U>) -> Result<U> {
        switch self{
        case .Success(let value):
            do{
                return try f(value)
            }catch let e{
                return .Failure(e)
            }
        case .Failure(let e):
            return .Failure(e)
        }
    }

    func apply<U>(rf:Result<T throws-> U>) -> Result<U> {
        return rf.flatMap(map)
    }
    
}
