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

import { describe, expect, it } from '@ohos/hypium';
import { Constants } from '../../../main/ets/common/Constants';
import { Util } from '../../../main/ets/common/Util';
import { PhotoDataSource } from '../../../main/ets/models/IDataSource';
import { PhotoModel } from '../../../main/ets/models/PhotoModel';
import { TestAsserts } from './base/TestAsserts';
import { TestDataFactory } from './base/TestDataFactory';
import { MockFocusController, MockPhotoRepository } from './base/TestDoubles';

class MockVideoController {
  private startCount: number = 0;
  private pauseCount: number = 0;

  start(): void {
    this.startCount++;
  }

  pause(): void {
    this.pauseCount++;
  }

  getStartCount(): number {
    return this.startCount;
  }

  getPauseCount(): number {
    return this.pauseCount;
  }
}

class TrashPageHarness {
  photoList: PhotoDataSource = new PhotoDataSource();
  pictureChooseFlags: boolean[] = [];
  isPhotoSelecting: boolean = false;
  isCheckAll: boolean = false;
  isShowMenu: boolean = false;
  isShowDeleteDialog: boolean = false;
  deleteIndex: number = 1;
  menuIndex: number = 0;
  focusPhotoStr: string = 'picture0';
  focusDialogStr: string = '';
  menuList: string[] = ['choose', 'clear_all'];
  private focusController: MockFocusController;
  private repository: MockPhotoRepository;

  constructor(photos: PhotoModel[], repository?: MockPhotoRepository, focusController?: MockFocusController) {
    this.photoList.setData(photos);
    this.pictureChooseFlags = new Array(photos.length).fill(false);
    this.repository = repository ?? new MockPhotoRepository();
    this.repository.setPhotos(photos);
    this.focusController = focusController ?? new MockFocusController();
    this.focusController.allow([
      'picture0',
      'picture1',
      'picture2',
      'photo_menu0',
      'photo_menu1',
      'photo_menu2',
      'delete0',
      'delete1'
    ]);
  }

  openMenu(): void {
    if (this.isShowMenu) {
      return;
    }
    if (this.isPhotoSelecting && this.isCheckAll) {
      this.menuList = ['restore', 'delete', 'cancel_all_select'];
    } else if (this.isPhotoSelecting) {
      this.menuList = ['restore', 'delete', 'select_all'];
    } else {
      this.menuList = ['choose', 'clear_all'];
    }
    this.isShowMenu = true;
    this.menuIndex = 0;
    this.clickFocusBtn('photo_menu0', true);
  }

  clickFocusBtn(id: string, inDialog: boolean): boolean {
    const success = this.focusController.requestFocus(id);
    if (!success) {
      return false;
    }
    if (inDialog) {
      this.focusDialogStr = id;
    } else {
      this.focusPhotoStr = id;
    }
    return true;
  }

  onBackPress(): boolean {
    if (this.isShowDeleteDialog) {
      this.dismissDeleteDialog();
      return true;
    }
    if (this.isShowMenu) {
      this.dismissMenu();
      return true;
    }
    if (this.isPhotoSelecting) {
      this.cancelPhotoSelect();
      return true;
    }
    return false;
  }

  cancelPhotoSelect(): void {
    this.isPhotoSelecting = false;
    this.pictureChooseFlags = new Array(this.photoList.totalCount()).fill(false);
    this.isCheckAll = false;
  }

  dismissMenu(): void {
    this.isShowMenu = false;
    this.clickFocusBtn(this.focusPhotoStr, false);
  }

  dismissDeleteDialog(): void {
    this.isShowDeleteDialog = false;
    this.deleteIndex = 1;
    this.menuIndex = 0;
    this.clickFocusBtn('photo_menu0', true);
  }

  selectPhoto(index: number): void {
    this.pictureChooseFlags[index] = !this.pictureChooseFlags[index];
    const count = this.pictureChooseFlags.filter((item) => item).length;
    this.isCheckAll = count === this.photoList.totalCount();
  }

  selectAll(): void {
    this.pictureChooseFlags = new Array(this.photoList.totalCount()).fill(true);
    this.isCheckAll = true;
  }

  getSelectedPhotos(): PhotoModel[] {
    const selected: PhotoModel[] = [];
    this.pictureChooseFlags.forEach((value, index) => {
      if (value) {
        selected.push(this.photoList.getData(index) as PhotoModel);
      }
    });
    return selected;
  }

