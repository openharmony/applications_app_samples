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
// [Start get_favorite_object]
import { photoAccessHelper } from '@kit.MediaLibraryKit';

// [StartExclude get_favorite_object]
const DOMAIN = 0x0000;
// [EndExclude get_favorite_object]

async function example(phAccessHelper: photoAccessHelper.PhotoAccessHelper) {
  try {
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> = 
      await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.FAVORITE);
    let album: photoAccessHelper.Album = await fetchResult.getFirstObject();
    console.info('get favorite album successfully, albumUri: ' + album.albumUri);
    fetchResult.close();
    // [StartExclude get_favorite_object]
    return true;
    // [EndExclude get_favorite_object]
  } catch (err) {
    console.error('get favorite album failed with err: ' + err);
    // [StartExclude get_favorite_object]
    return false;
    // [EndExclude get_favorite_object]
  }
}
// [End get_favorite_object]

export default class GetFavoriteObjectAbility extends UIAbility {
  async runExample(): Promise<void> {
    try {
      const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      const permissionResult = await atManager.requestPermissionsFromUser(this.context, [
        'ohos.permission.READ_IMAGEVIDEO'
      ]);

      expect(permissionResult.permissions.length).assertEqual(2);

      let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
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
