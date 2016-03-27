//
//  PosterViewController.m
//  TopMovies
//
//  Created by Luiz Byrro on 25/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import "PosterViewController.h"
#import <AFNetworking/AFNetworking.h>


@interface PosterViewController (){
    NSArray *recipeImages;
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
    recipeImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.themoviedb.org/3"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://api.themoviedb.org/3/configuration?api_key=c4cd8d181d2a547a8b7ec7cdb9df1f9b"
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
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
    return recipeImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PosterCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
        recipeImageView.image = [UIImage imageNamed:@"superman.jpg"];
        
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



@end
