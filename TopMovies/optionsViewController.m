//
//  optionsViewController.m
//  TopMovies
//
//  Created by Luiz Byrro on 30/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import "optionsViewController.h"

@interface optionsViewController ()

@end

@implementation optionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.optionNames = [NSMutableArray array];
        
        [self.optionNames addObject:@"Sort By Popularity"];
        [self.optionNames addObject:@"Sort By Rating"];
        
        self.clearsSelectionOnViewWillAppear = NO;
        
        //Calculate how tall the view should be by multiplying
        //the individual row height by the total number of rows.
        NSInteger rowsCount = [self.optionNames count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        //Calculate how wide the view should be by finding how
        //wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        for (NSString *optionName in self.optionNames) {
            //Checks size of text using the default font for UITableViewCell's textLabel.
            CGSize labelSize = [optionName sizeWithFont:[UIFont systemFontOfSize:18.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        //Add a little padding to the width
        CGFloat popoverWidth = largestLabelWidth+10;
        
        self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.optionNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

   // cell.textLabel.text = [self.optionNames objectAtIndex:indexPath.row];
    

    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(2, 8, 200, 24)];
    [textView setText: [self.optionNames objectAtIndex:indexPath.row]];
    
    // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    [cell.contentView addSubview:textView];
    
    // Configure the cell...
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *option = [[NSString alloc] init];
    
    
    option = [self.optionNames objectAtIndex:indexPath.row];
    
    
    
    //Notify the delegate if it exists.
    if (self.delegate != nil) {
        [self.delegate selectedOption:option];
    }
    
    
}

@end
