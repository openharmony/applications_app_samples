/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { afterEach, beforeEach, describe, expect, it } from '@ohos/hypium';
import { common } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import photoManager from '../../../main/ets/manager/PhotoManager';
import { AllPhotoLoader } from '../../../main/ets/manager/loader/AllPhotoLoader';
import { BasePhotoLoader } from '../../../main/ets/manager/loader/BasePhotoLoader';
import { FavoritePhotoLoader } from '../../../main/ets/manager/loader/FavoritePhotoLoader';
import { fileModelsEquals } from '../../../main/ets/manager/loader/LoadUtil';
import { ScreenShotPhotoLoader } from '../../../main/ets/manager/loader/ScreenShotPhotoLoader';
import { TrashPhotoLoader } from '../../../main/ets/manager/loader/TrashPhotoLoader';
import { AlbumModel, AlbumType, PhotoModel } from '../../../main/ets/models/PhotoModel';
import { TestAsserts } from './base/TestAsserts';
import { TestDataFactory } from './base/TestDataFactory';

class StubLoader extends BasePhotoLoader {
  albumType: AlbumType;
  tag: string;
  mediaItems: PhotoModel[] = [];
  deletedBatches: PhotoModel[][] = [];
  recoveredBatches: PhotoModel[][] = [];
  changeSnapshots: string[][] = [];
  refreshFetchCount: number = 0;
  refreshDelayMs: number = 0;

  constructor(albumType: AlbumType, tag: string) {
    super();
    this.albumType = albumType;
    this.tag = tag;
  }

  getAlbumModel(): AlbumModel {
    return new AlbumModel(this.albumType, `album_${this.albumType}`);
  }

  getTag(): string {
    return this.tag;
  }

  async getMediaItems(context: Context): Promise<PhotoModel[]> {
    this.refreshFetchCount++;
    if (this.refreshDelayMs > 0) {
      await this.waitForDelay(this.refreshDelayMs);
    }
    return this.mediaItems.map((item) => item);
  }

  async doDelete(photos: PhotoModel[]): Promise<void> {
    this.deletedBatches.push([...photos]);
  }

  async doRecover(photos: PhotoModel[]): Promise<void> {
    this.recoveredBatches.push([...photos]);
  }

  async onFileAssetChange(): Promise<void> {
    this.changeSnapshots.push(this.fileAssetsCopy().map((item) => item.uri));
  }

  async waitForDelay(delayMs: number): Promise<void> {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve();
      }, delayMs);
    });
  }
}

class MockPhotoAssetRecord {
  photoType: photoAccessHelper.PhotoType;
  duration: number;
  dateDay: number;
  dateTrashedMs: number;
  width: number;
  height: number;

  constructor(photoType: photoAccessHelper.PhotoType, duration: number, dateDay: number, dateTrashedMs: number,
    width: number, height: number) {
    this.photoType = photoType;
    this.duration = duration;
    this.dateDay = dateDay;
    this.dateTrashedMs = dateTrashedMs;
    this.width = width;
    this.height = height;
  }

  get(key: string): Object {
    if (key === photoAccessHelper.PhotoKeys.DURATION as string) {
      return this.duration;
    }
    if (key === photoAccessHelper.PhotoKeys.DATE_DAY as string) {
      return this.dateDay;
    }
    if (key === photoAccessHelper.PhotoKeys.DATE_TRASHED_MS as string) {
      return this.dateTrashedMs;
    }
    if (key === photoAccessHelper.PhotoKeys.WIDTH as string) {
      return this.width;
    }
    if (key === photoAccessHelper.PhotoKeys.HEIGHT as string) {
      return this.height;
    }
    return 0;
  }
}

class ManagerLoaderStub {
  refreshCount: number = 0;
  destroyCount: number = 0;
  deleteBatches: PhotoModel[][] = [];
  recoverBatches: PhotoModel[][] = [];

  init(context: common.UIAbilityContext): void {
  }

  destroy(): void {
    this.destroyCount++;
  }

  registerChangeCallback(callback: (photos: PhotoModel[], albumAllPhoto: AlbumModel) => void): void {
  }

  unRegisterChangeCallback(callback: (photos: PhotoModel[], albumAllPhoto: AlbumModel) => void): void {
  }

  async delete(photos: PhotoModel[]): Promise<void> {
    this.deleteBatches.push([...photos]);
  }

  refresh(): void {
    this.refreshCount++;
  }

  async recover(photos: PhotoModel[]): Promise<void> {
    this.recoverBatches.push([...photos]);
  }
}

