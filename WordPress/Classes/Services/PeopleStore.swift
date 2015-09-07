import Foundation

class PeopleStore {
    let remote: PeopleRemote

    init(api: WordPressComApi) {
        remote = PeopleRemote(api: api)
    }

    func getTeam(siteID: Int, search: String?) -> RACSignal/*<RACBox<People>>*/ {
        return remote.getTeam(siteID, search: search)
    }
}