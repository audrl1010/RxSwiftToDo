//
//  UINavigationController+Rx.swift
//  RxSwiftToDoExample
//
//  Created by gru on 2017. 4. 25..
//  Copyright © 2017년 com.myungGiSon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class RxNavigationControllerDelegateProxy: DelegateProxy
    , DelegateProxyType
    , UINavigationControllerDelegate
{
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject?
    {
        guard let navc = object as? UINavigationController else { fatalError() }
        return navc.delegate
    }
    
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject)
    {
        guard let navc = object as? UINavigationController else { fatalError() }
        
        if delegate == nil
        {
            navc.delegate = nil
        }
        else
        {
            guard let delegate = delegate as? UINavigationControllerDelegate else { fatalError() }
            navc.delegate = delegate
        }
    }
}

extension Reactive where Base: UINavigationController
{
    public var delegate: DelegateProxy
    {
        return RxNavigationControllerDelegateProxy.proxyForObject(base)
    }
}