  async restorePhotos(): Promise<void> {
    const selected = this.getSelectedPhotos();
    if (selected.length === 0) {
      return;
    }
    this.repository.restorePhotos(selected);
    this.cancelPhotoSelect();
    this.dismissMenu();
  }

  async deletePhotos(): Promise<void> {
    const selected = this.getSelectedPhotos();
    if (selected.length === 0) {
      return;
    }
    this.repository.deletePhotos(selected);
    this.cancelPhotoSelect();
    this.isShowMenu = false;
    this.isShowDeleteDialog = false;
    this.deleteIndex = 1;
    this.clickFocusBtn('picture0', false);
  }

  clearAllPhotos(): void {
    this.repository.deletePhotos(this.photoList.getAllData() as PhotoModel[]);
    this.isShowMenu = false;
  }

  getRepository(): MockPhotoRepository {
    return this.repository;
  }

  getFocusHistory(): string[] {
    return this.focusController.getFocusHistory().map((item) => item.focusId);
  }
}

class WatchPageHarness {
  focusStr: string = 'watchFocus';
  isVideo: boolean = false;
  isTransfer: boolean = true;
  rotateValue: number = 0;
  rotateLandScape: boolean = true;
  isShowMenu: boolean = false;
  selectPhotoModel?: PhotoModel = undefined;
  photoList: PhotoModel[] = [];
  photoIndex: number = 0;
  directType?: string = undefined;
  directUri?: string = undefined;
  photoUri: string = '';
  transferIndex: number = -1;
  transferPhotoList: PhotoModel[] = [];
  imageContainerWidth: string = '100%';
  imageContainerHeight: string = '100%';
  private focusController: MockFocusController;
  private controllers: MockVideoController;

  constructor(photos: PhotoModel[], focusController?: MockFocusController, controllers?: MockVideoController) {
    this.photoList = photos;
    this.selectPhotoModel = photos[0];
    this.photoUri = photos[0]?.uri ?? '';
    this.focusController = focusController ?? new MockFocusController();
    this.controllers = controllers ?? new MockVideoController();
    this.focusController.allow(['watchFocus', 'photo_menu_0']);
  }

  clickFocusBtn(id: string): void {
    this.focusStr = id;
    this.focusController.requestFocus(id);
  }

  clickRotateBtn(): void {
    this.rotateValue += Constants.ANGLE_90;
    this.rotateLandScape = this.rotateValue % Constants.ANGLE_180 === 0;
  }

  recoverRotateBtn(): void {
    this.rotateValue = 0;
    this.rotateLandScape = true;
  }

  canOpenRotateMenu(): boolean {
    if (!this.isTransfer) {
      return this.directType !== 'video';
    }
    return !!this.selectPhotoModel && this.selectPhotoModel.photoType === Constants.PHOTO_TYPE_IMAGE;
  }

  openRotateMenu(): void {
    if (!this.canOpenRotateMenu()) {
      return;
    }
    this.isShowMenu = true;
    this.clickFocusBtn('photo_menu_0');
  }

  onBackPress(): boolean {
    if (this.isShowMenu) {
      this.isShowMenu = false;
      this.clickFocusBtn('watchFocus');
      return true;
    }
    return false;
  }

  getImageWidth(landscape: boolean): string {
    return landscape ? this.imageContainerWidth : this.imageContainerHeight;
  }

  getImageHeight(landscape: boolean): string {
    return landscape ? this.imageContainerHeight : this.imageContainerWidth;
  }

  is4K(image: PhotoModel): boolean {
    return (image.width ?? 0) >= 3840;
  }

  goPrev(): string {
    if (!this.isTransfer) {
      if ((this.transferIndex === 0 && this.directUri === this.photoUri) || this.transferIndex === -1) {
        this.transferIndex = -1;
        return 'first_photo';
      }
      if (this.transferPhotoList.length > 0) {
        if (this.transferIndex === 0) {
          this.directUri = this.photoUri;
          return 'reset_origin';
        }
        this.transferIndex--;
        this.directUri = this.transferPhotoList[this.transferIndex].uri;
        return 'transfer_prev';
      }
      return 'empty_transfer';
    }
    if (this.photoIndex === 0) {
      return 'first_photo';
    }
    this.isVideo = false;
    this.controllers.pause();
    this.photoIndex--;
    this.selectPhotoModel = this.photoList[this.photoIndex];
    this.clickFocusBtn('watchFocus');
    return 'prev';
  }

