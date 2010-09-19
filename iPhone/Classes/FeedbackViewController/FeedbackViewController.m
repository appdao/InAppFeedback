//
//  FeedbackViewController.m
//  InAppFeedbackSample
//
//  Created by appdao on 7/13/10.
//  Copyright 2010 Appdao Inc. All rights reserved.
//

#import "FeedbackViewController.h"

#import <sys/utsname.h>

#define NEWWIN_SCHEME		@"safari" // open url in safari if url match this schema

//Developer key, please register a developer account from http://www.appdao.com
#define kDeveloperKey		@"kz2qhaksjy96w6x9anabcm7ue709cvz3"

#define kFeedbackURL		@"http://appdao.com/?r=feedback/home" //Feedback url prefix

#define kScreenBounds		[[UIScreen mainScreen] bounds]
#define kScreenWidth		kScreenBounds.size.width
#define kScreenHeight		kScreenBounds.size.height


@interface FeedbackViewController (Private)
- (void)loadFeedback;
@end


@implementation FeedbackViewController

//*******************************************************************************************************************
#pragma mark -
#pragma mark ViewController Methods

- (NSMutableArray*)createBarButtonItems {
	NSMutableArray* itemArray = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
	
	UIBarButtonItem* refreshBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)] autorelease];
	
	UIBarButtonItem* flexibleBarButtonItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	UILabel* titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 44)] autorelease];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.text = @"Feedback";
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.font = [UIFont boldSystemFontOfSize:20];
	titleLabel.textColor = [UIColor whiteColor];
	UIBarButtonItem* titleBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:titleLabel] autorelease];
	
	UIBarButtonItem* flexibleBarButtonItem2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	UIBarButtonItem* closeBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close.png"] style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
	
	[itemArray addObject:refreshBarButtonItem];
	[itemArray addObject:flexibleBarButtonItem1];
	[itemArray addObject:titleBarButtonItem];
	[itemArray addObject:flexibleBarButtonItem2];
	[itemArray addObject:closeBarButtonItem];
	
	return itemArray;
}

- (void)viewDidLoad {
	//Create a UIWebView to show the feedback web page
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44)];
	_webView.delegate = self;
	
	_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
	_toolbar.barStyle = UIBarStyleBlackTranslucent;
	_toolbar.tintColor = [UIColor blackColor];
	_itemArray = [[self createBarButtonItems] retain];
	_toolbar.items = _itemArray;
	
	[self.view addSubview:_webView];
	[self.view addSubview:_toolbar];
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//load the feedback web page in the UIWebView
	[self loadFeedback];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	//Stop loading the page
	[_webView stopLoading];
	
	//Show an empty page
	[_webView loadHTMLString:@"" baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	//Stop loading the page
	[_webView stopLoading];
	
	//Show an empty page
	[_webView loadHTMLString:@"" baseURL:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[_webView release];
	[_toolbar release];
	
	[_aiView release];
	[_activityBarButtonItem release];
	[_refreshBarButtonItem release];
	
	[_itemArray release];
	
    [super dealloc];
}

//*******************************************************************************************************************
#pragma mark -
#pragma mark Parameter Methods

- (NSLocale*)getCurrentLocale {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
	if (languages.count > 0) {
		NSString *currentLanguage = [languages objectAtIndex:0];
		return [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] autorelease];
	} else {
		return [NSLocale currentLocale];
	}	
}

- (NSString*)specificMachineModel {
    struct utsname systemInfo;
    uname(&systemInfo);
	
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

static NSString* UserAgent = nil;

- (NSString*)userAgent {
	if (UserAgent==nil) {
		UIDevice *device = [UIDevice currentDevice];
		NSBundle *bundle = [NSBundle mainBundle];
		NSLocale *locale = [self getCurrentLocale];
		
		UserAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@ %@; %@; %@)",
					 [bundle objectForInfoDictionaryKey:@"CFBundleName"], //App name
					 [bundle objectForInfoDictionaryKey:@"CFBundleVersion"], //App version
					 [device model], //Device model
					 [device systemName], //OS name
					 [device systemVersion], //OS version
					 [locale localeIdentifier], //OS language
					 [self specificMachineModel] //Specific machine model, more info: http://stackoverflow.com/questions/1108859/detect-the-specific-iphone-ipod-touch-model
					 ];
		[UserAgent retain];
		
		//NSLog(@"user agent:%@", UserAgent);
	}
	return UserAgent;
}

