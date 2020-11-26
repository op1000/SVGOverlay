//
//  Log.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import Foundation

// swiftlint:disable identifier_name convenience_type

public class Log {
    public enum Level {
        case d // debug
        case i // info
        case e // error
    }
    
    public class func l(
        l level: Log.Level = .d,
        _ any: Any? = nil,
        filename: String = #file,
        funcName: String = #function
    ) {
        #if DEBUG
        let icon = _iconString(level: level)
        if let any = any {
            print("[\(icon)][\(_sourceFileName(filePath: filename))] \(funcName) -> \(any)")
        } else {
            print("[\(icon)][\(_sourceFileName(filePath: filename))] \(funcName)")
        }
        #endif
    }
    
    private class func _iconString(level: Log.Level) -> String {
        var icon = ""
        switch level {
        case .d:
            icon = "🐞"
        case .i:
            icon = "ℹ"
        case .e:
            icon = "⁉️"
        }
        return icon
    }
    
    private class func _sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : (components.last ?? "")
    }
}

// swiftlint:enable identifier_name convenience_type
