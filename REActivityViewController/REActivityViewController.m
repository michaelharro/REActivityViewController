//
// REActivityViewController.m
// REActivityViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REActivityViewController.h"
#import "REActivityView.h"

@interface REActivityViewController ()

- (CGRect)frameForCurrentOrientation;
- (CGFloat)height;

@end

@implementation REActivityViewController

@synthesize backgroundView			= _backgroundView;
@synthesize activities				= _activities;
@synthesize userInfo				= _userInfo;
@synthesize activityView			= _activityView;
@synthesize presentingController	= _presentingController;

- (id)initWithViewController:(UIViewController *)viewController activities:(NSArray *)activities
{
    self = [super init];
	
    if (self) {
		
        self.presentingController				= viewController;
		//self.view.backgroundColor				= [UIColor whiteColor];
		self.view.frame							= self.frameForCurrentOrientation;
        
		self.backgroundView						= [[UIView alloc] initWithFrame:self.view.bounds];
		self.backgroundView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundView.backgroundColor		= [UIColor blackColor];
		//self.backgroundView.alpha				= 0;
		[self.view addSubview:self.backgroundView];
        
		[self willChangeValueForKey:@"activities"];
        _activities = activities;
		[self didChangeValueForKey:@"activities"];
		
        self.activityView						= [[REActivityView alloc] initWithFrame:self.view.bounds activities:activities];
        self.activityView.autoresizingMask		= UIViewAutoresizingFlexibleWidth;
        self.activityView.activityViewController= self;
        [self.view addSubview:self.activityView];
        
    }
	
    return self;
	
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
	__typeof (&*self) __weak weakSelf = self;
	[UIView animateWithDuration:0.4 animations:^{
		
		CGRect afterFrame				= weakSelf.frameForCurrentOrientation;
		afterFrame.origin.y				= CGRectGetMaxY(self.presentingController.view.frame);
		
		weakSelf.view.frame				= afterFrame;
		weakSelf.backgroundView.alpha	= 0.0;
		
	} completion:^(BOOL finished) {
		
		[weakSelf.view removeFromSuperview];
		[weakSelf removeFromParentViewController];
		
		if (completion) {
			completion();
		}
		
	}];
}

- (void)presentFromRootViewController
{
    
	UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self presentFromViewController:rootViewController];
	
}

- (void)presentFromViewController:(UIViewController *)controller
{
    
	self.presentingController = controller;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
	
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
	
	CGRect beforeFrame			= self.frameForCurrentOrientation;
	beforeFrame.origin.y		= CGRectGetMaxY(self.presentingController.view.frame);
	
	self.view.frame				= beforeFrame;
	self.backgroundView.alpha	= 0.0;
    
    __typeof (&*self) __weak weakSelf = self;
	[UIView animateWithDuration:0.4 animations:^{
		
		weakSelf.backgroundView.alpha	= 0.4;
		weakSelf.view.frame		= weakSelf.frameForCurrentOrientation;
		
	}];
}

- (CGRect)frameForCurrentOrientation {
	
	return CGRectMake(
					  0,
					  CGRectGetHeight(self.presentingController.view.frame) - self.height,
					  CGRectGetWidth(self.view.frame),
					  self.height);
	
}

- (CGFloat)height
{
    
	CGFloat numberOfActivities			= ( self.activities ? self.activities.count : 0 );
	CGFloat maxNumberOfColumnsPerPage	= floor( ( CGRectGetWidth(self.presentingController.view.frame) - REActivityViewHorizontalMargin ) / ( REActivityWidth + REActivityViewHorizontalMargin ) );
	CGFloat numberOfRowsOnCurrentPage	= ceil(numberOfActivities / maxNumberOfColumnsPerPage);
	
	return REActivityViewVerticalMargin + ( (REActivityViewVerticalMargin + REActivityHeight) * numberOfRowsOnCurrentPage );
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - 
#pragma mark Helpers

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(runBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)runBlockAfterDelay:(void (^)(void))block
{
	if (block != nil)
		block();
}

#pragma mark -
#pragma mark Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
	__typeof (&*self) __weak weakSelf = self;
	CGRect frame = weakSelf.view.frame;

	if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
		frame.origin.y		= CGRectGetHeight(weakSelf.presentingController.view.frame) - self.height;
		frame.size.width	= CGRectGetWidth(weakSelf.presentingController.view.frame);
	} else {
		frame.origin.y		= CGRectGetWidth(weakSelf.presentingController.view.frame) - self.height;
		frame.size.width	= CGRectGetHeight(weakSelf.presentingController.view.frame);
	}

	frame.size.height		= self.height;
	weakSelf.view.frame		= frame;
	
}

@end
