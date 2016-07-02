//
//  CRXOnBoardingViewController.swift
//  CleanRxSwift
//
//  Created by Pedro Brito on 01/07/16.
//  Copyright (c) 2016 pedroml.brito. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol CRXOnBoardingViewControllerInput
{
  func displaySomething(viewModel: CRXOnBoardingViewModel)
}

protocol CRXOnBoardingViewControllerOutput
{
  func doSomething(request: CRXOnBoardingRequest)
}

class CRXOnBoardingViewController: UIViewController, CRXOnBoardingViewControllerInput
{
  var output: CRXOnBoardingViewControllerOutput!
  var router: CRXOnBoardingRouter!
  
  // MARK: Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    CRXOnBoardingConfigurator.sharedInstance.configure(self)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomethingOnLoad()
  }
  
  // MARK: Event handling
  
  func doSomethingOnLoad()
  {
    // NOTE: Ask the Interactor to do some work
    
    let request = CRXOnBoardingRequest()
    output.doSomething(request)
  }
  
  // MARK: Display logic
  
  func displaySomething(viewModel: CRXOnBoardingViewModel)
  {
    // NOTE: Display the result from the Presenter
    
    // nameTextField.text = viewModel.name
  }
}