//
//  ProductionCountries.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol ProductionCountries
@end

@interface ProductionCountries : JSONModel
@property (strong, nonatomic) NSString<Optional>* iso_3166_1;
@property (strong, nonatomic) NSString<Optional>* name;
@end
