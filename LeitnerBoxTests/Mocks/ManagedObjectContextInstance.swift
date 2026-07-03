//
//  ManagedObjectContextInstance.swift
//  LeitnerBoxTests
//
//  Created by hamed on 3/3/23.
//

import CoreData
import Foundation
@testable import LeitnerBox

final class ManagedObjectContextInstance {
    static let instance = ManagedObjectContextInstance()
    var leitners: [Leitner] = []
    private let context = PersistenceController.shared.viewContext

    private init() {
        reset()
    }

    func reset() {
        deleteAllEntities()
        leitners = PersistenceController.shared.generateAndFillLeitner()
    }

    @discardableResult
    func prepare() -> ManagedObjectContextInstance {
        reset()
        return self
    }

    private func deleteAllEntities() {
        let entityNames = context.persistentStoreCoordinator?.managedObjectModel.entities.compactMap(\.name) ?? []
        entityNames.forEach { entityName in
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            let objects = (try? context.fetch(request)) ?? []
            objects.forEach(context.delete)
        }
        try? context.save()
        context.reset()
    }
}
