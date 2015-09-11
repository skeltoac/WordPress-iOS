import Foundation

class PeopleController: NSObject {
    // Inputs
    let siteID: Int
    let store: PeopleStore

    // Public Properties
    var active = false
    var refreshing = false
    var onlineSignal: RACSignal /* <Bool> */ = RACObserve(AFNetworkReachabilityManager.sharedManager(), "reachable")
    lazy var refreshCommand: RACCommand = {
        let refreshActiveSignal = RACSignal
            .combineLatest([self.onlineSignal, self.activeSignal])
            .and()

        return RACCommand(enabled: refreshActiveSignal, signalBlock: {
            (_) -> RACSignal in
            return self.getUsers()
        })
    }()

    // Outputs
    var viewModelSignal: RACSignal? /* RACBox<Array<PeopleCellViewModel>> */

    // Private properties
    lazy private var activeSignal: RACSignal /* <Bool> */ = RACObserve(self, "active")

    init(siteID: Int, account: WPAccount) {
        self.siteID = siteID
        self.store = PeopleStore(api: account.restApi)

        super.init()

        refreshCommand.executionSignals.flatten()
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
