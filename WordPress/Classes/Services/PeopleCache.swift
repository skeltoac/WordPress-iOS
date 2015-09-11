
import Foundation

struct PeopleCache {
    typealias personCacheType = ReactiveCache<Int, Person>
    static let sharedPersonCache = personCacheType()
}

class ReactiveCache<K: Hashable,V> {
    private var cache = [K: ReactiveCacheValue<V>]()

    func setValue(value: V, key: K, expires: NSDate?) {
        let cacheValue = ReactiveCacheValue(value: value, expires: expires)
        if cacheValue.expired() {
            return
        }
        storeValue(cacheValue, key: key)
    }

    func getValue(key: K) -> V? {
        let cachedValue = retrieveValue(key)

        // Remove value if expired
        if cachedValue.map({ $0.expired()}) ?? false {
            removeValue(key)
            return nil
        }

        return cachedValue.map { $0.value }
    }

    func removeValue(key: K) {
        storeValue(nil, key: key)
    }

    /// MARK: Private methods
    private func storeValue(value: ReactiveCacheValue<V>?, key: K) {
        // TODO: switch to NSCache once we store models on disk
        self.cache[key] = value
    }

    private func retrieveValue(key: K) -> ReactiveCacheValue<V>? {
        return cache[key]
    }
}

struct ReactiveCacheValue<T> {
    let value: T
    let expires: NSDate?

    func expired() -> Bool {
        return expires.map({ $0.timeIntervalSinceNow < 0 }) ?? false
    }
}