import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { abilityAccessCtrl } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import type Want from '@ohos.app.ability.Want';
import type window from '@ohos.window';
import emitter from '@ohos.events.emitter';
import { CommonConstants, DeviceUtils, EventConstants, Logger, NetManager } from '@ohos/common';
import { DeviceManagerFactory } from '@ohos/device_manager';
import { BusinessError } from '@kit.BasicServicesKit';
import { HMRouterMgr } from '@hadss/hmrouter';
import { display } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';

const TAG = 'EntryAbility';

/**
 * Lift cycle management of Ability.
 */
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppStorage.setOrCreate<boolean>('is4k', display.getDefaultDisplaySync().width > 3800);
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser((this.context), ['ohos.permission.ACCESS_BLUETOOTH']).then((data) => {
        console.log('data: ' + JSON.stringify(data));
      }).catch((err: object) => {
        console.log('err: ' + JSON.stringify(err));
      });
    } catch (err) {
      console.log('catch err->' + JSON.stringify(err));
    }
    HMRouterMgr.init({
      context: this.context
    });
    HMRouterMgr.openLog('DEBUG');
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    DeviceManagerFactory.createDeviceManager();
    NetManager.getInstance().initNetConnection();
    DeviceUtils.getDeviceId().then((value) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'add getDeviceId ' + value);
    }).catch((error: BusinessError) => {
      hilog.error(0x0000, 'testTag', '%{public}s', 'add getDeviceId error ' + error?.message);
    });
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    DeviceManagerFactory.releaseDeviceManager();
    NetManager.getInstance().releaseNetConnection();
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    const isPrivacyAllowed = await this.getPrivacyAllowed();
    windowStage.loadContent(isPrivacyAllowed ? 'pages/HomeIndex' : 'pages/LauncherPage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      windowStage.getMainWindowSync().setWindowBackgroundColor('#F1F3F5');
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
    let window = windowStage.getMainWindowSync();
    this.updateBreakpoint(window.getWindowProperties().windowRect.width);
    window.on('windowSizeChange', (data) => {
      this.updateBreakpoint(data.width);
    });
  }

  getPrivacyAllowed(): Promise<boolean> {
    return new Promise((resolve, reject) => {
      preferences.getPreferences(this.context, CommonConstants.PREFERENCES_FILE_NAME)
        .then((preferences: preferences.Preferences) => {
          return preferences.get(CommonConstants.PREFERENCES_KEY_PRIVACY, false);
        }).then((value: preferences.ValueType) => {
        if (value) {
          resolve(true);
        } else {
          resolve(false);
        }
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'getPrivacyAllowed fail error = ' + JSON.stringify(error));
        resolve(false);
      });
    });

  }

  private updateBreakpoint(width: number) {
    let windowWidthVp = width / (display.getDefaultDisplaySync().densityDPI / 160);
    let newBreakPoint: string = '';
    if (windowWidthVp < 400) {
      newBreakPoint = 'xs';
    } else if (windowWidthVp < 600) {
      newBreakPoint = 'sm';
    } else if (windowWidthVp < 800) {
      newBreakPoint = 'md';
    } else {
      newBreakPoint = 'lg';
    }
    AppStorage.setOrCreate('currentBreakpoint', newBreakPoint);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');

    let innerEvent: emitter.InnerEvent = {
      eventId: EventConstants.ON_FOREGROUND_EVENT,
      priority: emitter.EventPriority.HIGH
    };
    emitter.emit(innerEvent);
  }

  onBackground(): void {
    this.context.terminateSelf();
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
};