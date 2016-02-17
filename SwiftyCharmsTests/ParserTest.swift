//
//  ParserTest.swift
//  SwiftyCharms
//
//  Created by Ruoyu Fu on 16/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//
import XCTest
import Quick
import Nimble
@testable import SwiftyCharms


class JSONParserSpecs:QuickSpec {


    override func spec() {

        describe("number"){

            it("should parse float value from string") {
                expect(number).to(parse((123.01,"abc"), from: "123.01abc"))
            }

            it("should fail on none float expression") {
                expect(number).to(failOn("a123"))
            }

            it("should fail on empty input") {
                expect(number).to(failOn(""))
            }
        }

        describe("string") {

            it("should parse quoted string from raw input") {
                expect(string).to(parse(("abc","asdf"), from: "\"abc\"asdf"))
            }

            it("should parse escaped quote too") {
                expect(string).to(parse(("a\"abc","asdf"), from: "\"a\\\"abc\"asdf"))
            }

            it("should fail on none quoted characters") {
                expect(string).to(failOn("asdf"))
            }

            it("should fail on empty input") {
                expect(string).to(failOn(""))
            }
            
            it("should fail on missing closing quote") {
                expect(string).to(failOn("\"abc"))
            }
        }

        describe("array") {

            it("should parse array with one element"){
                expect(array).to(parse(([.JNumber(0)],"123"), from:"[0]123", matcher:==))
            }

            it("should parse array with many elements"){
                expect(array).to(parse(([.JNumber(0),.JNumber(1)],"123"), from:"[0,1]123", matcher:==))
            }

            it("should parse array with no element"){
                expect(array).to(parse(([],"123"), from:"[]123", matcher:==))
            }

            it("should fail on none '[' quoted characters") {
                expect(array).to(failOn("asdf"))
            }

            it("should fail on empty input") {
                expect(array).to(failOn(""))
            }
        }

        describe("objects") {
            
            func matcher(lhs:[(String, JSON)], rhs:[(String, JSON)])->Bool{
                return lhs.map{$0.0} == rhs.map{$0.0} && lhs.map{$0.1} == rhs.map{$0.1}
            }

            it("should parse object with one element"){
                expect(objects).to(parse(([("key",.JNumber(0))], "123"), from:"{\"key\":0}123", matcher:matcher))
            }

            it("should parse object with many elements"){
                expect(objects).to(parse(([("key0",.JNumber(0)),("key1",.JNumber(1))], "123"), from:"{\"key0\":0,\"key1\":1}123", matcher:matcher))
            }

            it("should parse object with no element"){
                expect(objects).to(parse(([], "123"), from:"{}123", matcher:matcher))
            }

            it("should parse fail with none '{' quoted characters"){
                expect(objects).to(failOn("asdf"))
            }

            it("should fail on empty input") {
                expect(array).to(failOn(""))
            }
        }

        describe("bool") {

            it("should parse true value from string") {
                expect(bool).to(parse((true,"abc"), from: "trueabc"))
            }

            it("should parse false value from string") {
                expect(bool).to(parse((false,"abc"), from: "falseabc"))
            }

            it("should fail on none bool expression") {
                expect(bool).to(failOn("a123"))
            }

            it("should fail on empty input") {
                expect(bool).to(failOn(""))
            }

        }

        describe("JSON parser") {

            let jsonParser = makeJSON()
            let bundle = NSBundle(forClass: self.dynamicType)
            let path = bundle.pathForResource("example", ofType: "json")!
            let jsonData = NSData(contentsOfFile: path)!
            let jsonObject = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! NSDictionary
            let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding)!
            let jsonTest = try! jsonParser.trunk(jsonString).0.toNSObject() as! NSDictionary
            
            it("should parse json value from string") {
                expect(jsonTest).to(equal(jsonObject))
            }
        }
    }
}
