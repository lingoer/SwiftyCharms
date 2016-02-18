//
//  CustomMatchers.swift
//  SwiftyCharms
//
//  Created by Ruoyu Fu on 17/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//

import Nimble
@testable import SwiftyCharms

extension JSON{
    
    func toNSObject()->NSObject{
        switch self{
        case .JNull:
            return NSNull()
        case .JBool(let b):
            return b
        case .JNumber(let n):
            return n
        case .JString(let s):
            return s
        case .JArray(let jsonArray):
            return jsonArray.map{$0.toNSObject()}
        case .JObject(let jsonObject):
            return NSDictionary(objects: jsonObject.map{$0.1.toNSObject()}, forKeys: jsonObject.map{$0.0})
        }
    }

}

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

func parse<T>(result:(T, String), from:String, matcher:(T,T)->Bool)->MatcherFunc<Parser<T>>{
    return MatcherFunc{ expression, failureMessage in
        let parser = try expression.evaluate()
        do{
            let actualResult = try parser?.trunk(from)
            failureMessage.stringValue = "expected \(result.0) , \(result.1) got \(actualResult?.0), \(actualResult?.1)"
            return actualResult.map{ matcher($0.0,result.0) && $0.1 == result.1 } == true
        }catch{
            return false
        }
    }
}


func failOn<T>(on:String)->MatcherFunc<Parser<T>>{
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

func == (lhs:(String, JSON), rhs:(String, JSON)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

func == (lhs: JSON, rhs: JSON) -> Bool {
    switch (lhs, rhs) {
    case (.JString(let left), .JString(let right)):
        return left == right
    case (.JNumber(let left), .JNumber(let right)):
        return left == right
    case (.JBool(let left), .JBool(let right)):
        return left == right
    case (.JArray(let left), .JArray(let right)):
        return left == right
    case (.JObject(let left), .JObject(let right)):
        return left.map{$0.0} == right.map{$0.0} && left.map{$0.1} == right.map{$0.1}
    case (.JNull,.JNull):
        return true
    default:
        return false
    }
}