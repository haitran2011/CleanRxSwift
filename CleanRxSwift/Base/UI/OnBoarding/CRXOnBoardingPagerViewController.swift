//
//  CRXOnBoardingPagerViewController.swift
//  CleanRxSwift
//
//  Created by Pedro Brito on 01/07/16.
//  Copyright © 2016 pedroml.brito. All rights reserved.
//

import Foundation
import UIKit


struct CRXPagerConfig {
  let bounces: Bool
  let defaultSlide: Int
  let showDefaultPageIndicator: Bool
  let sendDefaultSlideChange: Bool
  
  init(bounces: Bool, defaultSlide: Int, showDefaultPageIndicator: Bool, sendDefaultSlideChange: Bool = false) {
    self.bounces = bounces
    self.defaultSlide = defaultSlide
    self.showDefaultPageIndicator = showDefaultPageIndicator
    self.sendDefaultSlideChange = sendDefaultSlideChange
  }
}

class CRXPagerViewController: UIPageViewController, UIPageViewControllerDataSource, UIScrollViewDelegate {
  var sliderConfig: CRXPagerConfig? {
    didSet {
      currentSlide = sliderConfig!.defaultSlide
    }
  }
  
  var sliderContent = [CRXOnBoardingPageBaseViewController]()
  
  fileprivate var currentSlide: Int = 0
  
  fileprivate var applyControllerCallback: ((Int) -> UIViewController)?
  fileprivate var didChangedSlideCallback: ((Int) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    (view.subviews.first as? UIScrollView)?.delegate = self
    
    view.backgroundColor = UIColor.clear
    
    // if we need to style the pager indicator, do it below
    let pageControl = UIPageControl.appearance()
    pageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.45)
    pageControl.currentPageIndicatorTintColor = UIColor.black
    //    pageControl.backgroundColor = UIColor.yellowColor();
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setViewControllers([viewControllerAtIndex(contentIndex: currentSlide)], direction: .forward, animated: true, completion: nil)
    
    if sliderConfig?.sendDefaultSlideChange == true {
      didChangedSlideCallback?(currentSlide)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let subViews: NSArray = view.subviews as NSArray
    var scrollView: UIScrollView? = nil
    var pageControl: UIPageControl? = nil
    
    for view in subViews {
      if (view as AnyObject).isKind(of: UIScrollView.self) {
        scrollView = view as? UIScrollView
      }
      else if (view as AnyObject).isKind(of: UIPageControl.self) {
        pageControl = view as? UIPageControl
      }
    }
    
    if scrollView != nil && pageControl != nil {
      scrollView?.frame = view.bounds
      view.bringSubview(toFront: pageControl!)
    }
  }
  
  // *** METHODS
  // * FUNCTIONS
  func applyController(callback: @escaping (Int) -> UIViewController) {
    applyControllerCallback = callback
  }
  
  func didChangedSlide(callback: @escaping (Int) -> Void) {
    didChangedSlideCallback = callback
  }
  
  // PRIVATE
  fileprivate func viewControllerAtIndex(contentIndex: Int?) -> UIViewController! {
    guard let vcIndex = contentIndex else { return nil }
    
    let viewController: UIViewController
    if let callback = applyControllerCallback {
      viewController = callback(vcIndex)
    }
    else {
      viewController = sliderContent[vcIndex]
    }
    
    return viewController
  }
  
  fileprivate func getControllerIndex(vc: UIViewController) -> Int {
    let vcCast = vc as? CRXOnBoardingPageBaseViewController
    
    return vcCast?.pageIndex == nil ? 0 : (vcCast?.pageIndex!)!
  }
  
  // * DELEGATES
  // UIPageViewControllerDataSource
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return sliderConfig?.showDefaultPageIndicator == false ? 1 : sliderContent.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return currentSlide
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let vcCast = viewController as? CRXOnBoardingPageBaseViewController
    var vcIndex = vcCast?.pageIndex == nil ? 0 : (vcCast?.pageIndex!)! as Int
    
    if vcIndex == 0 || vcIndex == NSNotFound {
      return nil
    }
    
    vcIndex -= 1
    return self.viewControllerAtIndex(contentIndex: vcIndex)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let vcCast = viewController as? CRXOnBoardingPageBaseViewController
    var vcIndex = vcCast?.pageIndex == nil ? 0 : (vcCast?.pageIndex!)!
    
    if vcIndex == NSNotFound {
      return nil
    }
    
    vcIndex+=1
    
    if vcIndex == self.sliderContent.count {
      return nil
    }
    
    return self.viewControllerAtIndex(contentIndex: vcIndex)
  }
  
  // UIScrollViewDelegate
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = sliderConfig?.bounces ?? true
    
    guard let vc = viewControllers?[0], case let slide = getControllerIndex(vc: vc), slide != currentSlide else { return }
    
    currentSlide = slide
    didChangedSlideCallback?(currentSlide)
  }
  
}
