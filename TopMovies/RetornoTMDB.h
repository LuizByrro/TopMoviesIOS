//
//  RetornoTMDB.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FilmeInfo.h"

@protocol RetornoTMDB
@end

@interface RetornoTMDB : JSONModel

@property (strong, nonatomic) NSArray <FilmeInfo, Optional>* results;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) int total_results;
@property (assign, nonatomic) int total_pages;


@end
