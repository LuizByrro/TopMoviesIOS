//
//  Genres.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol Genres
@end

@interface Genres : JSONModel
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* name;
@end
