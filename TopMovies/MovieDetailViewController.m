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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"url_to_app_store"]];
    
    /** Cria dialogs para mostrar enquanto carrega as informacoes**/
    self.alertViewLoadingMovieInfo = [[UIAlertView alloc] initWithTitle:@"Loading Movie Info..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    self.alertViewLoadingTrailers = [[UIAlertView alloc] initWithTitle:@"Loading Movie Trailers..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(139.5, 75.5);
    [spinner startAnimating];
    [self.alertViewLoadingMovieInfo addSubview:spinner];
    [self.alertViewLoadingTrailers addSubview:spinner];
    
    /** Animacao de loading na imagem**/
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
    [self.MovieDuration setText: @"..."];
    [self.overviewTXT loadHTMLString:[NSString stringWithFormat:@"<div align='justify'><font  size='3'>...</font></div>"] baseURL:nil];
    
    
    [self loadMovieInfo];
    
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void) loadMovieInfo{
    
    [self.alertViewLoadingMovieInfo show];
    /** Path para carregar as informacoes do filme**/
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
        [self.alertViewLoadingMovieInfo dismissWithClickedButtonIndex:0 animated:YES];
        
        /** Trata o retorno da api e converte para um NSObject **/
        NSString* retorno = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError* err = nil;
        self.filmeInfo = [[RetornoMovieInfo alloc] initWithString:retorno error:&err];
        
        /** Devine os textos da view **/
        [self.MovieRate setText: [[NSString stringWithFormat:@"%.01f",self.filmeInfo.vote_average] stringByAppendingString:@"/10"]];
        [self.MovieYear setText: [[self.filmeInfo.release_date componentsSeparatedByString: @"-"] objectAtIndex: 0] ];
        [self.MovieDuration setText: [[NSString stringWithFormat:@"%.00f",self.filmeInfo.runtime] stringByAppendingString:@"min"]];
        
        /** Utiliza um webview para setar o texto justificado **/
        [self.overviewTXT loadHTMLString:[NSString stringWithFormat:@"<div align='justify'><font  size='3'> %@</font></div>",self.filmeInfo.overview] baseURL:nil];
        
        /** Carrega a imagem do filme a partir do path ou exibe uma imagem padrao de erro**/
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
        
        
        /** Carrega os trailers**/
        [self loadMovieTrailers];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.alertViewLoadingMovieInfo dismissWithClickedButtonIndex:0 animated:YES];

        /** Exibe uma mensagem de erro e retorna **/
        NSLog(@"Error: %@", error);
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error :[" message:@"Conection error, please try again!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [errorAlert show];
        
    }];
    [operation start];
    
}



- (void) loadMovieTrailers{
    [self.alertViewLoadingTrailers show];
    
    /** Path para carregar a lista de trailers**/
    NSString* trailersPath= @"http://api.themoviedb.org/3/movie/";
    trailersPath = [trailersPath stringByAppendingString:self.filme.id];
    trailersPath = [trailersPath stringByAppendingString:@"/videos?api_key=c4cd8d181d2a547a8b7ec7cdb9df1f9b"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.themoviedb.org/3"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                      path:trailersPath
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.alertViewLoadingTrailers dismissWithClickedButtonIndex:0 animated:YES];
        
        /** Trata o retorno da api e converte para um NSObject **/
        NSString* retorno = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError* err = nil;
        self.trailers = [[RetornoTrailer alloc] initWithString:retorno error:&err];
        NSLog(@"Retorno Trailer%@", retorno);
        
        /** Calcula o Tamanho da tableview de trailers **/
        CGFloat height = self.tableView.rowHeight;
        height *= self.trailers.results.count;
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = height;
        
        /** Seta e atualiza o Tamanho da tableview de trailers **/
        self.tableViewHeightConstraint.constant = height;
        self.tableView.frame = tableFrame;
        [self.tableView reloadData];
        [self.view setNeedsUpdateConstraints];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.alertViewLoadingTrailers dismissWithClickedButtonIndex:0 animated:YES];
        
        /** Exibe uma mensagem de erro e permanece na tela **/
        NSLog(@"Error: %@", error);
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error :[" message:@"Cannot download trailers info, please return and try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [errorAlert show];

    }];
    [operation start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.trailers.results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    /** Coloca o texto e a Imagem de um play na celula da tableview dos trailers **/
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(40, 6, 100, 28)];
    [textView setText: [@"Trailer " stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row+1] ]];
    [cell.contentView addSubview:textView];
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    imgView.backgroundColor=[UIColor clearColor];
    [imgView setImage:[UIImage imageNamed:@"play.png"]];
    [cell.contentView addSubview:imgView];
    
    return cell;
}


/** Funcao para baixar a imagem a partir de um url de forma assincrona **/
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock{
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


/** Atualiza o tamanho da webview com o overview do filme **/
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.overviewTXT.scrollView.scrollEnabled = NO;
    self.overviewHeightConstraint.constant = self.overviewTXT.scrollView.contentSize.height;
    [self.view setNeedsUpdateConstraints];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Clicked button index 0");
        [self close];
    } else {
        NSLog(@"Clicked button index other than 0");
        // Add another action here
    }
}



@end
