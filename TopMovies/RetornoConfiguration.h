//
//  RetornoConfiguration.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//


#import <JSONModel/JSONModel.h>
#import "Images.h"


@protocol RetornoConfiguration
@end

@interface RetornoConfiguration : JSONModel


@property (strong, nonatomic) Images<Optional>* images;
@property (strong, nonatomic) NSArray<Optional>* change_keys;

@end
