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

@interface PosterViewController : UICollectionViewController

-(IBAction)LoadMovies;
- (IBAction)SortByRating;
- (IBAction)SortByPopularity;
- (IBAction)optionsButtonPressed;

@end
