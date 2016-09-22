//
//  KFXViewController.m
//  KFXSesameView
//
//  Created by Christian Fox on 09/22/2016.
//  Copyright (c) 2016 Christian Fox. All rights reserved.
//

#import "KFXViewController.h"
#import <KFXSesameView/KFXSesameView.h>

@interface KFXViewController () <KFXSesameViewDelegate>

@end

@implementation KFXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    KFXSesameView *sesameView = [[KFXSesameView alloc]initWithFrame:CGRectMake(10.0, 10.0, 300.0, 400.0)];
    sesameView.numberOfRows = 4;
    sesameView.numberOfColumns = 4;
    sesameView.showCells = YES;
    sesameView.delegate = self;
    sesameView.timeLimit = 10.0;
    
    NSError *error;
    if (![sesameView configureCellAtColumn:0
                                       row:0
                              tapsRequired:1
                                identifier:@"first"
                                     error:&error]){
        NSLog(@"ERROR: %@",error);
    }
    if (![sesameView configureCellAtColumn:3
                                       row:0
                              tapsRequired:2
                                identifier:@"second"
                                     error:&error]){
        NSLog(@"ERROR: %@",error);
        
    }
    if (![sesameView configureCellAtColumn:0
                                       row:3
                              tapsRequired:3
                                identifier:@"third"
                                     error:&error]){
        NSLog(@"ERROR: %@",error);
        
    }
    if (![sesameView configureCellAtColumn:3
                                       row:3
                              tapsRequired:4
                                identifier:@"forth"
                                     error:&error]){
        NSLog(@"ERROR: %@",error);
        
    }
    
    
    [self.view addSubview:sesameView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//--------------------------------------------------------
#pragma mark - KFXSesameViewDelegate
//--------------------------------------------------------
-(void)sesameView:(KFXSesameView *)sesameView didUnlockFirstCellInSequence:(NSDictionary *)cellData{
    
    //    NSLog(@"Did unlock first cell: %@",cellData);
    NSLog(@"Did unlock first cell");
}

-(void)sesameViewTimeDidExpireBeforeSequenceUnlockComplete:(KFXSesameView *)sesameView{
    NSLog(@"Time did expire");
}

-(void)sesameView:(KFXSesameView *)sesameView didUnlockCell:(NSDictionary *)cellData{
    //    NSLog(@"Did unlock cell: %@",cellData);
    NSLog(@"Did unlock cell with ID: %@",cellData[kKFXSesameViewCellIdentifierKEY]);
    
}

-(void)sesameViewDidUnlockEntireSequence:(KFXSesameView *)sesameView{
    
    NSLog(@"Did complete unlock sequence ");
}



@end
