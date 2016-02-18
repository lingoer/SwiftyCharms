//
//  XMLParserExamples.swift
//  SwiftyCharms
//
//  Created by Kyle Fang on 2/18/16.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//

//Example
let input = "<hello name=\"SwiftyCharms\">world</hello>"

//Seems like there are memory issue at the moment
let input2 = "<hello name=\"SwiftyCharms\"><time name=\"SwiftyCharms\">hello</time></hello>"

struct XML {
    enum Content {
        case Text(String)
        case Nodes([XML])
    }
    let name:String
    let attributes:[String:String]
    let childern:Content
}

extension XML {
    static func from(head:String)(_ attributes:[String:String])(_ childern:Content)(foot:String) throws -> XML {
        guard head == foot else {
            throw ParserError.NotMatch
        }
        return XML(name: head, attributes: attributes, childern: childern)
    }
}

func join(array:[String]) -> String {
    return array.reduce("", combine: +)
}

func tuple<U, V>(x:U)(_ y:V) -> (U, V) {
    return (x, y)
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

let keyparser = join <^> some(oneOf(letters))

let attribute = one(" ") *> keyparser <* one("=")
let attributeValue = tuple <^> attribute <*> string
let attributes = assemble <^> many(attributeValue)

let header =  one("<") *> keyparser
let attri = attributes <* one(">")
let textContent = XML.Content.Text <^> (join <^> many(not(one("<"))))
let nodeContent = XML.Content.Nodes <^> some(nodeParser())
let content = nodeContent <|> textContent
let footer = one("</") *> keyparser <* one(">")

func nodeParser() -> Parser<XML> {
    return {XML.from <^> header <*> attri <*> content <*> footer}()
}

