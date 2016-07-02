//
//  CRXOnBoardingConfigurator.swift
//  CleanRxSwift
//
//  Created by Pedro Brito on 01/07/16.
//  Copyright (c) 2016 pedroml.brito. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

extension CRXOnBoardingViewController: CRXOnBoardingPresenterOutput
{
}

extension CRXOnBoardingInteractor: CRXOnBoardingViewControllerOutput
{
}

extension CRXOnBoardingPresenter: CRXOnBoardingInteractorOutput
{
}

class CRXOnBoardingConfigurator
{
  // MARK: Object lifecycle
  
  class var sharedInstance: CRXOnBoardingConfigurator
  {
    struct Static {
      static var instance: CRXOnBoardingConfigurator?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = CRXOnBoardingConfigurator()
    }
    
    return Static.instance!
  }
  
  // MARK: Configuration
  
  func configure(viewController: CRXOnBoardingViewController)
  {
    let router = CRXOnBoardingRouter()
    router.viewController = viewController
    
    let presenter = CRXOnBoardingPresenter()
    presenter.output = viewController
    
    let interactor = CRXOnBoardingInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}