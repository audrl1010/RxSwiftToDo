//
//  TasksVM.swift
//  RxSwiftToDoExample
//
//  Created by gru on 2017. 4. 25..
//  Copyright © 2017년 com.myungGiSon. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources


typealias TaskSection = AnimatableSectionModel<String, Task>

struct TasksVM
{
    let sceneCoordinator: SceneCoordinatorType
    let taskService: TaskServiceType
}
