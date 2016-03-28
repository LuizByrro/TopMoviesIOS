//
//  RetornoMovieInfo.h
//  TopMovies
//
//  Created by Luiz Byrro on 27/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Collection.h"
#import "Genres.h"
#import "ProductionCompanies.h"
#import "ProductionCountries.h"
#import "SpokenLanguages.h"


@protocol RetornoMovieInfo
@end

@interface RetornoMovieInfo : JSONModel



@property (assign, nonatomic) bool adult;
@property (strong, nonatomic) NSString<Optional>* backdrop_path;
@property (strong, nonatomic) Collection<Optional>* belongs_to_collection;
@property (strong, nonatomic) NSString<Optional>* budget;
@property (strong, nonatomic) NSArray <Genres, Optional>* genres;
@property (strong, nonatomic) NSString<Optional>* homepage;
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* imdb_id;
@property (strong, nonatomic) NSString<Optional>* original_language;
@property (strong, nonatomic) NSString<Optional>* original_title;
@property (strong, nonatomic) NSString<Optional>* overview;
@property (assign, nonatomic) double popularity;
@property (strong, nonatomic) NSString<Optional>* poster_path;
@property (strong, nonatomic) NSArray <ProductionCompanies, Optional>* production_companies;
@property (strong, nonatomic) NSArray <ProductionCountries, Optional>* production_countries;
@property (strong, nonatomic) NSString<Optional>* release_date;
@property (strong, nonatomic) NSString<Optional>* revenue;
@property (assign, nonatomic) double runtime;
@property (strong, nonatomic) NSArray <SpokenLanguages, Optional>* spoken_languages;
@property (strong, nonatomic) NSString<Optional>* status;
@property (strong, nonatomic) NSString<Optional>* tagline;
@property (strong, nonatomic) NSString<Optional>* title;
@property (assign, nonatomic) bool video;
@property (strong, nonatomic) NSString<Optional>* vote_count;
@property (assign, nonatomic) double vote_average;


@end
