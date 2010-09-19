//
//  RootViewController.h
//  InAppFeedbackSample
//
//  Created by appdap on 7/13/10.
//  Copyright 2010 Appdao Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedbackViewController;


@interface RootViewController : UIViewController {
	FeedbackViewController *feedbackWebViewController;
}
@property(nonatomic, retain) FeedbackViewController *feedbackWebViewController;
@end
