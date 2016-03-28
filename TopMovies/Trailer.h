//
//  Trailer.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Trailer



@end

@interface Trailer : JSONModel


@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* iso_639_1;
@property (strong, nonatomic) NSString<Optional>* key;
@property (strong, nonatomic) NSString<Optional>* name;
@property (strong, nonatomic) NSString<Optional>* site;
@property (strong, nonatomic) NSString<Optional>* size;
@property (strong, nonatomic) NSString<Optional>* type;





@end
