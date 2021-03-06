//
//  RootViewController.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 7/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <objc/runtime.h>

#import "UITextViewLinkOptionsAppDelegate.h"
#import "RootViewController.h"
#import "WebViewController.h"

@implementation RootViewController

@synthesize textView;

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

  textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 300, 150)];

  textView.text = @"Check out my GitHub page http://github.com/marksands or instead, go to the site of the guy that added a switch and plugged his website http://michaelchinen.com.";
  textView.font = [UIFont systemFontOfSize:16.0];

  // this will autodetect urls and allow the user to respond
  textView.dataDetectorTypes = UIDataDetectorTypeLink;
  textView.editable = NO;

  [self.view addSubview:textView];

  // swap implementation, we want to go to our custom WebViewController from this view
  UITextViewLinkOptionsAppDelegate *MyWatcher = [[UIApplication sharedApplication] delegate];
  MyWatcher.currentViewController = self;
}

// called by our customOpenURL method
- (void)handleURL:(NSURL*)url
{
  WebViewController *controller = [[[WebViewController alloc] initWithURL:url] autorelease];
  [controller setHidesBottomBarWhenPushed:YES];
  [self.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc {
  [textView release];
  [super dealloc];
}

- (IBAction)onSwitch:(id)sender
{
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch* theSwitch;
        theSwitch = sender;
        Method customOpenUrl = class_getInstanceMethod([UIApplication class], @selector(customOpenURL:));
        Method openUrl = class_getInstanceMethod([UIApplication class], @selector(openURL:));
        if (theSwitch.isOn) {
            method_exchangeImplementations(openUrl, customOpenUrl);
        } else {
            method_exchangeImplementations(customOpenUrl, openUrl);
        }
    }
}

- (IBAction)onURLButtton:(id)sender
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://michaelchinen.com"]];
}


@end

