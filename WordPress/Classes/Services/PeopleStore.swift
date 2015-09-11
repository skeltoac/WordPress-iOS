import Foundation

struct PeopleStore {
    let cache: PeopleCache.personCacheType
    let remote: PeopleRemote

    init(api: WordPressComApi, cache: PeopleCache.personCacheType = PeopleCache.sharedPersonCache) {
        self.cache = cache
        self.remote = PeopleRemote(api: api)
    }

    func getTeam(siteID: Int, search: String?) -> RACSignal/*<RACBox<People>>*/ {
        return remote.getTeam(siteID, search: search)
    }
}
