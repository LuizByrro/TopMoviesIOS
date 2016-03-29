//
//  MovieDetailViewController.m
//  TopMovies
//
//  Created by Luiz Byrro on 29/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController
NSArray *tableData;

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
    
    
    [self.MovieName setText: self.filme.original_title];
    [self.MovieYear setText: self.filme.release_date];
    [self.MovieRate setText: [NSString stringWithFormat:@"%f",self.filme.vote_average]];
    
    
    
    [self.MovieOverview setText: self.filme.overview];
    self.MovieOverview.numberOfLines=0;
    float width = 296;
    CGSize maximumLabelSize = CGSizeMake(width, 9999);
    CGSize expectedLabelSize = [self.filme.overview sizeWithFont:self.MovieOverview.font constrainedToSize:maximumLabelSize lineBreakMode:self.MovieOverview.lineBreakMode];
    //set height of yourLabel to what we calculated
    CGRect frame = self.MovieOverview .frame;
    frame.size.height = expectedLabelSize.height;
    
    
    self.overviewLabelViewHeightConstraint.constant = expectedLabelSize.height+2;
    
    NSLog(@"%f", expectedLabelSize.height);
    [self.MovieOverview setText: self.filme.overview];
    
    tableData = [NSArray arrayWithObjects:@"Trailer1",@"Trailer2",@"Trailer3",@"Trailer4",@"Trailer5",@"Trailer6",nil];

    CGFloat height = self.tableView.rowHeight;
    height *= tableData.count;
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = height;

    NSLog(@"%f", self.tableView.rowHeight);
    
    self.tableViewHeightConstraint.constant = height;
    [self.view setNeedsUpdateConstraints];
    
    self.tableView.frame = tableFrame;

    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];

    
    return cell;

}


- (CGFloat)getLabelsize:(UILabel *)label
{
    CGSize maxSize = CGSizeMake(label.frame.size.width, 9999);
    CGSize requiredSize = [label sizeThatFits:maxSize];
    
    return requiredSize.height;
}



@end
