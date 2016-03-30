//
//  optionsViewController.h
//  TopMovies
//
//  Created by Luiz Byrro on 30/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol OptionPickerDelegate <NSObject>
@required
-(void)selectedOption:(NSString *)option;
@end

@interface optionsViewController : UITableViewController


@property (nonatomic, strong) NSMutableArray *optionNames;
@property (nonatomic, weak) id<OptionPickerDelegate> delegate;

@end
