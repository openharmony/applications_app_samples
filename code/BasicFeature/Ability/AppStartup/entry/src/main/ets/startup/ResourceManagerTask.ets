import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';


@Sendable
export default class ResourceManagerTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    try {
      let value = context.resourceManager.getMediaContentSync($r('app.media.startIcon').id); // 默认屏幕密度
      let imageSource: image.ImageSource = image.createImageSource(value.buffer);
      let pixelMap = imageSource.createPixelMapSync();
      pixelMap.rotateSync(45);
      AppStorage.setAndLink<PixelMap>('image', pixelMap);
    } catch (error) {
    }
  }

  onDependencyCompleted(dependence: string): void {
  }
}

