//
//  PosterViewController.h
//  TopMovies
//
//  Created by Luiz Byrro on 25/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmeInfo.h"
#import "AFImageRequestOperation.h"
#import "optionsViewController.h"
#import "NSObject+UIPopover_Iphone.h"


@interface PosterViewController : UICollectionViewController <OptionPickerDelegate>

-(IBAction)LoadMovies;
- (IBAction)SortByRating;
- (IBAction)SortByPopularity;
- (IBAction)optionsButtonPressed;

@property (nonatomic, strong) optionsViewController *optionPicker;
@property (nonatomic, strong) UIPopoverController *optionPickerPopover;

-(IBAction)chooseOptionButtonTapped:(id)sender;


@end
