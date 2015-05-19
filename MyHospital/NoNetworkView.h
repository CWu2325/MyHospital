
#import <UIKit/UIKit.h>

@protocol MyRequestNetworkDalegate <NSObject>

@optional

- ( void ) equestNetwork;

@end

@interface NoNetworkView : UIView

@property(nonatomic,weak)id<MyRequestNetworkDalegate>delegate;

@property(nonatomic,strong)UIImageView *noNetWorkImageView;
@property(nonatomic,strong)UILabel *remindLabel;
@property(nonatomic,strong)UIButton *resetBtn;

@end
