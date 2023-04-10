[![Latest Version](https://img.shields.io/github/v/tag/ChristianFox/KFXSesameView?sort=semver&label=Version&color=orange)](https://github.com/ChristianFox/KFXSesameView/)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-orange)](https://img.shields.io/badge/Platforms-iOS-orange)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-yes-green)](https://img.shields.io/badge/Cocoapods-yes-green)
[![Cathage](https://img.shields.io/badge/Cathage-no-red)](https://img.shields.io/badge/Cathage-no-red)
[![Manually](https://img.shields.io/badge/Manual_Import-yes-green)](https://img.shields.io/badge/Manual_Import-yes-green)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](https://github.com/ChristianFox/KFXSesameView/blob/master/LICENSE)
[![Contribution](https://img.shields.io/badge/Contributions-Welcome-blue)](https://github.com/ChristianFox/KFXSesameView/labels/contribute)
[![First Timers Friendly](https://img.shields.io/badge/First_Timers-Welcome-blue)](https://github.com/ChristianFox/KFXSesameView/labels/contribute)
[![Size](https://img.shields.io/github/repo-size/ChristianFox/KFXSesameView?color=orange)](https://img.shields.io/github/repo-size/ChristianFox/KFXSesameView?color=orange)
[![Files](https://img.shields.io/github/directory-file-count/ChristianFox/KFXSesameView?color=orange)](https://img.shields.io/github/directory-file-count/ChristianFox/KFXSesameView?color=orange)

# WARNING - This project has not been updated in a while and will be deprecated at some point in the future

# KFXSesameView

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements


## Example
When run the example project will display a table view with 3 cells each leading to a different example.
Tap the 'Show instructions' button to see the sequence of taps needed for that example.
Tap 'show cells' to show the cells with random colours.

## Requirements
iOS 8+

Xcode 7+


## Installation

KFXSesameView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KFXSesameView"
```

## Introduction
Open Sesame!

The basic idea is to have a hidden keypad in your app that can be used to unlock a secret part area for example a debug mode or an easter egg.
Provides a single class: KFXSesameView which contains a UICollectionView. The collection view is used to layout a grid of cells and each cell can be added to a sequence of taps. Tap all in the seqence within a time limit and get a delegate callback. Then you can present a new view controller or do whatever you want.



## Usage
#### Create a SesameView 
In your UIView or UIViewController import KFXSesameView.h then instantiate an instance of KFXSesameView using -init or -initWithFrame:. You can also add the view to a storyboard although you will still need to set the properties programatically.
KFXSesameView should be added as a subview to another view and should be the top userInteractionEnabled view so that it receives all touches.

```objective-c
    KFXSesameView *sesameView = [[KFXSesameView alloc]initWithFrame:self.aView.bounds];
    sesameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.aView addSubview:sesameView];
```


#### Set Properties
**.numberOfRows & .numberOfColumns** - How many rows & columns in the grid, best to keep the number low as a high number of cells can make it difficult to enter the correct sequence. Defaults to 0 for each.

**.timeLimit** - This is the number of seconds the user has to unlock all the cells in the sequence after unlocking first cell. Defaults to 0 (unlimited time).

**.showCells** - Should the cells be visible or not. If YES each cell will be filled with a random Colour. Defaults to NO.

**.lockCellsAfterSequenceCompletion** - If this property is set to YES then all the cells will be relocked once the delegate has been informed that they have been unlocked. Defaults to YES.

**.delegate** - Set the object that conforms to KFXSesameViewDelegate

```objective-c
    sesameView.numberOfRows = 4;
    sesameView.numberOfColumns = 4;
    sesameView.timeLimit = 15.0;
    sesameView.showCells = YES;
    sesameView.lockCellsAfterSequenceCompletion = YES;
    sesameView.delegate = self;
```


#### Add cells to sequence
You add cells to the unlock sequence by calling -addCellToSequenceAtColumn:row:tapsRequired:identifier:error:
You should check the return property and the error that will be created if a problem was found.

``` objective-c
    NSError *error;
    if (![sesameView addCellToSequenceAtColumn:1
                                           row:2
                                  tapsRequired:2
                                    identifier:@"first"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
```

#### KFXSesameViewDelegate 
Implement the one required delegate method to be notified when the sequence has been completed. There are also two optional methods you can use.

```objective-c
-(void)sesameViewDidUnlockEntireSequence:(KFXSesameView *)sesameView{
    NSLog(@"Did complete unlock sequence ");
}

-(void)sesameViewTimeDidExpireBeforeSequenceUnlockComplete:(KFXSesameView *)sesameView{
    NSLog(@"Time did expire");
}

-(void)sesameView:(KFXSesameView *)sesameView didUnlockCell:(NSDictionary *)cellData{
    NSLog(@"Did unlock cell: %@",cellData);    
}

```

## Author

Christian Fox, christianfox890@icloud.com

## License

KFXSesameView is available under the MIT license. See the LICENSE file for more info.
