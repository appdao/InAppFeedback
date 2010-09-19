//
//  FeedbackViewController.h
//  InAppFeedbackSample
//
//  Created by appdao on 7/13/10.
//  Copyright 2010 Appdao Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UIWebViewDelegate> {
	UIWebView* _webView;
	
	UIToolbar* _toolbar;
	NSMutableArray* _itemArray;
	
	UIActivityIndicatorView* _aiView;
	UIBarButtonItem* _activityBarButtonItem;
	UIBarButtonItem* _refreshBarButtonItem;
}

@end
