#import <Foundation/Foundation.h>

typedef void (*TestDelegate)(const char* name);

// NativeCallsProtocolは、managedから呼び出したいメソッドのプロトコルを定義します。
//
// ネイティブコールによる通信はデリゲートを使って行われる。
// iOS側の開発者はUnityにデリゲートを登録し、
 // `NativeCallProxy`ファイルがUnityのコールとiOSのデリゲートの橋渡しを担当する。
@protocol NativeCallsProtocol
@required
- (void) onUnityStateChange:(const NSString*) state;
- (void) onSetTestDelegate:(TestDelegate) delegate;
// other methods
@end

__attribute__ ((visibility("default")))
@interface FrameworkLibAPI : NSObject
// NativeCallsProtocolメソッドを実装するオブジェクトを設定するために、UnityFrameworkLoadの後にいつでもこれを呼び出します。
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi;

@end
