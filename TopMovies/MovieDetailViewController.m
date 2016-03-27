//
//  MovieDetailViewController.m
//  TopMovies
//
//  Created by Luiz Byrro on 26/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.recipeImageView.image = [UIImage imageNamed:self.recipeImageName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end