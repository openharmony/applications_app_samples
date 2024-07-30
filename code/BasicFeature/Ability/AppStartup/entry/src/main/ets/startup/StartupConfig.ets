import StartupConfig from '@ohos.app.appstartup.StartupConfig'
import StartupConfigEntry from '@ohos.app.appstartup.StartupConfigEntry';
import StartupListener from '@ohos.app.appstartup.StartupListener';
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base'
import systemDateTime from '@ohos.systemDateTime';
import Logger from '../util/Logger';
import { TimeUtils } from '../util/SingleKVStore';

export default class MyStartupConfigEntry extends StartupConfigEntry {
  onConfig() {
    hilog.info(0x0000, 'testTag', `onConfig`);
    let onCompletedCallback = (error: BusinessError<void>) => {
      hilog.info(0x0000, 'testTag', `onCompletedCallback`);
      if (error) {
        hilog.info(0x0000, 'testTag', 'onCompletedCallback: %{public}d, message: %{public}s', error.code, error.message);
      } else {
        let time = systemDateTime.getTime(false);
        TimeUtils.endTime = time;
        Logger.info('testTag startup init -> success time--:' + TimeUtils.countTime() + 'ms');
        hilog.info(0x0000, 'testTag', `onCompletedCallback: success.`);
      }
    }
    let startupListener: StartupListener = {
      'onCompleted': onCompletedCallback
    }
    let config: StartupConfig = {
      'timeoutMs': 10000,
      'startupListener': startupListener
    }
    return config;
  }
}
