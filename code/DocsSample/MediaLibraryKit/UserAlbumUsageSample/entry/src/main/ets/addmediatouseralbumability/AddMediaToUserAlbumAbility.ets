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

// Before running this test case if it does not exist already
// you'll need to create a user album named 'test'

// [Start add_media_to_user_album]
import { dataSharePredicates } from '@kit.ArkData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

// [StartExclude add_media_to_user_album]
const DOMAIN = 0x0000;
// [EndExclude add_media_to_user_album]

async function example(phAccessHelper: photoAccessHelper.PhotoAccessHelper) {
  let albumPredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let albumName: photoAccessHelper.AlbumKeys = photoAccessHelper.AlbumKeys.ALBUM_NAME;
  albumPredicates.equalTo(albumName, 'test');
  let albumFetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: albumPredicates
  };

  let photoPredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let photoFetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: photoPredicates
  };

  try {
    let albumFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> = 
      await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.USER, 
        photoAccessHelper.AlbumSubtype.USER_GENERIC, albumFetchOptions);
    let album: photoAccessHelper.Album = await albumFetchResult.getFirstObject();
    console.info('getAlbums successfully, albumName: ' + album.albumName);
    let photoFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = 
      await phAccessHelper.getAssets(photoFetchOptions);
    let photoAsset: photoAccessHelper.PhotoAsset = await photoFetchResult.getFirstObject();
    console.info('getAssets successfully, albumName: ' + photoAsset.displayName);
    let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest = 
      new photoAccessHelper.MediaAlbumChangeRequest(album);
    albumChangeRequest.addAssets([photoAsset]);
    await phAccessHelper.applyChanges(albumChangeRequest);
    console.info('succeed to add ' + photoAsset.displayName + ' to ' + album.albumName);
    albumFetchResult.close();
    photoFetchResult.close();
    // [StartExclude add_media_to_user_album]
    return true;
    // [EndExclude add_media_to_user_album]
  } catch (err) {
    console.error('addAssets failed with err: ' + err);
    // [StartExclude add_media_to_user_album]
    return false;
    // [EndExclude add_media_to_user_album]
  }
}
// [End add_media_to_user_album]

export default class AddMediaToUserAlbumAbility extends UIAbility {
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
