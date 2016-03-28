//
//  RetornoTrailer.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Trailer.h"

@interface RetornoTrailer : JSONModel

@property (strong, nonatomic) NSArray <Trailer, Optional>* results;
@property (strong, nonatomic) NSString<Optional> *id;


@end
