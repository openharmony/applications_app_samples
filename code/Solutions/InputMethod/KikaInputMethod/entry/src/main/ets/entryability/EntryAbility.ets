import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import inputMethod from '@ohos.inputMethod';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // inputMethod.getSetting().showOptionalInputMethods();
    try {
      this.getPermission();
    } catch (err) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'err is ' + err);
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/PrivatePreview', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  getPermission(): void {
    let array: Array<Permissions> = [
      'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED',
      'ohos.permission.START_ABILITIES_FROM_BACKGROUND'
    ];

    let atManager = abilityAccessCtrl.createAtManager();

    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(this.context, array).then((data) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'data type:' + typeof (data));
      hilog.info(0x0000, 'testTag', '%{public}s', 'data:' + data);
      hilog.info(0x0000, 'testTag', '%{public}s', 'data permissions:' + data.permissions);
      hilog.info(0x0000, 'testTag', '%{public}s', 'data result:' + data.authResults);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'Failed to start ability',JSON.stringify(err));
    });
  }
}
