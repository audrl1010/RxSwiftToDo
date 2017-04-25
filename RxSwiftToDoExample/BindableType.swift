//
//  BindableType.swift
//  RxSwiftToDoExample
//
//  Created by gru on 2017. 4. 25..
//  Copyright © 2017년 com.myungGiSon. All rights reserved.
//

import Foundation
import RxSwift

protocol BindableType
{
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController
{
    mutating func bindViewModel(to model: Self.ViewModelType)
    {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
