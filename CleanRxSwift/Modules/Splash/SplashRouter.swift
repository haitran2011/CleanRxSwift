//
//  SplashRouter.swift
//  CleanRxSwift
//
//  Created by Pedro Brito on 22/06/16.
//  Copyright (c) 2016 pedroml.brito. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import QuickShotUtils

enum SplashDestination: String {
  case OnBoarding, Login, SignIn, InApp
}

protocol SplashRouterInput
{
  func navigateToNextScreen(destination: SplashDestination?, transitionType: ViewControllerPresentationType?)
}

class SplashRouter: SplashRouterInput
{
  weak var viewController: SplashViewController!
  
  // MARK: Navigation
  
  func navigateToNextScreen(destination: SplashDestination?, transitionType: ViewControllerPresentationType?)
  {
    viewController.hideProgressIndicator();
    
    var destinationViewController: UIViewController? = nil
    
    if let dest = destination {
      switch(dest){
      case .OnBoarding:
        //destinationViewController = OnBoardingViewController();
        break;
      case .Login:
//        destinationViewController = RFLoginViewController()
        break;
      case .SignIn:
//        destinationViewController = RFSignInChooserViewController();
        break;
      case .InApp:
//        destinationViewController = RFRootViewController()
        break;
      }
    }
    
    viewController.transtitionToNextViewController(viewController, destinationViewController: destinationViewController, transitionType: transitionType);
  }
}
