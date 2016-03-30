//
//  NSObject+UIPopover_Iphone.m
//  TopMovies
//
//  Created by Luiz Byrro on 30/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import "NSObject+UIPopover_Iphone.h"

@implementation UIPopoverController (overrides)

+(BOOL)_popoversDisabled
{
    return NO;
}

@end