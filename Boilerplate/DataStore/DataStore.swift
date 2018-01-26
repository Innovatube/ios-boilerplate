//
//  DataStore.swift
//  RealmTableView
//
//  Created by Tran Anh on 1/23/18.
//  Copyright © 2018 anh. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm
//import RxOptional

class DataStore {
    static var realm: Realm = {
        do {
            print(Realm.Configuration.defaultConfiguration)
            Realm.Configuration.defaultConfiguration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { _, _ in
            })
            let realm = try Realm()
            return realm
        } catch let error {
            fatalError(String(describing: error))
        }
    }()
    class func objects<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    class func first<T: Object>(type: T.Type, filter predicate: NSPredicate) -> T? {
        return objects(type: type, filter: predicate).first
    }
    class func objects<T: Object>(type: T.Type, filter predicate: NSPredicate) -> Results<T> {
        return realm.objects(T.self).filter(predicate)
    }
    class func observableObjects<T: Object>(type: T.Type) -> Observable<Results<T>> {
        return Observable.collection(from: realm.objects(T.self)).asObservable()
    }
    class func observableObjects<T: Object>(type: T.Type, filter predicate: NSPredicate) -> Observable<Results<T>> {
        return Observable.collection(from: realm.objects(T.self).filter(predicate)).asObservable()
    }
    class func write(object: Object, update: Bool = false) throws {
        try realm.safeWrite {
            realm.add(object, update: update)
        }
    }
    class func write(objects: [Object], update: Bool = false) throws {
        try realm.safeWrite {
            objects.forEach { realm.add($0, update: update) }
        }
    }
    class func delete<T: RealmSwift.Object>(object: T) throws {
        realm.delete(object)
    }
    class func delete<T: RealmSwift.Object>(objects: RealmSwift.Results<T>) throws {
        realm.delete(objects)
    }
    class func delete<T: RealmSwift.Object>(objects: RealmSwift.List<T>) throws {
        realm.delete(objects)
    }
    class func update( block: () throws -> Void) throws {
        try realm.write(block)
    }
}

extension Github {
    static func observableGithubWithId(id: String) -> Observable<Github?> {
        return DataStore
            .observableObjects(type: Github.self, filter: NSPredicate(format: "id == %@", id))
            .map { $0.first }
//            .filterNil()
    }
    static func observableGithub() -> Observable<[Github]> {
        return DataStore
            .observableObjects(type: Github.self)
            .map { (git) -> [Github] in return git.map { $0 } }
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
