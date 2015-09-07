// Borrowed from https://github.com/ashfurrow/Swift-RAC-Macros since we can't
// have Swift pods until we drop iOS7

import Foundation

// So I expect the ReactiveCocoa fellows to figure out a replacement API for the RAC macro.
// Currently, I don't see one there, so we'll use this solution until an official one exists.

// Pulled from http://www.scottlogic.com/blog/2014/07/24/mvvm-reactivecocoa-swift.html

public struct RAC  {
    var target: NSObject
    var keyPath: String
    var nilValue: AnyObject?

    public init(_ target: NSObject, _ keyPath: String, nilValue: AnyObject? = nil) {
        self.target = target
        self.keyPath = keyPath
        self.nilValue = nilValue
    }

    func assignSignal(signal : RACSignal) -> RACDisposable {
        return signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
    }
}

infix operator <~ {
associativity right
precedence 93
}

public func <~ (rac: RAC, signal: RACSignal) -> RACDisposable {
    return signal ~> rac
}

public func ~> (signal: RACSignal, rac: RAC) -> RACDisposable {
    return rac.assignSignal(signal)
}

public func RACObserve(target: NSObject!, keyPath: String) -> RACSignal {
    return target.rac_valuesForKeyPath(keyPath, observer: target)
}

extension RACStream {
    func mapBoxed<T,U>(block: (T) -> U) -> Self {
        return map({(value: AnyObject!) in
            if let box = value as? RACBox<T> {
                return RACBox(block(box.unbox()))
            }
            return nil
        })
    }

    func filterBoxed<T>(block: (T) -> Bool) -> Self {
        return filter({(value: AnyObject!) in
            if let box = value as? RACBox<T> {
                return block(box.unbox())
            }
            return false
        })
    }

    func mapAs<T,U: AnyObject>(block: (T) -> U) -> Self {
        return map({(value: AnyObject!) in
            if let casted = value as? T {
                return block(casted)
            }
            return nil
        })
    }

    func filterAs<T>(block: (T) -> Bool) -> Self {
        return filter({(value: AnyObject!) in
            if let casted = value as? T {
                return block(casted)
            }
            return false
        })
    }
}

/** Wrapper class so we can pass non-class values around RACSignals */
class RACBox<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }

    func unbox() -> T {
        return value
    }
}