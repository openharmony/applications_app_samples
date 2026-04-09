import Want from '@ohos.app.ability.Want';
import Logger from '../common/Logger';
import { AbilityConstant, UIAbility } from '@kit.AbilityKit';
import window from '@ohos.window';
import { GlobalContext } from '../common/GlobalContext';
import photoManager from '../manager/PhotoManager';

const TAG = '[PickerUIAbility]'

export default class PickerAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'onCreate')
    globalThis.pickAbilityContext = this.context;
    // 初始化图库中各相册的数据
    photoManager.init(this.context)
    this.handleWant(want);
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'ability on newWant ' + JSON.stringify(want))
    this.handleWant(want)
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'onWindowStageCreate')
    GlobalContext.getContext().setObject('photosWindowStage', windowStage);
    globalThis.abilityContext = this.context;
    windowStage.getMainWindow().then((win) => {
      globalThis.mainWindow = win;
      AppStorage.setOrCreate('window_width', win.getWindowProperties().windowRect.width);
      AppStorage.setOrCreate('window_height', win.getWindowProperties().windowRect.height);
      let loadContentUrl = 'pages/ThirdSelectPhotoGridPage';
      Logger.info(TAG, 'onWindowStageCreate loadContent')
      windowStage.loadContent(loadContentUrl, (err) => {
        if (err.code) {
          return;
        }
      })
    })
  }

  handleWant(want: Want) {
    let count: number = want?.parameters?.maxSelectCount as number;
    let close: boolean = want?.parameters?.close as boolean
    if (close) {
      this.context.terminateSelf()
    } else if (count) {
      Logger.info(TAG, 'count=' + count);
      AppStorage.setOrCreate('pickMaxSelectCount', count);
      return;
    }
  }
}