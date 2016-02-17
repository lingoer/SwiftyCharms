//
//  ResultCharms.swift
//  SwiftCharms
//
//  Created by Ruoyu Fu on 15/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//


func unit<T> (x:T) -> Result<T> {
    return .Success(x)
}

func >>- <T, U> (r:Result<T>, f:T throws-> Result<U>) -> Result<U> {
    return r.flatMap(f)
}

func <^> <T, U> (f: T throws-> U, r: Result<T>) -> Result<U> {
    return r.map(f)
}

func <*> <T, U> (rf: Result<T throws-> U>, r:Result<T>) -> Result<U> {
    return r.apply(rf)
}
