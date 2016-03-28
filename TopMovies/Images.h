//
//  Images.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import "JSONModel.h"
#import <JSONModel/JSONModel.h>



@protocol Images
@end

@interface Images : JSONModel


@property (strong, nonatomic) NSString<Optional>* base_url;
@property (strong, nonatomic) NSString<Optional>* secure_base_url;
@property (strong, nonatomic) NSArray<Optional>* backdrop_sizes;
@property (strong, nonatomic) NSArray<Optional>* logo_sizes;
@property (strong, nonatomic) NSArray<Optional>* poster_sizes;
@property (strong, nonatomic) NSArray<Optional>* profile_sizes;
@property (strong, nonatomic) NSArray<Optional>* still_sizes;



@end
