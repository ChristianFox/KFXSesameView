//
//  KFXSesameView.h
//  Pods
//
//  Created by Leu on 22/09/2016.
//
//

#import <UIKit/UIKit.h>

NSString *const kKFXSesameViewCellRowIndexKEY = @"rowIndex";
NSString *const kKFXSesameViewCellColumnIndexKEY = @"columnIndex";
NSString *const kKFXSesameViewCellTapsRequiredKEY = @"tapsRequired";
NSString *const kKFXSesameViewCellSequencePositionKEY = @"sequencePosition";
NSString *const kKFXSesameViewCellIdentifierKEY = @"identifier";


NS_ASSUME_NONNULL_BEGIN
@class KFXSesameView;
@protocol KFXSesameViewDelegate <NSObject>

-(void)sesameViewDidUnlockEntireSequence:(KFXSesameView*)sesameView;
@optional
-(void)sesameView:(KFXSesameView*)sesameView didUnlockFirstCellInSequence:(NSDictionary*)cellData;
-(void)sesameView:(KFXSesameView*)sesameView didUnlockCell:(NSDictionary*)cellData;
-(void)sesameViewTimeDidExpireBeforeSequenceUnlockComplete:(KFXSesameView*)sesameView;

@end

@interface KFXSesameView : UIView

@property (weak, nonatomic) id<KFXSesameViewDelegate> delegate;
// Configurable Properties
@property (nonatomic) NSUInteger numberOfRows;
@property (nonatomic) NSUInteger numberOfColumns;
/// The time allowed between unlocking the first cell and unlocking the last. If all cells have not been unlocked in this time then any unlocked cells will reset to their locked state. This value can be 0 for unlimited time.
@property (nonatomic) NSTimeInterval timeLimit;
@property (nonatomic) BOOL showCells;
@property (nonatomic) BOOL lockCellsAfterSequenceCompletion;


/**
 * @brief Configure the cell at the given coordinates an being involved in the unlock sequence.
 * @discussion
 * @param columnIdx The column index of the cell to be configured as part of the unlock sequence. The index of the first row is 0. Must be less than the numberOfColums.
 * @param rowIdx The row index of the cell to be configured as part of the unlock sequence. The index of the first row is 0. Must be less than the numberOfRows.
 * @param tapsRequired The number of times the cell must be tapped to unlock it. Must be greater than 0.
 * @param error An NSError reference that will be initilised if an error occurs
 * @return YES if the cell was configured, NO if there was an error.
 * @since 0.1.0
 *
 **/
-(BOOL)configureCellAtColumn:(NSUInteger)columnIdx
                   row:(NSUInteger)rowIdx
             tapsRequired:(NSUInteger)tapsRequired
                  identifier:(NSString*_Nullable)identifier
                    error:(NSError**)error;




@end
NS_ASSUME_NONNULL_END