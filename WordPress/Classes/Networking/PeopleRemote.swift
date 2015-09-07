import Foundation

struct PeopleRemote {
    let api: WordPressComApi

    /**
    Gets people from the site's team

    :param: siteID the ID of the site.
    :param: search an optional search string.
    :returns: A RACSignal that emits one People object and then completes
    */
    func getTeam(siteID: Int, search: String?) -> RACSignal/*<RACBox<People>>*/ {
        let signal = RACSignal.createSignal {
            subscriber in

            let path = "v1.1/sites/\(siteID)/users"
            let parameters = search.map { ["search": $0] }

            let operation = self.api.GET(path, parameters: parameters, success: {
                _, users in
                let mappedUsers = self.myCrappyUsersMapperThatShallBeReplaced(users, siteID)
                subscriber.sendNext(RACBox(mappedUsers))
                subscriber.sendCompleted()
            }, failure: {
                _, error in
                subscriber.sendError(error)
            })

            return RACDisposable {
                operation.cancel()
            }
        }

        return signal.map {
            users in
            return users
        }
    }

    private func myCrappyUsersMapperThatShallBeReplaced(json: AnyObject, _ siteID: Int) -> People {
        let users = json as! Array<Dictionary<String, AnyObject>>
        let people = users.map {
            user -> Person in

            let id = user["ID"] as! Int
            let login = user["login"] as! String
            let name = user["name"] as! String
            let firstName = user["first_name"] as! String
            let lastName = user["last_name"] as! String
            let roles = user["roles"] as! [String]
            let avatarUrl = user["avatar_URL"] as! String

            let avatarURL: NSURL = NSURL(string: avatarUrl)!

            return Person(
                ID: id,
                username: login,
                firstName: firstName,
                lastName: lastName,
                displayName: name,
                role: .Author,
                pending: false,
                siteID: siteID,
                avatarURL:avatarURL
            )
        }

        return people
    }

    enum PeopleResult {
        case Result(People)
        case Error(NSError)
    }
}