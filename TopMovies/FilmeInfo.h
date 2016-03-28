//
//  FilmeInfo.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol FilmeInfo
@end

@interface FilmeInfo : JSONModel


@property (strong, nonatomic) NSString<Optional>* poster_path;
@property (assign, nonatomic) bool adult;
@property (strong, nonatomic) NSString<Optional>* overview;
@property (strong, nonatomic) NSString<Optional>* release_date;
@property (strong, nonatomic) NSArray<Optional>* genre_ids;
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* original_title;
@property (strong, nonatomic) NSString<Optional>* original_language;
@property (strong, nonatomic) NSString<Optional>* title;
@property (strong, nonatomic) NSString<Optional>* backdrop_path;
@property (assign, nonatomic) double popularity;
@property (assign, nonatomic) double vote_count;
@property (assign, nonatomic) bool video;
@property (assign, nonatomic) double vote_average;


@end