  goNext(): string {
    if (!this.isTransfer) {
      if (this.transferPhotoList.length > 0) {
        if (this.transferIndex === this.transferPhotoList.length - 1) {
          return 'first_photo';
        }
        this.transferIndex++;
        this.directUri = this.transferPhotoList[this.transferIndex].uri;
        return 'transfer_next';
      }
      return 'empty_transfer';
    }
    if (this.photoList.length - 1 === this.photoIndex) {
      return 'last_photo';
    }
    this.isVideo = false;
    this.controllers.pause();
    this.photoIndex++;
    this.selectPhotoModel = this.photoList[this.photoIndex];
    this.clickFocusBtn('watchFocus');
    return 'next';
  }

  toggleVideoPlayback(): void {
    if (!this.selectPhotoModel || this.selectPhotoModel.photoType !== Constants.PHOTO_TYPE_VIDEO) {
      return;
    }
    if (this.isVideo) {
      this.controllers.pause();
      this.isVideo = false;
      return;
    }
    this.controllers.start();
    this.isVideo = true;
  }

  getFocusHistory(): string[] {
    return this.focusController.getFocusHistory().map((item) => item.focusId);
  }

  getController(): MockVideoController {
    return this.controllers;
  }
}

function createTrashPhotos(count: number): PhotoModel[] {
  return TestDataFactory.createPhotoList(count, {
    namePrefix: 'TRASH',
    width: 1920,
    height: 1080,
    type: Constants.PHOTO_TYPE_IMAGE
  });
}

function createWatchPhotos(): PhotoModel[] {
  return [
    TestDataFactory.createPhoto(0, undefined, {
      namePrefix: 'WATCH',
      width: 1920,
      height: 1080,
      type: Constants.PHOTO_TYPE_IMAGE
    }),
    TestDataFactory.createPhoto(1, undefined, {
      namePrefix: 'WATCH',
      width: 3840,
      height: 2160,
      type: Constants.PHOTO_TYPE_IMAGE
    }),
    TestDataFactory.createPhoto(2, undefined, {
      namePrefix: 'WATCH_VIDEO',
      duration: 65_000,
      type: Constants.PHOTO_TYPE_VIDEO
    })
  ];
}

