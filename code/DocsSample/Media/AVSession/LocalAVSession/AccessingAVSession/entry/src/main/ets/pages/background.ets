import { BusinessError } from '@kit.BasicServicesKit';
import { avSession } from '@kit.AVSessionKit';

@Entry
@Component
struct Index {
  @State message: string = 'hello world';

  build() {
    Column() {
      Text(this.message)
        .onClick(() => {
          let currentAVSession: avSession.AVSession | undefined = undefined;
          let tag = 'createNewSession';
          let context: Context = this.getUIContext().getHostContext() as Context;
          avSession.createAVSession(context, tag, 'audio', (err: BusinessError, data: avSession.AVSession) => {
            if (err) {
              console.error(`CreateAVSession BusinessError: code: ${err.code}, message: ${err.message}`);
            } else {
              currentAVSession = data;
            }
          });
          if (currentAVSession !== undefined) {
            try {
              (currentAVSession as avSession.AVSession)
                .setBackgroundPlayMode(avSession.BackgroundPlayMode.ENABLE_BACKGROUND_PLAY);
            } catch (err) {
              console.error(`setBackgroundPlayMode BusinessError: code: ${err.code}, message: ${err.message}`);
            }
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}