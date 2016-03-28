//
//  Collection.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//
#import "JSONModel.h"
#import <JSONModel/JSONModel.h>

@protocol Collection
@end

@interface Collection : JSONModel

@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* name;
@property (strong, nonatomic) NSString<Optional>* poster_path;
@property (strong, nonatomic) NSString<Optional>* backdrop_path;


@end