export default function trashAndWatchInteractionTest() {
  describe('TrashAndWatchInteractionTest', () => {
    {
      it('should open trash primary menu in browse mode', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.openMenu();

        expect(harness.isShowMenu).assertTrue();
        expect(harness.menuList.length).assertEqual(2);
        expect(harness.menuList[0]).assertEqual('choose');
        expect(harness.focusDialogStr).assertEqual('photo_menu0');
      });

      it('should open trash secondary menu in partial select mode', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.isPhotoSelecting = true;
        harness.selectPhoto(0);
        harness.openMenu();

        expect(harness.menuList[0]).assertEqual('restore');
        expect(harness.menuList[2]).assertEqual('select_all');
      });

      it('should open cancel-all menu when every trash photo is selected', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.isPhotoSelecting = true;
        harness.selectAll();
        harness.openMenu();

        expect(harness.isCheckAll).assertTrue();
        expect(harness.menuList[2]).assertEqual('cancel_all_select');
      });

      it('should keep current trash menu state when menu is already visible', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.openMenu();
        harness.menuIndex = 1;

        harness.openMenu();

        expect(harness.isShowMenu).assertTrue();
        expect(harness.menuIndex).assertEqual(1);
        expect(harness.focusDialogStr).assertEqual('photo_menu0');
      });

      it('should toggle selection flags and derive selected photos', 0, () => {
        const photos = createTrashPhotos(4);
        const harness = new TrashPageHarness(photos);
        harness.selectPhoto(1);
        harness.selectPhoto(3);
        const selected = harness.getSelectedPhotos();

        expect(selected.length).assertEqual(2);
        TestAsserts.assertDeletedUriCoverage(photos.map((item) => item.uri), selected.map((item) => item.uri));
      });

      it('should recompute select-all state when a selected trash tile is toggled off', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.selectAll();

        harness.selectPhoto(1);

        expect(harness.pictureChooseFlags[1]).assertFalse();
        expect(harness.isCheckAll).assertFalse();
      });

      it('should cancel selection state when back is pressed in edit mode', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.isPhotoSelecting = true;
        harness.selectPhoto(0);
        const handled = harness.onBackPress();

        expect(handled).assertTrue();
        expect(harness.isPhotoSelecting).assertFalse();
        expect(harness.isCheckAll).assertFalse();
        expect(harness.pictureChooseFlags.includes(true)).assertFalse();
      });

      it('should report unhandled back press when trash page is already in browse mode', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(2));

        expect(harness.onBackPress()).assertFalse();
      });

      it('should dismiss trash menu before leaving page', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.openMenu();
        const handled = harness.onBackPress();

        expect(handled).assertTrue();
        expect(harness.isShowMenu).assertFalse();
        expect(harness.getFocusHistory()[harness.getFocusHistory().length - 1]).assertEqual('picture0');
      });

      it('should dismiss delete dialog and recover menu focus', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.openMenu();
        harness.isShowDeleteDialog = true;
        const handled = harness.onBackPress();

        expect(handled).assertTrue();
        expect(harness.isShowDeleteDialog).assertFalse();
        expect(harness.deleteIndex).assertEqual(1);
        expect(harness.focusDialogStr).assertEqual('photo_menu0');
      });

      it('should clear menu state and selection flags when cancelPhotoSelect is called directly', 0, () => {
        const harness = new TrashPageHarness(createTrashPhotos(3));
        harness.isPhotoSelecting = true;
        harness.selectAll();

        harness.cancelPhotoSelect();

        expect(harness.isPhotoSelecting).assertFalse();
        expect(harness.isCheckAll).assertFalse();
        expect(harness.pictureChooseFlags.every((item) => !item)).assertTrue();
      });

      it('should ignore restore request when no trash photo is selected', 0, async () => {
        const repository = new MockPhotoRepository();
        const harness = new TrashPageHarness(createTrashPhotos(3), repository);
        harness.isPhotoSelecting = true;
        harness.openMenu();

        await harness.restorePhotos();

        expect(repository.getRestoredUris().length).assertEqual(0);
        expect(harness.isPhotoSelecting).assertTrue();
        expect(harness.isShowMenu).assertTrue();
      });

      it('should restore selected trash photos through repository contract', 0, async () => {
        const repository = new MockPhotoRepository();
        const photos = createTrashPhotos(3);
        const harness = new TrashPageHarness(photos, repository);
        harness.isPhotoSelecting = true;
        harness.openMenu();
        harness.selectPhoto(0);
        harness.selectPhoto(2);
        await harness.restorePhotos();

        const restoredUris = repository.getRestoredUris();
        expect(restoredUris.length).assertEqual(2);
        TestAsserts.assertDeletedUriCoverage(photos.map((item) => item.uri), restoredUris);
        expect(harness.isPhotoSelecting).assertFalse();
        expect(harness.isShowMenu).assertFalse();
      });

      it('should ignore delete request when no trash photo is selected', 0, async () => {
        const repository = new MockPhotoRepository();
        const harness = new TrashPageHarness(createTrashPhotos(2), repository);
        harness.isPhotoSelecting = true;
        harness.openMenu();
        harness.isShowDeleteDialog = true;

        await harness.deletePhotos();

        expect(repository.getDeletedUris().length).assertEqual(0);
        expect(harness.isShowDeleteDialog).assertTrue();
        expect(harness.isShowMenu).assertTrue();
      });

      it('should delete selected trash photos and reset focus to first tile', 0, async () => {
        const repository = new MockPhotoRepository();
        const photos = createTrashPhotos(4);
        const harness = new TrashPageHarness(photos, repository);
        harness.isPhotoSelecting = true;
        harness.openMenu();
        harness.isShowDeleteDialog = true;
        harness.selectPhoto(1);
        harness.selectPhoto(2);
        await harness.deletePhotos();

        expect(repository.getDeletedUris().length).assertEqual(2);
        expect(harness.isShowDeleteDialog).assertFalse();
        expect(harness.isShowMenu).assertFalse();
        expect(harness.focusPhotoStr).assertEqual('picture0');
      });

      it('should clear all trash photos from browse mode menu action', 0, () => {
        const repository = new MockPhotoRepository();
        const photos = createTrashPhotos(3);
        const harness = new TrashPageHarness(photos, repository);
        harness.openMenu();
        harness.clearAllPhotos();

        expect(repository.getDeletedUris().length).assertEqual(3);
        expect(harness.isShowMenu).assertFalse();
      });

      it('should expose repository instance for downstream assertions', 0, () => {
        const repository = new MockPhotoRepository();
        const harness = new TrashPageHarness(createTrashPhotos(1), repository);

        expect(harness.getRepository()).assertEqual(repository);
      });

      it('should format video duration for trash thumbnail overlays', 0, () => {
        expect(Util.getFormattedDuration(500)).assertEqual('00:01');
        expect(Util.getFormattedDuration(65_000)).assertEqual('01:05');
        expect(Util.getFormattedDuration(3_661_000)).assertEqual('1:01:01');
      });
    }

    {
      it('should rotate image in ninety-degree steps and recover landscape flag', 0, () => {
        const harness = new WatchPageHarness(createWatchPhotos());
        harness.clickRotateBtn();
        harness.clickRotateBtn();
        harness.clickRotateBtn();

        expect(harness.rotateValue).assertEqual(270);
        expect(harness.rotateLandScape).assertFalse();

        harness.recoverRotateBtn();
        expect(harness.rotateValue).assertEqual(0);
        expect(harness.rotateLandScape).assertTrue();
      });

      it('should allow rotate menu only for images in transfer mode', 0, () => {
        const photos = createWatchPhotos();
        const harness = new WatchPageHarness(photos);
        harness.selectPhotoModel = photos[0];
        expect(harness.canOpenRotateMenu()).assertTrue();

        harness.selectPhotoModel = photos[2];
        expect(harness.canOpenRotateMenu()).assertFalse();
      });

      it('should block rotate menu for direct video playback', 0, () => {
        const harness = new WatchPageHarness(createWatchPhotos());
        harness.isTransfer = false;
        harness.directType = 'video';
        harness.openRotateMenu();

        expect(harness.isShowMenu).assertFalse();
        expect(harness.focusStr).assertEqual('watchFocus');
      });

      it('should allow rotate menu for direct image preview in non-transfer mode', 0, () => {
        const harness = new WatchPageHarness(createWatchPhotos());
        harness.isTransfer = false;
        harness.directType = 'image';

        harness.openRotateMenu();

        expect(harness.isShowMenu).assertTrue();
        expect(harness.focusStr).assertEqual('photo_menu_0');
      });

      it('should open rotate menu and return focus on back press', 0, () => {
        const harness = new WatchPageHarness(createWatchPhotos());
        harness.openRotateMenu();
        const handled = harness.onBackPress();

        expect(harness.isShowMenu).assertTrue();
        expect(handled).assertTrue();
        expect(harness.isShowMenu).assertFalse();
        const focusHistory = harness.getFocusHistory();
        expect(focusHistory[0]).assertEqual('photo_menu_0');
        expect(focusHistory[1]).assertEqual('watchFocus');
      });

      it('should ignore back press when rotate menu is not visible', 0, () => {
        const harness = new WatchPageHarness(createWatchPhotos());

        expect(harness.onBackPress()).assertFalse();
        expect(harness.focusStr).assertEqual('watchFocus');
      });

      it('should swap image container width and height after portrait rotation', 0, () => {
        const harness = new WatchPageHarness(createWatchPhotos());
        expect(harness.getImageWidth(true)).assertEqual('100%');
        expect(harness.getImageHeight(true)).assertEqual('100%');

        harness.imageContainerWidth = '80%';
        harness.imageContainerHeight = '60%';
        expect(harness.getImageWidth(false)).assertEqual('60%');
        expect(harness.getImageHeight(false)).assertEqual('80%');
      });

      it('should detect 4k media by width threshold', 0, () => {
        const photos = createWatchPhotos();
        const harness = new WatchPageHarness(photos);

        expect(harness.is4K(photos[0])).assertFalse();
        expect(harness.is4K(photos[1])).assertTrue();
      });

      it('should treat sub-4k width as non-4k even with tall height', 0, () => {
        const harness = new WatchPageHarness(createWatchPhotos());
        const portraitImage = TestDataFactory.createPhoto(9, undefined, {
          namePrefix: 'PORTRAIT',
          width: 2160,
          height: 4096,
          type: Constants.PHOTO_TYPE_IMAGE
        });

        expect(harness.is4K(portraitImage)).assertFalse();
      });

      it('should move to previous and next image in transfer gallery mode', 0, () => {
        const photos = createWatchPhotos();
        const harness = new WatchPageHarness(photos);
        harness.photoIndex = 1;
        harness.selectPhotoModel = photos[1];

        expect(harness.goPrev()).assertEqual('prev');
        expect(harness.photoIndex).assertEqual(0);
        expect(harness.goNext()).assertEqual('next');
        expect(harness.photoIndex).assertEqual(1);
      });

      it('should pause video controller when navigating between transfer gallery items', 0, () => {
        const photos = createWatchPhotos();
        const controller = new MockVideoController();
        const harness = new WatchPageHarness(photos, undefined, controller);
        harness.photoIndex = 1;
        harness.selectPhotoModel = photos[1];
        harness.isVideo = true;

        harness.goPrev();
        harness.goNext();

        expect(controller.getPauseCount()).assertEqual(2);
        expect(harness.focusStr).assertEqual('watchFocus');
      });

      it('should stop at first and last image boundaries', 0, () => {
        const photos = createWatchPhotos();
        const harness = new WatchPageHarness(photos);

        expect(harness.goPrev()).assertEqual('first_photo');
        harness.photoIndex = photos.length - 1;
        harness.selectPhotoModel = photos[photos.length - 1];
        expect(harness.goNext()).assertEqual('last_photo');
      });

      it('should surface empty transfer state when direct preview has no transfer list', 0, () => {
        const photos = createWatchPhotos();
        const harness = new WatchPageHarness(photos);
        harness.isTransfer = false;
        harness.directType = 'image';
        harness.directUri = photos[0].uri;
        harness.photoUri = photos[0].uri;
        harness.transferIndex = 0;
        harness.transferPhotoList = [];

        expect(harness.goNext()).assertEqual('empty_transfer');
        expect(harness.goPrev()).assertEqual('first_photo');
      });

      it('should move across transfer list when opened through direct uri flow', 0, () => {
        const photos = createWatchPhotos();
        const harness = new WatchPageHarness(photos);
        harness.isTransfer = false;
        harness.directType = 'image';
        harness.directUri = photos[0].uri;
        harness.photoUri = photos[0].uri;
        harness.transferPhotoList = photos.slice(1);
        harness.transferIndex = 0;

        expect(harness.goNext()).assertEqual('transfer_next');
        expect(harness.directUri).assertEqual(photos[2].uri);
        expect(harness.goPrev()).assertEqual('reset_origin');
        expect(harness.directUri).assertEqual(photos[0].uri);
      });

      it('should move to previous transfer photo when direct preview is beyond the first transfer item', 0, () => {
        const photos = createWatchPhotos();
        const harness = new WatchPageHarness(photos);
        harness.isTransfer = false;
        harness.directType = 'image';
        harness.photoUri = photos[0].uri;
        harness.transferPhotoList = photos.slice(1);
        harness.transferIndex = 1;
        harness.directUri = photos[2].uri;

        expect(harness.goPrev()).assertEqual('transfer_prev');
        expect(harness.transferIndex).assertEqual(0);
        expect(harness.directUri).assertEqual(photos[1].uri);
      });

      it('should stop transfer navigation at the last transfer item', 0, () => {
        const photos = createWatchPhotos();
        const harness = new WatchPageHarness(photos);
        harness.isTransfer = false;
        harness.directType = 'image';
        harness.transferPhotoList = photos.slice(1);
        harness.transferIndex = harness.transferPhotoList.length - 1;
        harness.directUri = photos[2].uri;

        expect(harness.goNext()).assertEqual('first_photo');
        expect(harness.transferIndex).assertEqual(1);
      });

      it('should toggle video controller state for watch playback interactions', 0, () => {
        const photos = createWatchPhotos();
        const controller = new MockVideoController();
        const harness = new WatchPageHarness(photos, undefined, controller);
        harness.selectPhotoModel = photos[2];

        harness.toggleVideoPlayback();
        harness.toggleVideoPlayback();

        expect(controller.getStartCount()).assertEqual(1);
        expect(controller.getPauseCount()).assertEqual(1);
        expect(harness.isVideo).assertFalse();
      });

      it('should ignore playback toggle for image media and keep controller idle', 0, () => {
        const photos = createWatchPhotos();
        const controller = new MockVideoController();
        const harness = new WatchPageHarness(photos, undefined, controller);
        harness.selectPhotoModel = photos[0];

        harness.toggleVideoPlayback();

        expect(controller.getStartCount()).assertEqual(0);
        expect(controller.getPauseCount()).assertEqual(0);
        expect(harness.isVideo).assertFalse();
      });

      it('should expose underlying video controller for assertions', 0, () => {
        const controller = new MockVideoController();
        const harness = new WatchPageHarness(createWatchPhotos(), undefined, controller);

        expect(harness.getController()).assertEqual(controller);
      });
    }
  });
}
