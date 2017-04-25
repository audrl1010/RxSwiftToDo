//
//  TaskService.swift
//  RxSwiftToDoExample
//
//  Created by gru on 2017. 4. 25..
//  Copyright © 2017년 com.myungGiSon. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Realm

// TaskService가 해야할 일을 정의
protocol TaskServiceType
{
    func createTask(title: String) -> Observable<Task>
    
    func delete(task: Task) -> Observable<Void>
    
    func update(task: Task, title: String) -> Observable<Task>
    
    func toggle(task: Task) -> Observable<Task>
    
    func tasks() -> Observable<Results<Task>>
}

enum TaskServiceError: Error
{
    case creationFailed
    case updateFailed(Task)
    case deletionFailed(Task)
    case toggleFailed(Task)
}

struct TaskService: TaskServiceType
{
    init()
    {
        do
        {
            let realm = try Realm()
            if realm.objects(Task.self).count == 0
            {
                [
                 "Chapter 5: Filtering operators",
                 "Chapter 4: Observables and Subjects in practice",
                 "Chapter 3: Subjects",
                 "Chapter 2: Observables",
                 "Chapter 1: Hello, RxSwift"
                ]
                .forEach { _ = self.createTask(title: $0) }
            }
        }
        catch _ { }
    }
    
    func createTask(title: String) -> Observable<Task>
    {
        let result = withRealm("creating") { (realm) -> Observable<Task> in
            let task = Task()
            task.title = title
            try realm.write {
                task.uid = (realm.objects(Task.self).max(ofProperty: "uid") ?? 0) + 1
                realm.add(task)
            }
            return Observable.just(task)
        }
        return result ?? Observable.error(TaskServiceError.creationFailed)
    }
    
    func delete(task: Task) -> Observable<Void>
    {
        
    }
    
    func update(task: Task, title: String) -> Observable<Task>
    {
        
    }
    
    func toggle(task: Task) -> Observable<Task>
    {
        
    }
    
    func tasks() -> Observable<Results<Task>>
    {
        
    }
    
    // MARK: - Helper Methods
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T?
    {
        do
        {
            let realm = try Realm()
            return try action(realm)
        }
        catch let error
        {
            print("Failed \(operation) realm with error: \(error)")
            return nil
        }
    }
}













