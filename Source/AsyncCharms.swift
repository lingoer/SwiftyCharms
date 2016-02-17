//
//  AsyncCharms.swift
//  SwiftCharms
//
//  Created by Ruoyu Fu on 28/1/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//


func unit<T> (x:T) -> Async<T> {
    return Async{$0(.Success(x))}
}

func >>- <T, U> (async:Async<T>, f:T throws-> Async<U>) -> Async<U> {
    return async.flatMap(f)
}

func <^> <T, U> (f: T throws-> U, async: Async<T>) -> Async<U> {
    return async.map(f)
}

func <*> <T, U> (af: Async<T throws-> U>, async:Async<T>) -> Async<U> {
    return async.apply(af)
}
