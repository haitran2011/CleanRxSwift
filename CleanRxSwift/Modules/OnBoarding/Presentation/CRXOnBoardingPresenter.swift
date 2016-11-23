//
//  CRXOnBoardingPresenter.swift
//  CleanRxSwift
//
//  Created by Pedro Brito on 01/07/16.
//  Copyright (c) 2016 pedroml.brito. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import RxSwift
import QuickShotUtils;

protocol CRXOnBoardingPresenterProtocol: CRXPresenterProtocol
{
  func userIsDoneWithOnBoarding()
  
  func processOnBoardingPagesContent(_ content: [CRXOnBoardingContent])
}


class CRXOnBoardingPresenter: CRXOnBoardingPresenterProtocol
{
  var view: CRXOnBoardingViewController!
  
  var interactor: CRXOnBoardingInteractor!;
  
  var disposeBag = DisposeBag()
  var contentLoadSubscription: Disposable!
  
  var userIsDoneSubscription: Disposable!
  
  init(interactor: CRXOnBoardingInteractor){
    self.interactor = interactor
    contentLoadSubscription = self.interactor.getSlides().observeOn(MainScheduler.instance).subscribe(onNext: { (slides) in
        self.processOnBoardingPagesContent(slides);
    }, onError: { (error) in
        //TODO: log error
    }, onCompleted: { 
        //finished
    }, onDisposed: { 
        //cleanup
    })
    disposeBag.insert(contentLoadSubscription);
  }
  
  // MARK: Presentation logic
  func bindView(_ view: CRXViewProtocol){
    self.view = view as! CRXOnBoardingViewController;
  }
  
  func userIsDoneWithOnBoarding() {
    userIsDoneSubscription = self.interactor.updateUserIsDone(true).observeOn(MainScheduler.instance).subscribe(onNext: { (success) in
        var onBoardingResultModel = CRXOnBoardingViewModel();
        onBoardingResultModel.destination = CRXOnBoardingDestination.InApp;
        onBoardingResultModel.transitionType = ViewControllerPresentationType.ReplaceAtRoot
        
        self.view.userFinishedOnBoarding(onBoardingResultModel);
    }, onError: { (error) in
        //TODO: log error
    }, onCompleted: { 
        //completed action
    }, onDisposed: { 
        //cleanup
    }) 
    disposeBag.insert(contentLoadSubscription);
  }
  
  func processOnBoardingPagesContent(_ content: [CRXOnBoardingContent]){
    //create page content controllers from content
    var sliderPages = [CRXOnBoardingPageBaseViewController]();
    
    var itemIdx = Int(-1);
    
    for iter in content {
      itemIdx += 1;
      let item = CRXOnBoardingPageBaseViewController();
      item.pageContent = iter;
      item.pageIndex = itemIdx;
      
      sliderPages.append(item);
    }
    
    sliderPages.last!.isFinalStep = true;
    
    var viewModel = CRXOnBoardingViewModel();
    viewModel.sliderItems = sliderPages
    self.view.displayOnboardingPages(viewModel)
  }
}
