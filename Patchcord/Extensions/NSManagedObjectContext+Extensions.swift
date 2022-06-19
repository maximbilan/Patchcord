//
//  NSManagedObjectContext+Extensions.swift
//  Patchcord
//
//  Created by Maksym Bilan on 19.06.2022.
//

import CoreData

extension NSManagedObjectContext {

    func perform(async: Bool, _ completion: @escaping () -> Void) {
        guard async else {
            performAndWait(completion)
            return
        }
        perform(completion)
    }

}
