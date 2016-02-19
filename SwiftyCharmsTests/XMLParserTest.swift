//
//  XMLParserTest.swift
//  SwiftyCharms
//
//  Created by Kyle Fang on 2/18/16.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftyCharms

class XMLParserTest: QuickSpec {
    override func spec() {
        describe("Simple Node") {
            it("Should be able to parse simple node") {
                let test = "<hello attr=\"SwiftyCharms\">world</hello>"
                guard let result = nodeParser().parse(test).value else {
                    return fail("Cannot parse simple node")
                }
                expect(result.name).to(equal("hello"))
                expect(result.attributes["attr"]).to(equal("SwiftyCharms"))
                if case .Text(let t) = result.childern {
                    expect(t).to(equal("world"))
                } else {
                    fail("Cannot parse content text")
                }
            }
        }
        describe("Nested Node") {
            it("Should be able to parse nested nodes") {
                let test = "<hello attr=\"SwiftyCharms\"><time name=\"SwiftyCharms\">hello</time></hello>"
                guard let result = nodeParser().parse(test).value else {
                    return fail()
                }
                expect(result.name).to(equal("hello"))
                expect(result.attributes["attr"]).to(equal("SwiftyCharms"))
                if case .Nodes(let nodes) = result.childern, let node = nodes.first {
                    expect(node.name).to(equal("time"))
                } else {
                    fail("Cannot parse content text")
                }
            }
        }
        describe("Self closing Node") {
            it("Should be able to parse self closing tag") {
                let test = "<hello attr=\"SwiftyCharms\" />"
                guard let result = nodeParser().parse(test).value else {
                    return fail()
                }
                expect(result.name).to(equal("hello"))
                expect(result.attributes["attr"]).to(equal("SwiftyCharms"))
                if case .Text(let text) = result.childern {
                    expect(text).to(equal(""))
                } else {
                    fail("Cannot parse content text")
                }
            }
        }
    }
}