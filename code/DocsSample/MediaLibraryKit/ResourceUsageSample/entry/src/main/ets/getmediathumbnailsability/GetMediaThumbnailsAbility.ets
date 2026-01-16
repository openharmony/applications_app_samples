/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { AbilityConstant, UIAbility, Want, abilityAccessCtrl } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { expect } from '@ohos/hypium';
import { saveMediaToGallery } from '../../../ohosTest/ets/Provider';
// [Start get_media_thumbnails]
import { dataSharePredicates } from '@kit.ArkData';
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

// [StartExclude get_media_thumbnails]
const DOMAIN = 0x0000;
// [EndExclude get_media_thumbnails]

async function example(phAccessHelper: photoAccessHelper.PhotoAccessHelper) {
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };

  try {
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = 
      await phAccessHelper.getAssets(fetchOptions);
    let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
    console.info('getAssets photoAsset.displayName : ' + photoAsset.displayName);
    let size: image.Size = { width: 720, height: 720 };
    let pixelMap: image.PixelMap =  await photoAsset.getThumbnail(size);
    let imageInfo: image.ImageInfo = await pixelMap.getImageInfo()
    console.info('getThumbnail successful, pixelMap ImageInfo size: ' + JSON.stringify(imageInfo.size));
    fetchResult.close();
    // [StartExclude get_media_thumbnails]
    return true;
    // [EndExclude get_media_thumbnails]
  } catch (err) {
    console.error('getThumbnail failed with err: ' + err);
    // [StartExclude get_media_thumbnails]
    return false;
    // [EndExclude get_media_thumbnails]
  }
}
// [End get_media_thumbnails]

export default class GetMediaThumbnailsAbility extends UIAbility {
  async runExample(): Promise<void> {
    try {
      const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      const permissionResult = await atManager.requestPermissionsFromUser(this.context, [
        'ohos.permission.READ_IMAGEVIDEO',
        'ohos.permission.WRITE_IMAGEVIDEO'
      ]);

      expect(permissionResult.permissions.length).assertEqual(2);

      let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
      await saveMediaToGallery(this.context, 'test.jpg');
      let result: boolean = await example(phAccessHelper);
      expect(result).assertTrue();
    } catch (err) {
      expect().assertFail();
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
    this.runExample();
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
