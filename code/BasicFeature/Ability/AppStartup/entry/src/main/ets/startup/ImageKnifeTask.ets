import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';
import { ImageKnife } from '@ohos/imageknife'

@Sendable
export default class ImageKnifeTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    return ImageKnife.with(context);
  }

  onDependencyCompleted(dependence: string, result: Object): void {
  }
}