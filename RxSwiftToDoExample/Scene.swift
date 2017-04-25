//
//  Scene.swift
//  RxSwiftToDoExample
//
//  Created by gru on 2017. 4. 25..
//  Copyright © 2017년 com.myungGiSon. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

// 각 화면에 대한 정의
enum Scene
{
    case taskList(TasksVM)
    case editTask(EditTaskVM)
}

// 각 화면에 대한 VC 및 viewModel 설정
extension Scene
{
    func viewController() -> UIViewController
    {
        switch self
        {
        case .taskList(let viewModel):
            var vc = TaskListVC()
            vc.bindViewModel(to: viewModel)
            return vc
            
        case .editTask(let viewModel):
            var vc = EditTaskVC()
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}


// 화면 조절자 타입
// 어떤'장면'을 어떤'전환'으로 전환시킴.
protocol SceneCoordinatorType
{
    init(window: UIWindow)
    func transistion(to scene: Scene, transitionType: SceneTransitionType) -> Observable<Void>
    func pop(animated: Bool) -> Observable<Void>
}

extension SceneCoordinatorType
{
    func pop() -> Observable<Void> { return pop(animated: true) }
}

enum SceneTransitionType
{
    case root
    case push
    case modal
}


class SceneCoordinator: SceneCoordinatorType
{
    fileprivate var window: UIWindow
    fileprivate var currentVC: UIViewController
    
    required init(window: UIWindow)
    {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    func transistion(to scene: Scene, transitionType: SceneTransitionType) -> Observable<Void>
    {
        let subject = PublishSubject<Void>()
        let vc = scene.viewController()
        
        switch transitionType
        {
        case .root:
            window.rootViewController = vc
            subject.onCompleted()
            currentVC = SceneCoordinator.actualVC(for: vc)
            
        case .push:
            guard let navc = currentVC.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            _ = navc.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            
            navc.pushViewController(vc, animated: true)
            currentVC = SceneCoordinator.actualVC(for: vc)
            
            
        case .modal:
            currentVC.present(vc, animated: true) { subject.onCompleted() }
            currentVC = SceneCoordinator.actualVC(for: vc)
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    func pop(animated: Bool) -> Observable<Void>
    {
        let subject = PublishSubject<Void>()
        if let presenter = currentVC.presentingViewController
        {
            // dismiss a modal controlelr
            currentVC.dismiss(animated: animated) { [unowned self] in
                self.currentVC = SceneCoordinator.actualVC(for: presenter)
                subject.onCompleted()
            }
        }
        else if let navc = currentVC.navigationController
        {
            // navigate up the stack
            _ = navc.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            guard navc.popViewController(animated: animated) != nil else { fatalError("can`t navigate back from \(currentVC)") }
            
        }
        else
        {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentVC)")
        }
        
        return subject
            .asObservable()
            .take(1)
            .ignoreElements()
    }
    
    // MARK: - Helper Methods
    static func actualVC(for vc: UIViewController) -> UIViewController
    {
        if let navc = vc as? UINavigationController
        {
            return navc.viewControllers.first!
        }
        else
        {
            return vc
        }
    }
}