function resetPhotoManagerState(): void {
  photoManager.loadRecord = new Map();
  photoManager.inited = false;
  photoManager.context = undefined;
}

export default function localMediaLoaderTest() {
  describe('LocalMediaLoaderTest', () => {
    beforeEach(() => {
      resetPhotoManagerState();
    });

    afterEach(() => {
      resetPhotoManagerState();
    });

    {
      it('should compare file models by uri and order', 0, () => {
        const left = TestDataFactory.createPhotoList(3);
        const right = TestDataFactory.createPhotoList(3);
        expect(fileModelsEquals(left, right)).assertTrue();
        right.reverse();
        expect(fileModelsEquals(left, right)).assertFalse();
      });

      it('should treat different model lengths as different collections', 0, () => {
        const left = TestDataFactory.createPhotoList(2);
        const right = TestDataFactory.createPhotoList(3);
        expect(fileModelsEquals(left, right)).assertFalse();
      });

      it('should expose loader metadata for all local album loaders', 0, () => {
        const allLoader = new AllPhotoLoader();
        const favoriteLoader = new FavoritePhotoLoader();
        const screenShotLoader = new ScreenShotPhotoLoader();
        const trashLoader = new TrashPhotoLoader();

        expect(allLoader.getTag()).assertEqual('PHOTOM_AllPhotoLoader');
        expect(favoriteLoader.getTag()).assertEqual('PHOTOM_FavoritePhotoLoader');
        expect(screenShotLoader.getTag()).assertEqual('PHOTOM_ScreenShotPhotoLoader');
        expect(trashLoader.getTag()).assertEqual('PHOTOM_TrashPhotoLoader');

        expect(allLoader.getAlbumModel().type).assertEqual(AlbumType.ALL);
        expect(favoriteLoader.getAlbumModel().type).assertEqual(AlbumType.FAVORITE);
        expect(screenShotLoader.getAlbumModel().type).assertEqual(AlbumType.SCREENSHOT);
        expect(trashLoader.getAlbumModel().type).assertEqual(AlbumType.TRASH);
      });

      it('should expose subtype mapping for favorite screenshot and trash loaders', 0, () => {
        const favoriteLoader = new FavoritePhotoLoader();
        const screenShotLoader = new ScreenShotPhotoLoader();
        const trashLoader = new TrashPhotoLoader();

        expect(favoriteLoader.getSubType()).assertEqual(photoAccessHelper.AlbumSubtype.FAVORITE);
        expect(screenShotLoader.getSubType()).assertEqual(photoAccessHelper.AlbumSubtype.SCREENSHOT);
        expect(trashLoader.getSubType()).assertEqual(photoAccessHelper.AlbumSubtype.TRASH);
      });

      it('should resolve waitFor after requested delay window', 0, async () => {
        const allLoader = new AllPhotoLoader();
        const start = Date.now();
        await allLoader.waitFor(20);
        expect(Date.now() - start >= 15).assertTrue();
      });
    }

    {
      it('should initialize stub loader with context and refresh snapshot', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_init');
        loader.mediaItems = TestDataFactory.createPhotoList(2);

        // 初始化阶段立即触发一次 refresh。
        // 这保证真正页面注册回调前，loader 已经拥有首帧数据快照。
        loader.init({} as common.UIAbilityContext);
        await loader.waitForDelay(30);

        expect(loader.context !== undefined).assertTrue();
        expect(loader.refreshFetchCount).assertEqual(1);
        expect(loader.changeSnapshots.length).assertEqual(1);
        TestAsserts.assertPhotoOrder(loader.fileAssetsCopy(), [
          'file://media/0',
          'file://media/1'
        ]);
      });

      it('should notify registered callback with delayed snapshot', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_callback');
        loader.mediaItems = TestDataFactory.createPhotoList(3);
        await loader.refreshData(loader.mediaItems, true);

        let callbackCount = 0;
        let latestUris: string[] = [];
        loader.registerChangeCallback((photos) => {
          callbackCount++;
          latestUris = photos.map((item) => item.uri);
        });

        await loader.waitForDelay(260);
        expect(callbackCount).assertEqual(1);
        TestAsserts.assertPhotoOrder(loader.fileAssetsCopy(), latestUris);
      });

      it('should stop callback delivery after unregister', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_unregister');
        loader.mediaItems = TestDataFactory.createPhotoList(2);
        await loader.refreshData(loader.mediaItems, true);

        let callbackCount = 0;
        const callback = (photos: PhotoModel[]) => {
          callbackCount++;
        };
        loader.registerChangeCallback(callback);
        loader.unRegisterChangeCallback(callback);

        // 这里主动推动一次数据变化。
        // 如果注销失败，回调会在后续刷新中继续泄漏并导致场景测试串扰。
        await loader.refreshData(TestDataFactory.createPhotoList(3), true);
        await loader.waitForDelay(260);
        expect(callbackCount).assertEqual(0);
      });

      it('should cancel delayed bootstrap callback when listener unregisters immediately', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_unregister_immediately');
        loader.mediaItems = TestDataFactory.createPhotoList(2);

        let callbackCount = 0;
        const callback = (photos: PhotoModel[]) => {
          callbackCount += photos.length;
        };
        loader.registerChangeCallback(callback);
        loader.unRegisterChangeCallback(callback);

        await loader.waitForDelay(260);
        expect(callbackCount).assertEqual(0);
      });

      it('should avoid duplicate change notification for identical snapshot when not forced', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_identical');
        const photos = TestDataFactory.createPhotoList(3);
        await loader.refreshData(photos, true);
        const changeCount = loader.changeSnapshots.length;
        await loader.refreshData(TestDataFactory.createPhotoList(3), false);
        expect(loader.changeSnapshots.length).assertEqual(changeCount);
      });

      it('should force change notification when caller requests refreshData force mode', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_force');
        const photos = TestDataFactory.createPhotoList(3);
        await loader.refreshData(photos, true);
        const changeCount = loader.changeSnapshots.length;
        await loader.refreshData(TestDataFactory.createPhotoList(3), true);
        expect(loader.changeSnapshots.length).assertEqual(changeCount + 1);
      });

      it('should reuse old model instances when uri matches during refreshData', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_reuse');
        const originalPhotos = TestDataFactory.createPhotoList(2);
        originalPhotos[0].photoTag = 'old-tag';
        await loader.refreshData(originalPhotos, true);

        const updatedPhotos = TestDataFactory.createPhotoList(2);
        updatedPhotos[0].photoTag = 'new-tag';
        await loader.refreshData(updatedPhotos, false);

        expect(loader.fileAssetsCopy()[0].photoTag).assertEqual('old-tag');
      });

      it('should delete photos and shrink local snapshot', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_delete');
        const photos = TestDataFactory.createPhotoList(4);
        await loader.refreshData(photos, true);
        await loader.delete([photos[1], photos[3]]);

        expect(loader.deletedBatches.length).assertEqual(1);
        expect(loader.fileAssetsCopy().length).assertEqual(2);
        TestAsserts.assertDeletedUriCoverage(photos.map((item) => item.uri), [
          loader.deletedBatches[0][0].uri,
          loader.deletedBatches[0][1].uri
        ]);
      });

      it('should ignore delete targets missing from current snapshot', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_delete_unknown');
        const photos = TestDataFactory.createPhotoList(3);
        await loader.refreshData(photos, true);

        const unknownPhoto = TestDataFactory.createPhoto(99);
        unknownPhoto.uri = 'file://media/unknown';
        await loader.delete([unknownPhoto]);

        expect(loader.deletedBatches.length).assertEqual(1);
        expect(loader.fileAssetsCopy().length).assertEqual(3);
        TestAsserts.assertPhotoOrder(loader.fileAssetsCopy(), [
          'file://media/0',
          'file://media/1',
          'file://media/2'
        ]);
      });

      it('should recover trash photos and shrink trash snapshot', 0, async () => {
        const loader = new StubLoader(AlbumType.TRASH, 'stub_recover');
        const photos = TestDataFactory.createPhotoList(3);
        await loader.refreshData(photos, true);
        await loader.recover([photos[0]]);

        expect(loader.recoveredBatches.length).assertEqual(1);
        expect(loader.fileAssetsCopy().length).assertEqual(2);
        expect(loader.recoveredBatches[0][0].uri).assertEqual('file://media/0');
      });

      it('should ignore recover targets missing from trash snapshot', 0, async () => {
        const loader = new StubLoader(AlbumType.TRASH, 'stub_recover_unknown');
        const photos = TestDataFactory.createPhotoList(3);
        await loader.refreshData(photos, true);

        const unknownPhoto = TestDataFactory.createPhoto(77);
        unknownPhoto.uri = 'file://media/recover_unknown';
        await loader.recover([unknownPhoto]);

        expect(loader.recoveredBatches.length).assertEqual(1);
        expect(loader.fileAssetsCopy().length).assertEqual(3);
        TestAsserts.assertPhotoOrder(loader.fileAssetsCopy(), [
          'file://media/0',
          'file://media/1',
          'file://media/2'
        ]);
      });

      it('should keep refresh reentry serialized while first request is running', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_refresh_guard');
        loader.mediaItems = TestDataFactory.createPhotoList(2);
        loader.refreshDelayMs = 80;

        // 列表页、回收站页和首页都可能触发重复 refresh。
        // 此处锁住并发刷新，避免媒体库查询风暴和 UI 重复回调。
        const first = loader.refresh();
        const second = loader.refresh();
        await Promise.all([first, second]);

        expect(loader.refreshFetchCount).assertEqual(1);
        expect(loader.changeSnapshots.length).assertEqual(1);
      });

      it('should build full model fields from photo asset', 0, async () => {
        const loader = new StubLoader(AlbumType.ALL, 'stub_full_model');
        const photo = TestDataFactory.createPhoto(0);
        photo.photoAsset = new MockPhotoAssetRecord(
          photoAccessHelper.PhotoType.VIDEO,
          88,
          1234,
          5678,
          3840,
          2160
        ) as Object as photoAccessHelper.PhotoAsset;

        const result = await loader.createFullModel(photo);
        expect(result.photoType).assertEqual(photoAccessHelper.PhotoType.VIDEO);
        expect(result.duration).assertEqual(88);
        expect(result.dateAdded).assertEqual(1234);
        expect(result.dateTrashed).assertEqual(5678);
        expect(result.width).assertEqual(3840);
        expect(result.height).assertEqual(2160);
      });
    }

    {
      it('should return assigned loader from photo manager record', 0, () => {
        const loader = new ManagerLoaderStub();
        photoManager.loadRecord.set(AlbumType.ALL, loader);
        expect(photoManager.getLoader(AlbumType.ALL) === loader).assertTrue();
      });

      it('should refresh every registered loader through photo manager', 0, () => {
        const allLoader = new ManagerLoaderStub();
        const favoriteLoader = new ManagerLoaderStub();
        photoManager.loadRecord.set(AlbumType.ALL, allLoader);
        photoManager.loadRecord.set(AlbumType.FAVORITE, favoriteLoader);

        photoManager.refresh();
        expect(allLoader.refreshCount).assertEqual(1);
        expect(favoriteLoader.refreshCount).assertEqual(1);
      });

      it('should delete local album photos and refresh all loaders', 0, async () => {
        const photos = TestDataFactory.createPhotoList(2);
        const allLoader = new ManagerLoaderStub();
        const favoriteLoader = new ManagerLoaderStub();
        photoManager.loadRecord.set(AlbumType.ALL, allLoader);
        photoManager.loadRecord.set(AlbumType.FAVORITE, favoriteLoader);

        await photoManager.delete(AlbumType.FAVORITE, photos);

        expect(favoriteLoader.deleteBatches.length).assertEqual(1);
        expect(allLoader.refreshCount).assertEqual(1);
        expect(favoriteLoader.refreshCount).assertEqual(1);
      });

      it('should route trash deletion only to trash loader', 0, async () => {
        const trashLoader = new ManagerLoaderStub();
        const allLoader = new ManagerLoaderStub();
        photoManager.loadRecord.set(AlbumType.TRASH, trashLoader);
        photoManager.loadRecord.set(AlbumType.ALL, allLoader);

        await photoManager.delete(AlbumType.TRASH, TestDataFactory.createPhotoList(1));

        expect(trashLoader.deleteBatches.length).assertEqual(1);
        expect(allLoader.refreshCount).assertEqual(0);
      });

      it('should recover trash via trash loader and then refresh manager', 0, async () => {
        const trashLoader = new ManagerLoaderStub();
        const allLoader = new ManagerLoaderStub();
        photoManager.loadRecord.set(AlbumType.TRASH, trashLoader);
        photoManager.loadRecord.set(AlbumType.ALL, allLoader);

        await photoManager.recoverTrash(TestDataFactory.createPhotoList(2));

        expect(trashLoader.recoverBatches.length).assertEqual(1);
        expect(trashLoader.refreshCount).assertEqual(1);
        expect(allLoader.refreshCount).assertEqual(1);
      });

      it('should destroy every loader on manager dispose', 0, () => {
        const allLoader = new ManagerLoaderStub();
        const favoriteLoader = new ManagerLoaderStub();
        photoManager.loadRecord.set(AlbumType.ALL, allLoader);
        photoManager.loadRecord.set(AlbumType.FAVORITE, favoriteLoader);

        photoManager.destroy();
        expect(allLoader.destroyCount).assertEqual(1);
        expect(favoriteLoader.destroyCount).assertEqual(1);
      });
    }
  });
}
