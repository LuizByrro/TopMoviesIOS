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
- (void)SortByRating;
- (void)SortByPopularity;
- (IBAction)Clear;

@property (nonatomic, strong) optionsViewController *optionPicker;
@property (nonatomic, strong) UIPopoverController *optionPickerPopover;

@property (nonatomic, strong) UIAlertView *alertViewConfiguring;
@property (nonatomic, strong) UIAlertView *alertViewLoadingMovies;

-(IBAction)chooseOptionButtonTapped:(id)sender;


@end
