//
//  SplashInteractor.swift
//  CleanRxSwift
//
//  Created by Pedro Brito on 22/06/16.
//  Copyright (c) 2016 pedroml.brito. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import RxSwift

protocol SplashInteractorInput
{
  func checkUserOnBoardingState(request: SplashRequest)
}

protocol SplashInteractorOutput
{
  func presentSomething(response: SplashResponse)
}

class SplashInteractor: SplashInteractorInput
{
  var output: SplashInteractorOutput!
  var worker: SplashWorker!
  
  var process: SplashProcess!;
  
  // MARK: Business logic
  
  func checkUserOnBoardingState(request: SplashRequest){
    self.lazyInitializeBIProcess();
    // NOTE: Create some Worker to do the work
    worker = SplashWorker()
    worker.doSomeWork()
    
    // NOTE: Pass the result to the Presenter
    
    let response = SplashResponse()
    output.presentSomething(response)
  }
  
  
  func updateUserIsDone() -> Observable<Bool>
  {
    self.lazyInitializeBIProcess();
    
    return process.checkIfOnboardingIsDone().observeOn(MainScheduler.instance).doOnError { error in
      print("ERROR: \(error)");
    };
  }
  
  func lazyInitializeBIProcess(){
    if(self.process == nil){
      self.process = SplashProcess();
    }
  }
}
