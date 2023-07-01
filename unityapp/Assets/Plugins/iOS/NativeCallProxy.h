#import <Foundation/Foundation.h>

// NativeCallsProtocolは、managedから呼び出したいメソッドのプロトコルを定義します。
//
// ネイティブコールによる通信はデリゲートを使って行われる。
// iOS側の開発者はUnityにデリゲートを登録し、
 // `NativeCallProxy`ファイルがUnityのコールとiOSのデリゲートの橋渡しを担当する。
@protocol NativeCallsProtocol
@required
- (void) onUnityStateChange:(const NSString*) state;
// other methods
@end

__attribute__ ((visibility("default")))
@interface FrameworkLibAPI : NSObject
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi;

@end
