import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';
import { KvManagerUtil, TimeUtils } from '../util/SingleKVStore';
import distributedKVStore from '@ohos.data.distributedKVStore';
import systemDateTime from '@ohos.systemDateTime';

@Sendable
export default class KvManagerUtilTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext): Promise<distributedKVStore.KVManager> {
    let time = systemDateTime.getTime(false);
    TimeUtils.startTime = time;
    return KvManagerUtil.getInstance(context);
  }

  onDependencyCompleted(dependence: string, result: Object): void {
  }
}