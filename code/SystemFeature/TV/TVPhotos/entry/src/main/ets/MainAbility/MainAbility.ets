import type window from '@ohos.window';
import Logger from '../common/Logger';
import { GlobalContext } from '../common/GlobalContext';
import Ability from '@ohos.app.ability.UIAbility';
import { AbilityConstant } from '@kit.AbilityKit';

const TAG = 'MainAbility: ';

export default class MainAbility extends Ability {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.info(TAG, 'ability on create ' + JSON.stringify(want))
    globalThis.startByFileMgr = false;
    this.handleWant(want);
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    console.info(TAG, 'ability on newWant ' + JSON.stringify(want))
    this.handleWant(want)
  }

  onDestroy(): void {
    AppStorage.clear();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'onWindowStageCreate')
    GlobalContext.getContext().setObject('photosWindowStage', windowStage);
    globalThis.abilityContext = this.context;
    windowStage.getMainWindow().then((win) => {
      globalThis.mainWindow = win;
      AppStorage.setOrCreate('window_width', win.getWindowProperties().windowRect.width);
      AppStorage.setOrCreate('window_height', win.getWindowProperties().windowRect.height);
      let loadContentUrl = 'pages/PhotoWatch';
      Logger.info(TAG, 'onWindowStageCreate loadContent')
      windowStage.loadContent(loadContentUrl, (err) => {
        if (err.code) {
          return;
        }
      })
    })
  }

  handleWant(want: Want) {
    let picUri: string = want?.parameters?.uri as string;
    let picType: string = want?.parameters?.type as string;
    let close: boolean = want?.parameters?.close as boolean
    if (close) {
      this.context.terminateSelf()
    } else if (picUri) {
      Logger.info(TAG, 'receive from file manager, picUri=' + picUri);
      globalThis.startByFileMgr = true;
      AppStorage.setOrCreate('directUri', picUri);
      AppStorage.setOrCreate('directType', picType);
      return;
    }
  }
}
