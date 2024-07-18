import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';
import { KvManagerUtil } from '../util/SingleKVStore';
import distributedKVStore from '@ohos.data.distributedKVStore';

@Sendable
export default class KvManagerUtilTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext): Promise<distributedKVStore.KVManager> {
    return KvManagerUtil.getInstance(context);
  }

  onDependencyCompleted(dependence: string, result: Object): void {
  }
}