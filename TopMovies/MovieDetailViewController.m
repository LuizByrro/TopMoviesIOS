//
//  MovieDetailViewController.m
//  TopMovies
//
//  Created by Luiz Byrro on 29/03/16.
//  Copyright (c) 2016 Luiz Byrro. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "AFImageRequestOperation.h"
#import <AFNetworking/AFNetworking.h>

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

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
    
    
    [self.MoviePoster setContentMode:UIViewContentModeScaleAspectFit];
    self.MoviePoster.animationImages= [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"tmp-1.gif"],[UIImage imageNamed:@"tmp-2.gif"],[UIImage imageNamed:@"tmp-3.gif"],[UIImage imageNamed:@"tmp-4.gif"],
                                       [UIImage imageNamed:@"tmp-5.gif"],[UIImage imageNamed:@"tmp-6.gif"],[UIImage imageNamed:@"tmp-7.gif"],[UIImage imageNamed:@"tmp-8.gif"],
                                       [UIImage imageNamed:@"tmp-9.gif"],[UIImage imageNamed:@"tmp-10.gif"],[UIImage imageNamed:@"tmp-11.gif"],[UIImage imageNamed:@"tmp-0.gif"],
                                       nil];
    self.MoviePoster.animationDuration = 1.0f;
    self.MoviePoster.animationRepeatCount = 0;
    [self.MoviePoster startAnimating];
    
    
    
    [self.MovieName setText: self.filme.original_title];
    
    
    [self.MovieYear setText: @"..."];
    [self.MovieRate setText: @".../10"];
    [self.MovieOverview setText: @"..."];
    [self.MovieDuration setText: @"..."];
    
    [self loadMovieInfo];
    [self loadMovieTrailers];
    
    
    
    

    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (void) loadMovieInfo{
    
    
    NSString* movieInfoPath= @"http://api.themoviedb.org/3/movie/";
    movieInfoPath = [movieInfoPath stringByAppendingString:self.filme.id];
    movieInfoPath = [movieInfoPath stringByAppendingString:@"?api_key=c4cd8d181d2a547a8b7ec7cdb9df1f9b"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.themoviedb.org/3"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:movieInfoPath
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* retorno = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError* err = nil;
        self.filmeInfo = [[RetornoMovieInfo alloc] initWithString:retorno error:&err];
        
        [self.MovieRate setText: [[NSString stringWithFormat:@"%.01f",self.filmeInfo.vote_average] stringByAppendingString:@"/10"]];
        [self.MovieYear setText: [[self.filmeInfo.release_date componentsSeparatedByString: @"-"] objectAtIndex: 0] ];
        [self.MovieDuration setText: [[NSString stringWithFormat:@"%.00f",self.filmeInfo.runtime] stringByAppendingString:@"min"]];
        
        
//        self.MovieOverview.numberOfLines=0;
//        float width = 280;
//        CGSize maximumLabelSize = CGSizeMake(width, 9999);
//        CGSize expectedLabelSize = [self.filme.overview sizeWithFont:self.MovieOverview.font constrainedToSize:maximumLabelSize lineBreakMode:self.MovieOverview.lineBreakMode];
//        CGRect frame = self.MovieOverview .frame;
//        frame.size.height = expectedLabelSize.height;
//        self.overviewLabelViewHeightConstraint.constant = expectedLabelSize.height+5;
//        [self.MovieOverview setText: self.filme.overview];
        
        
        
        
        
       // [self.overviewTXT loadHTMLString:[NSString stringWithFormat:@"<div align='justify'><font face='arial' size='3'> %@</font></div>",self.filmeInfo.overview] baseURL:nil];
        [self.overviewTXT loadHTMLString:[NSString stringWithFormat:@"<div align='justify'><font  size='3'> %@</font></div>",self.filmeInfo.overview] baseURL:nil];
        
        
        
        //[self.view setNeedsUpdateConstraints];


        
        if(self.filmeInfo.poster_path!=nil){
            NSString* imgPath= self.configuraton.images.base_url;
            imgPath = [imgPath stringByAppendingString:self.configuraton.images.poster_sizes[3]];
            imgPath = [imgPath stringByAppendingString:self.filmeInfo.poster_path];
            NSURL *url = [[NSURL alloc] initWithString:imgPath];
            [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    [self.MoviePoster stopAnimating];
                    self.MoviePoster.image= image;
                    [self.MoviePoster setContentMode:UIViewContentModeScaleAspectFill];
                }else{
                    [self.MoviePoster stopAnimating];
                    self.MoviePoster.image = [UIImage imageNamed:@"ic_error.png"];
                    [self.MoviePoster setContentMode:UIViewContentModeRedraw];
                }
            }];
        }else{
            [self.MoviePoster stopAnimating];
            self.MoviePoster.image = [UIImage imageNamed:@"ic_error.png"];
            [self.MoviePoster setContentMode:UIViewContentModeRedraw];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
    
    
    
}



- (void) loadMovieTrailers{
    
    
    NSString* trailersPath= @"http://api.themoviedb.org/3/movie/";
    trailersPath = [trailersPath stringByAppendingString:self.filme.id];
    trailersPath = [trailersPath stringByAppendingString:@"/videos?api_key=c4cd8d181d2a547a8b7ec7cdb9df1f9b"];
    //NSURL *url = [[NSURL alloc] initWithString:imgPath];
    
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.themoviedb.org/3"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:trailersPath
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* retorno = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError* err = nil;
        self.trailers = [[RetornoTrailer alloc] initWithString:retorno error:&err];
        //NSLog(@"Response: %@", retornoTMDB);
        NSLog(@"%@", self.trailers);
        

    
            CGFloat height = self.tableView.rowHeight;
            height *= self.trailers.results.count;
            CGRect tableFrame = self.tableView.frame;
            tableFrame.size.height = height;
       
     NSLog(@"%f", self.tableView.rowHeight);
      
   self.tableViewHeightConstraint.constant = height;
        [self.view setNeedsUpdateConstraints];

    self.tableView.frame = tableFrame;
        
    [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.trailers.results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(40, 6, 100, 28)];
    [textView setText: [@"Trailer " stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row+1] ]];
    
    // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    [cell.contentView addSubview:textView];
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    imgView.backgroundColor=[UIColor clearColor];
    [imgView setImage:[UIImage imageNamed:@"play.png"]];
    [cell.contentView addSubview:imgView];
    
    
    
    return cell;
    
}


- (CGFloat)getLabelsize:(UILabel *)label
{
    CGSize maxSize = CGSizeMake(label.frame.size.width, 9999);
    CGSize requiredSize = [label sizeThatFits:maxSize];
    
    return requiredSize.height;
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



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.overviewTXT.scrollView.scrollEnabled = NO;
    self.overviewHeightConstraint.constant = self.overviewTXT.scrollView.contentSize.height;
}



@end
