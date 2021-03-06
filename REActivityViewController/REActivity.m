//
// REActivity.m
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

#import "REActivity.h"

NSString * const REActivityTypeDefault	= @"com.missionhub.reactivity.type.default";

@interface REActivity ()

@end

@implementation REActivity

@synthesize activityItems = _activityItems;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(REActivityActionBlock)actionBlock
{
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _actionBlock = [actionBlock copy];
    }
    return self;
}
- (NSString *)activityType {
	
	return REActivityTypeDefault;
	
}

- (NSString *)activityTitle {
	
	return self.title;
	
}

- (UIImage *)activityImage {
	
	return self.image;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	return NO;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	self.activityItems	= ( activityItems ? activityItems : @[] );
	
}

- (void)performActivity {
	
	if (self.actionBlock) {
		
		self.actionBlock(self, self.activityViewController);
		
	}
	
}

- (void)activityDidFinish:(BOOL)completed {
	
	
	
}

@end
