//
//  MenuView.h
//  TVemulator
//
//  Created by Sema Belokovsky on 26.09.12.
//  Copyright (c) 2012 Sema Belokovsky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define MBRIGHTNESS @"Brightness"
#define MCONTRAST @"Contrast"

typedef enum {
	kMenuBrightness = 0,
	kMenuContrast
} MenuKey;

@interface MenuView : NSView {
	
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *value;

@end
