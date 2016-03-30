//
//  PosterViewController.m
//  TopMovies
//
//  Created by Luiz Byrro on 25/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import "PosterViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "RetornoConfiguration.h"
#import "RetornoTMDB.h"
#import "FilmeInfo.h"
#import "AFImageRequestOperation.h"
#import "MovieDetailViewController.h"

@interface PosterViewController (){
    RetornoConfiguration* retornoConfiguration;
    int total_pages;
    int actual_page;
    int itens_perPage;
    NSMutableArray<FilmeInfo, Optional> *filmes;
    bool sortByRating;
    bool configured;
}
@end

@implementation PosterViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad

{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    total_pages=50;
    actual_page=1;
    sortByRating=false;
    configured=false;
    
    itens_perPage=20;
    filmes = [(NSMutableArray<FilmeInfo,Optional>*) [NSMutableArray alloc] init];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.themoviedb.org/3"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://api.themoviedb.org/3/configuration?api_key=c4cd8d181d2a547a8b7ec7cdb9df1f9b"
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSString* retorno = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        retornoConfiguration = [[RetornoConfiguration alloc] initWithString:retorno error:nil];
        configured=true;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return filmes.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PosterCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    //recipeImageView.image = [UIImage imageNamed:@"superman.jpg"];
    
    
    FilmeInfo *film= [[FilmeInfo alloc] init];
    film = filmes[indexPath.row];
    
    // set default user image while image is being downloaded
    //recipeImageView.image = [UIImage imageNamed:@"loadinggif.gif"];
    
    
    recipeImageView.animationImages= [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"tmp-1.gif"],[UIImage imageNamed:@"tmp-2.gif"],[UIImage imageNamed:@"tmp-3.gif"],[UIImage imageNamed:@"tmp-4.gif"],
                                      [UIImage imageNamed:@"tmp-5.gif"],[UIImage imageNamed:@"tmp-6.gif"],[UIImage imageNamed:@"tmp-7.gif"],[UIImage imageNamed:@"tmp-8.gif"],
                                      [UIImage imageNamed:@"tmp-9.gif"],[UIImage imageNamed:@"tmp-10.gif"],[UIImage imageNamed:@"tmp-11.gif"],[UIImage imageNamed:@"tmp-0.gif"],
                                      nil];
    recipeImageView.animationDuration = 1.0f;
    recipeImageView.animationRepeatCount = 0;
    [recipeImageView startAnimating];
    [recipeImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    //recipeImageView.image = [UIImage imageNamed:@"progress_image.png"];
    
    
    if(film.poster_path!=nil){
        NSString* imgPath= retornoConfiguration.images.base_url;
        imgPath = [imgPath stringByAppendingString:retornoConfiguration.images.poster_sizes[3]];
        imgPath = [imgPath stringByAppendingString:film.poster_path];
        NSURL *url = [[NSURL alloc] initWithString:imgPath];
        // download the image asynchronously
        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [recipeImageView stopAnimating];
                recipeImageView.image= image;// cache the image for use later (when scrolling up)
                [recipeImageView setContentMode:UIViewContentModeScaleAspectFit];
            }else{
                [recipeImageView stopAnimating];
                recipeImageView.image = [UIImage imageNamed:@"ic_error.png"];
                [recipeImageView setContentMode:UIViewContentModeRedraw];
            }
        }];
    }else{
        [recipeImageView stopAnimating];
        recipeImageView.image = [UIImage imageNamed:@"ic_error.png"];
        [recipeImageView setContentMode:UIViewContentModeRedraw];
    }
    
    return cell;
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}



- (IBAction)LoadMovies
{
    if (configured==true) {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.themoviedb.org/3"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://api.themoviedb.org/3/discover/movie?api_key=c4cd8d181d2a547a8b7ec7cdb9df1f9b&sort_by=popularity.desc"
                                                      parameters:@{@"page": [NSNumber numberWithInt:actual_page]}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* retorno = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError* err = nil;
        RetornoTMDB* retornoTMDB = [[RetornoTMDB alloc] initWithString:retorno error:&err];
        //NSLog(@"Response: %@", retornoTMDB);
        NSLog(@"%d", retornoTMDB.results.count);
        
        int index;
        index = filmes.count;
        for (int i=0; i<retornoTMDB.results.count; i++) {
            if(!filmes){
                filmes = [(NSMutableArray<FilmeInfo,Optional>*) [NSMutableArray alloc] init];
            }
            [filmes addObject: retornoTMDB.results[i]];
            
        }
        
        
        NSLog(@"%d", filmes.count);
        FilmeInfo *film= [[FilmeInfo alloc] init];
        for (int i=0; i<[filmes count]; i++) {
            film = [filmes objectAtIndex:i];
            NSLog(@"%@", film.original_title);
            
        }
        
        
        if(sortByRating==true){
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vote_average" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray = [filmes sortedArrayUsingDescriptors:sortDescriptors];
            filmes= [sortedArray mutableCopy];
        }
        
        [self.collectionView reloadData];
        
        
        //retornoTMDB=nil;
        //retorno= nil;
        
        
        // NSLog([filmes objectAtIndex:0]);
        
        
        
        
        //        NSString* str = film.original_title;
        //
        //        NSString* string = [retornoTMDB toJSONString];
        //        NSLog(@"%@",str);
        
        
        actual_page++;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    
    
    //    UIAlertView *helloWorldAlert = [[UIAlertView alloc]
    //                                    initWithTitle:@"My First App" message:@"Hello, World!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //
    //    // Display the Hello World Message
    //    [helloWorldAlert show];
    }
}

- (IBAction)SortByRating{
    
    sortByRating=true;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vote_average" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [filmes sortedArrayUsingDescriptors:sortDescriptors];
    filmes= [sortedArray mutableCopy];
    [self.collectionView reloadData];
    
}

- (IBAction)SortByPopularity{
    sortByRating=false;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"popularity" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [filmes sortedArrayUsingDescriptors:sortDescriptors];
    filmes= [sortedArray mutableCopy];
    [self.collectionView reloadData];
    
}


- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        MovieDetailViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destViewController.filme = [filmes objectAtIndex:indexPath.row];
        destViewController.configuraton = retornoConfiguration;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}


- (IBAction)optionsButtonPressed{

    
}



@end
