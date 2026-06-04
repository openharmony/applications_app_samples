'use static'

import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { BusinessError } from '@ohos.base';
import hilog from '@ohos.hilog';

const DOMAIN_NUMBER: int = 0x0000;

class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN_NUMBER, 'testTag', 'EntryAbility onCreate');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN_NUMBER, 'testTag', 'EntryAbility onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err: BusinessError<void> | null): void => {
      hilog.info(DOMAIN_NUMBER, 'testTag', 'loadContent entering');
      if (err && err.code) {
        hilog.error(DOMAIN_NUMBER, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN_NUMBER, 'testTag', 'loadContent ok');
    });
  }
}