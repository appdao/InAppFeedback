    //
//  RootViewController.m
//  InAppFeedbackSample
//
//  Created by appdao on 7/13/10.
//  Copyright 2010 Appdao Inc. All rights reserved.
//

#import "RootViewController.h"
#import "FeedbackViewController.h"

BOOL IsDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES; 
	}
#endif
	return NO;
}

@implementation RootViewController

@synthesize feedbackWebViewController;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*
- (void)loadView {

}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.view.frame = [[UIScreen mainScreen] bounds];
	
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	
	[self.navigationController setNavigationBarHidden:NO];
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	
	UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*320/width, 0, width*0.8, height*0.8)];
	textLabel.text = @"Your great app here. \n \n Tap the button below or top-left to try in-app-feedback.";
	UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
	textLabel.textColor = color;
	CGFloat titleLabelFontSize = (IsDeviceIPad() ? 72 : 32);
	textLabel.font = [UIFont boldSystemFontOfSize:titleLabelFontSize];
	textLabel.numberOfLines = 10;
	[self.view addSubview:textLabel];
	
	UIButton* presentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[presentButton setTitle:@"feedback" forState:UIControlStateNormal];
	presentButton.titleLabel.font = [UIFont systemFontOfSize: titleLabelFontSize];
	[presentButton addTarget:self action:@selector(presentFeedback) forControlEvents:UIControlEventTouchUpInside];
	presentButton.frame = CGRectMake(20, height*0.8, width/2, height/10);
	[self.view addSubview:presentButton];
	
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	infoButton.showsTouchWhenHighlighted = YES;
	infoButton.frame = CGRectMake(0, 0, 36, 36);
	[infoButton addTarget:self action:@selector(presentFeedback) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [super viewDidLoad];
}

- (void)presentFeedback{
	if (feedbackWebViewController==nil) {
		self.feedbackWebViewController = [[[FeedbackViewController alloc] init] autorelease];
	}
	
	[self presentModalViewController:feedbackWebViewController animated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[feedbackWebViewController release];
    [super dealloc];
}

@end
