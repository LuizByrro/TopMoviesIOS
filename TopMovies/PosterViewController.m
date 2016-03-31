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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    /** Cria dialogs para mostrar enquanto carrega as informacoes**/
    self.alertViewConfiguring = [[UIAlertView alloc] initWithTitle:@"Configuring..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    self.alertViewLoadingMovies = [[UIAlertView alloc] initWithTitle:@"Loading Movies..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]; 
    spinner.center = CGPointMake(139.5, 75.5);
    [spinner startAnimating];
    [self.alertViewConfiguring addSubview:spinner];
    [self.alertViewLoadingMovies addSubview:spinner];
    
    
    total_pages=50;
    actual_page=1;
    sortByRating=false;
    configured=false;
    itens_perPage=20;
    filmes = [(NSMutableArray<FilmeInfo,Optional>*) [NSMutableArray alloc] init];
    [self configure];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return filmes.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"PosterCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    FilmeInfo *film= [[FilmeInfo alloc] init];
    film = filmes[indexPath.row];
    
    /** Animacao de loading enquanto carrega a imagem**/
    recipeImageView.animationImages= [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"tmp-1.gif"],[UIImage imageNamed:@"tmp-2.gif"],[UIImage imageNamed:@"tmp-3.gif"],[UIImage imageNamed:@"tmp-4.gif"],
                                      [UIImage imageNamed:@"tmp-5.gif"],[UIImage imageNamed:@"tmp-6.gif"],[UIImage imageNamed:@"tmp-7.gif"],[UIImage imageNamed:@"tmp-8.gif"],
                                      [UIImage imageNamed:@"tmp-9.gif"],[UIImage imageNamed:@"tmp-10.gif"],[UIImage imageNamed:@"tmp-11.gif"],[UIImage imageNamed:@"tmp-0.gif"],
                                      nil];
    recipeImageView.animationDuration = 1.0f;
    recipeImageView.animationRepeatCount = 0;
    [recipeImageView startAnimating];
    [recipeImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    if(film.poster_path!=nil){
        
        /**Cria a url para baixar a imagem**/
        NSString* imgPath= retornoConfiguration.images.base_url;
        imgPath = [imgPath stringByAppendingString:retornoConfiguration.images.poster_sizes[3]];
        imgPath = [imgPath stringByAppendingString:film.poster_path];
        NSURL *url = [[NSURL alloc] initWithString:imgPath];
        
        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [recipeImageView stopAnimating];
                recipeImageView.image= image;// cache the image
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableview = footerview;
    }
    return reusableview;
}

-(void)configure{
    [self.alertViewConfiguring show];
    
    /** Conecta com o servidor e configura o aplicativo**/
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.themoviedb.org/3"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://api.themoviedb.org/3/configuration?api_key=c4cd8d181d2a547a8b7ec7cdb9df1f9b"
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.alertViewConfiguring dismissWithClickedButtonIndex:0 animated:YES];
        
        /** Converte o retorno para objeto (Utiliza a classe JsonModel**/
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSString* retorno = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        retornoConfiguration = [[RetornoConfiguration alloc] initWithString:retorno error:nil];
        configured=true;
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.alertViewConfiguring dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@"Error: %@", error);
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error :[" message:@"Conection error, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }];
    [operation start];
}

- (IBAction)LoadMovies{
    
    if (configured==true) {
        [self.alertViewLoadingMovies dismissWithClickedButtonIndex:0 animated:YES];
        /** Conecta com o servidor e baixa os filmes por pagina de 20 em 20**/
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.themoviedb.org/3"]];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:@"http://api.themoviedb.org/3/discover/movie?api_key=c4cd8d181d2a547a8b7ec7cdb9df1f9b&sort_by=popularity.desc"
                                                          parameters:@{@"page": [NSNumber numberWithInt:actual_page]}];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.alertViewLoadingMovies dismissWithClickedButtonIndex:0 animated:YES];
            
            /** Converte o retorno para objeto (Utiliza a classe JsonModel)**/
            NSString* retorno = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSError* err = nil;
            RetornoTMDB* retornoTMDB = [[RetornoTMDB alloc] initWithString:retorno error:&err];
            NSLog(@"Response: %@", retornoTMDB);
            
            
            /** Preenche a lista**/
            int index;
            index = filmes.count;
            for (int i=0; i<retornoTMDB.results.count; i++) {
                if(!filmes){
                    filmes = [(NSMutableArray<FilmeInfo,Optional>*) [NSMutableArray alloc] init];
                }
                [filmes addObject: retornoTMDB.results[i]];
            }
            
            
            /** ordena por rating se essa for a opcao selecionada **/
            if(sortByRating==true){
                NSSortDescriptor *sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vote_average" ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedArray = [filmes sortedArrayUsingDescriptors:sortDescriptors];
                filmes= [sortedArray mutableCopy];
            }
            
            /** Recarrega a Pagina**/
            [self.collectionView reloadData];
            actual_page++;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.alertViewLoadingMovies dismissWithClickedButtonIndex:0 animated:YES];
            NSLog(@"Error: %@", error);
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Error :[" message:@"Conection error, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }];
        [operation start];
    }else{
        [self configure];
    }
}



/** Ordena **/
- (void)SortByRating{
    sortByRating=true;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vote_average" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [filmes sortedArrayUsingDescriptors:sortDescriptors];
    filmes= [sortedArray mutableCopy];
    [self.collectionView reloadData];
    
}


/** Ordena **/
- (void)SortByPopularity{
    sortByRating=false;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"popularity" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [filmes sortedArrayUsingDescriptors:sortDescriptors];
    filmes= [sortedArray mutableCopy];
    [self.collectionView reloadData];
    
}


/** Limpa a lista de filmes **/
- (IBAction)Clear{
    [filmes removeAllObjects];
    actual_page=1;
    [self.collectionView reloadData];
    
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

/** Quando a imagem e selecionada, abre a view com o detalhes do filme**/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    MovieDetailViewController *destViewController = segue.destinationViewController;
    NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
    destViewController.filme = [filmes objectAtIndex:indexPath.row];
    destViewController.configuraton = retornoConfiguration;
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
}


/**Acao para abrir o menu de opcoes**/
-(IBAction)chooseOptionButtonTapped:(id)sender{
    if (self.optionPicker == nil) {
        /**Cria o popover**/
        self.optionPicker = [[optionsViewController alloc] initWithStyle:UITableViewStylePlain];
        
        /**Seta esta view como delegate**/
        self.optionPicker.delegate = self;
    }
    
    if (self.optionPickerPopover == nil) {
        self.optionPickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.optionPicker];
        [self.optionPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                                         permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [self.optionPickerPopover dismissPopoverAnimated:YES];
        self.optionPickerPopover = nil;
    }
}



/**Retorno do menu de opcoes**/
-(void)selectedOption:(NSString *)option{
    
    if ([option isEqualToString:@"Sort By Popularity"]) {
        [self SortByPopularity];
    } else if ([option isEqualToString:@"Sort By Rating"]){
        [self SortByRating];
    }
    
    /** para de mostrar o popover**/
    if (self.optionPickerPopover) {
        [self.optionPickerPopover dismissPopoverAnimated:YES];
        self.optionPickerPopover = nil;
    }
}



@end
