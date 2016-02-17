//
//  Async.swift
//  SwiftCharms
//
//  Created by Ruoyu Fu on 15/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//


struct Async<T> {

    let trunk:(Result<T>->Void)->Void

    init(function:(Result<T>->Void)->Void) {
        trunk = function
    }

    func execute(callBack:Result<T>->Void) {
        trunk(callBack)
    }

}

extension Async{

    static func unit(x:T) -> Async<T> {
        return Async{ $0(.Success(x)) }
    }

    func map<U>(f: T throws-> U) -> Async<U> {
        return flatMap{ .unit(try f($0)) }
    }

    func flatMap<U>(f:T throws-> Async<U>) -> Async<U> {
        return Async<U>{ cont in
            self.execute{
                switch $0.map(f){
                case .Success(let async):
                    async.execute(cont)
                case .Failure(let error):
                    cont(.Failure(error))
                }
            }
        }
    }

    func apply<U>(af:Async<T throws-> U>) -> Async<U> {
        return af.flatMap(map)
    }
}
