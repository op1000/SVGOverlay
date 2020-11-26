//
//  Binder.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import Foundation

public final class Binder<T> {
    public typealias Listener = (T) -> Void
    public var listener: Listener?
    public var value: T {
        didSet {
            listener?(value)
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
    public func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
