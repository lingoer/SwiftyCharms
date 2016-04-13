//
//  XMLParserExamples.swift
//  SwiftyCharms
//
//  Created by Kyle Fang on 2/18/16.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//

import Curry

struct XML {
    enum Content {
        case Text(String)
        case Nodes([XML])
    }
    let name:String
    let attributes:[String:String]
    let childern:Content
}

func join(array:[String]) -> String {
    return array.reduce("", combine: +)
}

func tuple<U, V>(u:U) -> V -> (U, V) {
    return { v in (u, v) }
}

func assemble<T>(keyValuePair:[(String,T)]) -> [String:T] {
    var result:[String:T] = [:]
    keyValuePair.forEach({
        result[$0.0] = $0.1
    })
    return result
}

let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".characters
    .map({one(String($0))})

let keyparser = join <^> many(oneOf(letters))

let attribute = one(" ") *> keyparser <* one("=")
let attributeValue = tuple <^> attribute <*> string
let attributes = assemble <^> many(attributeValue)

let header = one("<") *> keyparser
let attri = attributes <* whitespace <* one(">")
let textContent = XML.Content.Text <^> (join <^> many(not(one("<"))))
let nodeContent = XML.Content.Nodes <^> some(nodeParser())
let content = nodeContent <|> textContent
let footer = one("</") *> keyparser <* one(">")

let selfClosingFooter = whitespace *> one("/>")

let headerParser = curry(XML.init) <^> header <*> attri <*> content

func checkFooter(xml:XML) -> String throws -> XML {
    return { footer in
        if xml.name != footer {
            throw ParserError.NotMatch
        }
        return xml
    }
}

let standParser = checkFooter <^> headerParser <*> footer

let selfClosingNodeParser = curry(XML.init) <^> header <*> attributes <* selfClosingFooter <*> .unit(XML.Content.Text(""))

func nodeParser() -> Parser<XML> {
    return Parser {
        return try (standParser <|> selfClosingNodeParser).trunk($0)
    }
}

