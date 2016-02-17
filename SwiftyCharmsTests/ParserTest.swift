//
//  ParserTest.swift
//  SwiftyCharms
//
//  Created by Ruoyu Fu on 16/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftyCharms


class JSONParserSpecs:QuickSpec {
    override func spec() {
        
        describe("digit") {

            it("should parse sigle digit characters") {
                expect(digit).to(parse(("1","234"), from: "1234"))
            }

            it("should fail on none digit characters") {
                expect(digit).to(failOn("a123"))
            }
        }

        describe("number"){

            it("should parse float value from string") {
                expect(number).to(parse((123.01,"abc"), from: "123.01abc"))
            }

            it("should fail on none float expression") {
                expect(number).to(failOn("a123"))
            }
        }

        describe("string") {

            it("should parse quoted string from raw input") {
                expect(string).to(parse(("abc","asdf"), from: "\"abc\"asdf"))
            }

            it("should parse escaped quote too") {
                expect(string).to(parse(("a\"abc","asdf"), from: "\"a\\\"abc\"asdf"))
            }
        }
    }
}
