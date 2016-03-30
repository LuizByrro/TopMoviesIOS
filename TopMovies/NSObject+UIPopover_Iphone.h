//
//  NSObject+UIPopover_Iphone.h
//  TopMovies
//
//  Created by Luiz Byrro on 30/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPopoverController (overrides)
+(BOOL)_popoversDisabled;
@end
