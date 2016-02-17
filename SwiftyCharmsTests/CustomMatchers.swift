//
//  CustomMatchers.swift
//  SwiftyCharms
//
//  Created by Ruoyu Fu on 17/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//

import Nimble
@testable import SwiftyCharms

func parse<T:Equatable>(result:(T, String), from:String)->MatcherFunc<Parser<T>>{
    return MatcherFunc{ expression, failureMessage in
        let parser = try expression.evaluate()
        do{
            let actualResult = try parser?.trunk(from)
            failureMessage.stringValue = "expected \(result.0) , \(result.1) got \(actualResult?.0), \(actualResult?.1)"
            return actualResult?.0 == result.0 && actualResult?.1 == result.1
        }catch{
            return false
        }
    }
}

func failOn<T:Equatable>(on:String)->MatcherFunc<Parser<T>>{
    return MatcherFunc{ expression, failureMessage in
        let parser = try expression.evaluate()
        do{
            let _ = try parser?.trunk(on)
            return false
        }catch{
            return true
        }
    }
}

extension JSON: Equatable {

}

func == (lhs: JSON, rhs: JSON) -> Bool {
    return true
}