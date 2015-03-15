//
//  RLMFetchedResultsController.swift
//  HyperRecipes
//
//  Copyright (c) 2015 Hyper AS. All rights reserved.
//

import UIKit
import Realm

class RLMFetchedResultsController: NSObject {

    private(set) var realm: RLMRealm!
    private(set) var notificationToken: RLMNotificationToken?
    private var fetchedResults: RLMResults?
    weak var delegate: AnyObject?


    init(closure: () -> (RLMResults?)) {
        self.fetchedResults = closure()
        self.realm = self.fetchedResults?.realm

        super.init()

        self.notificationToken = self.realm.addNotificationBlock { (String) -> Void in
            self.notifyContentChanged()
        }
    }

    deinit {
        self.delegate = nil
        self.realm.removeNotification(self.notificationToken)
    }

    func notifyContentChanged() {
        if self.delegate != nil &&
            self.delegate!.respondsToSelector("controllerDidChangeContent") {
                let timer = NSTimer(
                    timeInterval: 0,
                    target: self.delegate!,
                    selector: "controllerDidChangeContent",
                    userInfo: nil,
                    repeats: false)
        }
    }

    func objectAtIndex(indexPath: NSIndexPath) -> AnyObject {
        let row = UInt(indexPath.row)

        return self.fetchedResults!.objectAtIndex(row)
    }

    func fetchedObjects() -> Array<AnyObject> {
        var fetchedObjects: Array<AnyObject> = []

        for i in 0..<self.fetchedResults!.count {
            fetchedObjects.append(self.fetchedResults!.objectAtIndex(i))
        }

        return fetchedObjects
    }

    func count() -> Int {
        return Int(self.fetchedResults!.count)
    }

}
