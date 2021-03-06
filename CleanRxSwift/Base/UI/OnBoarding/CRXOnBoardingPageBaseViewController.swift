//
//  CRXOnBoardingPageBaseViewController.swift
//  CleanRxSwift
//
//  Created by Pedro Brito on 01/07/16.
//  Copyright © 2016 pedroml.brito. All rights reserved.
//

import UIKit
import SwiftEventBus

public enum CRXOnboardingEvents: String {
  case FINISH = "finish_button_click"
}

struct CRXOnBoardingContent
{
  var titleText : String!
  var descriptionText : String!
  var imageName : String!
  var bgColor: UIColor?
}

class CRXOnBoardingPageBaseViewController: CRXBaseViewController {
  
  lazy var headingContainer = UIView();
  lazy var headingLabel =  CRXViewFactory.boldLabelWithTextAndSize("", textColor: UIColor(hexString:"#000000FF")!, fontSize: CGFloat(24));
  lazy var descriptionContainer = UIView();
  lazy var descriptionLabel = CRXViewFactory.textLabelWithTextAndSize("", textColor: UIColor(hexString:"#000000FF")!, fontSize: CGFloat(16));
  lazy var imageContainer = UIView();
  lazy var contentImageView = UIImageView();
  lazy var stepFinishButton = UIButton();

  
  var pageIndex: Int?
  var isFinalStep: Bool!
  
  var pageContent: CRXOnBoardingContent!;
  
  
  // MARK: Object lifecycle
  override init() {
    super.init();
    self.isFinalStep = false;
  }
  
  required convenience init(coder: NSCoder) {
    self.init(coder: coder);
  }
  
  // MARK: ViewController lifecycle events
  override func viewDidLoad() {
    super.viewDidLoad();
    displayPageContent();
  }
  
  
  //build page content layout
  func displayPageContent(){
    self.view.backgroundColor = self.pageContent.bgColor != nil ? self.pageContent.bgColor! : UIColor.whiteColor();
    
    self.view.addSubview(self.headingContainer);
    
    self.headingContainer.snp_makeConstraints { make in
      make.width.equalTo(self.view.snp_width).inset(25);
      make.height.equalTo(40)
      make.top.equalTo(self.view).offset(30)
      make.centerX.equalTo(self.view);
    }
    
    self.headingContainer.addSubview(self.headingLabel)
    self.headingLabel.text = pageContent.titleText;
    self.headingLabel.sizeToFit();
    self.headingLabel.snp_makeConstraints { make in
      make.width.equalTo(self.headingContainer.snp_width).inset(20)
      make.center.equalTo(self.headingContainer)
    }
    
    self.view.addSubview(self.imageContainer);
    self.imageContainer.snp_makeConstraints { make in
      make.width.equalTo(self.view.snp_width).inset(25)
      make.height.equalTo(self.view.snp_height).multipliedBy(0.45)
      make.top.equalTo(self.headingContainer.snp_bottom).offset(20)
      make.centerX.equalTo(self.view);
    }
    
    
    self.view.addSubview(self.descriptionContainer);
    self.descriptionContainer.snp_makeConstraints { make in
      make.width.equalTo(self.view.snp_width).inset(25)
      make.top.equalTo(self.imageContainer.snp_bottom).offset(10)
      make.bottom.equalTo(self.view.snp_bottom).inset(40)
      make.centerX.equalTo(self.view);
    }
    
    self.descriptionLabel.text = self.pageContent.descriptionText;
    self.descriptionLabel.sizeToFit();
    self.descriptionContainer.addSubview(self.descriptionLabel)
    self.descriptionLabel.snp_makeConstraints { make in
      make.width.equalTo(self.descriptionContainer.snp_width)
      make.height.equalTo(self.descriptionContainer.snp_height)
      make.edges.equalTo(self.descriptionContainer)
    }
    
    
    self.contentImageView.image = UIImage(named: self.pageContent.imageName);
    self.imageContainer.addSubview(self.contentImageView);
    self.contentImageView.snp_makeConstraints { make in
      make.width.equalTo(self.imageContainer.snp_width)
      make.height.equalTo(self.imageContainer.snp_height)
      make.center.equalTo(self.imageContainer);
    }
    
    self.headingContainer.alpha = 0.1;
    self.descriptionContainer.alpha = 0.1;
    self.imageContainer.alpha = 0.1;
    UIView.animateWithDuration(1.0, animations: { () -> Void in
      self.headingContainer.alpha = 1.0;
      self.descriptionContainer.alpha = 1.0;
      self.imageContainer.alpha = 1.0;
    });
    
    
    if(self.isFinalStep != nil && self.isFinalStep == true){
      stepFinishButton = CRXViewFactory.circularButtonImage(UIImage(named:"ic_check_white")!, highlightedButtonImage: UIImage(named:"ic_check_primary")!, buttonColor: UIColor.randomColor(), highlightedButtonColor: UIColor.randomColor());
      stepFinishButton.center.x = self.view.frame.width - 60.0;
      stepFinishButton.center.y = self.view.frame.height - 60.0;
      stepFinishButton.addTarget(self, action: #selector(CRXOnBoardingPageBaseViewController.doOnboardingFinishEventNotification(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      self.view.addSubview(stepFinishButton);
    }
  }
  
  
  // MARK: Event handling
  func doOnboardingFinishEventNotification(sender:UIButton!) {
    //notify anyone interested
    SwiftEventBus.post(CRXOnboardingEvents.FINISH.rawValue);
  }
}
