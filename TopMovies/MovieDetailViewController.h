//
//  MovieDetailViewController.h
//  TopMovies
//
//  Created by Luiz Byrro on 29/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmeInfo.h"

@interface MovieDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *MovieName;
@property (weak, nonatomic) IBOutlet UIImageView *MoviePoster;
@property (weak, nonatomic) IBOutlet UILabel *MovieYear;
@property (weak, nonatomic) IBOutlet UILabel *MovieDuration;
@property (weak, nonatomic) IBOutlet UILabel *MovieRate;
@property (weak, nonatomic) IBOutlet UILabel *MovieOverview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overviewLabelViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;


@property (strong, nonatomic)  FilmeInfo *filme;

@end
