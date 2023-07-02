#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"

@implementation FrameworkLibAPI

id<NativeCallsProtocol> api = NULL;
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi
{
    api = aApi;
}

@end

extern "C" {

    // ここに挙げた関数はUnityで利用できる。
    // 呼び出されると `api` デリゲートに転送されます。
    //
    // また、必要であれば**Cデータ構造体からObjective-Cへの
    // データ変換もここで行う必要があります。

    void
    sendUnityStateUpdate(const char* state)
    {
        const NSString* str = @(state);
        [api onUnityStateChange: str];
    }

    void
    setTestDelegate(TestDelegate delegate)
    {
        [api onSetTestDelegate: delegate];
    }

}
