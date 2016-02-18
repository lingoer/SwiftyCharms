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
                let test = "<hello name=\"SwiftyCharms\">world</hello>"
                guard let result = nodeParser().parse(test).value else {
                    return fail()
                }
                expect(result.name).to(equal("hello"))
            }
        }
    }
}