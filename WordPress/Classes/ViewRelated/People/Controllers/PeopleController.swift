import Foundation

class PeopleController {
    let siteID: Int
    let store: PeopleStore

    init(siteID: Int, account: WPAccount) {
        self.siteID = siteID
        self.store = PeopleStore(api: account.restApi)
    }

    func getUsers() -> RACSignal/*RACBox<Array<PeopleCellViewModel>>*/ {
        return store.getTeam(siteID, search: nil).mapBoxed {
            (people: People) -> [PeopleCellViewModel] in
            return people.map {
                person in
                return PeopleCellViewModel(person: person)
            }
        }
    }
}