- (NSString*)urlEncode:(NSString*)param {
	//convert the param into a legal URL string
	return [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

static NSString* HTTPGetParams = nil;

- (NSString*)httpGetParams {
	if (HTTPGetParams==nil) {
		UIDevice *device = [UIDevice currentDevice];
		NSBundle *bundle = [NSBundle mainBundle];
		NSLocale *locale = [self getCurrentLocale];
		NSString *userAgent = [self userAgent];
		
		HTTPGetParams = [NSString stringWithFormat:@"app=%@&appid=%@&v=%@&lang=%@&deviceid=%@&key=%@&agent=%@&os=%@", 
						 [self urlEncode:[bundle objectForInfoDictionaryKey:@"CFBundleName"]], //App name
						 [self urlEncode:[bundle objectForInfoDictionaryKey:@"CFBundleIdentifier"]], //App unique indentifier
						 [self urlEncode:[bundle objectForInfoDictionaryKey:@"CFBundleVersion"]], //App version
						 [self urlEncode:[locale localeIdentifier]], //OS language
						 [self urlEncode:[device uniqueIdentifier]], //Unique device id
						 [self urlEncode:kDeveloperKey], //Developer key, please register a developer account from http://www.appdao.com
						 [self urlEncode:userAgent], //User Agent
						 [self urlEncode:[device systemVersion]] //OS version
						 ]; 
		[HTTPGetParams retain];
		
		NSLog(@"HTTPGetParams:%@", HTTPGetParams);
	}
	
	return HTTPGetParams;
}

//*******************************************************************************************************************
#pragma mark -
#pragma mark loading animation methods

- (void)startLoadAnimating {
	if (_aiView==nil) {
		_aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		_aiView.hidesWhenStopped = YES;
		_aiView.frame = CGRectMake(0, 0, 18, 18);
	}
	if (_activityBarButtonItem==nil) {
		_activityBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_aiView];
	}
	
	[_itemArray replaceObjectAtIndex:0 withObject:_activityBarButtonItem];
	_toolbar.items = _itemArray;
	[_aiView startAnimating];
}

- (void)stopLoadAnimating {
	if (_refreshBarButtonItem==nil) {
		_refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
	}
	
	[_itemArray replaceObjectAtIndex:0 withObject:_refreshBarButtonItem];
	_toolbar.items = _itemArray;
	[_aiView stopAnimating];
}

//*******************************************************************************************************************
#pragma mark -
#pragma mark WebView Delegate

- (BOOL)webView:(UIWebView *)thewebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL* url = [request URL];
	
	NSString* scheme = [url scheme];
	NSString* host = [url host];
	//NSLog(@"scheme:%@, host:%@", scheme, host);
	
	if([scheme isEqualToString:NEWWIN_SCHEME] //For custom scheme
	   || [host isEqualToString:@"itunes.apple.com"] || [host isEqualToString:@"phobos.apple.com"] //For App Store url
	   ){
		
		NSString *str_url = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		str_url = [str_url stringByReplacingOccurrencesOfString:@"itunes.apple.com/" withString:@"phobos.apple.com/"]; //For App Store url
		
		url = [NSURL URLWithString:str_url];
		BOOL result = [[UIApplication sharedApplication] openURL:url];
		if (result) {
			return NO;
		}
	}
	
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)thewebView {
	[self startLoadAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)thewebView {
	[self stopLoadAnimating];
}

- (void)webView:(UIWebView *)thewebView didFailLoadWithError:(NSError *)error {
	[self stopLoadAnimating];
}

//*******************************************************************************************************************
#pragma mark -
#pragma mark WebView Methods

- (void)loadFeedback {
	NSLog(@"load Feedback web page");
	NSString *feedbackurl = [NSString stringWithFormat:@"%@&%@", kFeedbackURL, [self httpGetParams]];
	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:feedbackurl]]];
}

- (void)reload {
	[_webView reload];
}

- (void)close {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
