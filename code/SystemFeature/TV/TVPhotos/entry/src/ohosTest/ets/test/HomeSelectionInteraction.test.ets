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
import { PhotoGroupDataSource } from '../../../main/ets/models/IDataSource';
import { DialogModel, PhotoGroupModel, PhotoModel, PhotoPosition } from '../../../main/ets/models/PhotoModel';
import { PhotoPositionUtils } from '../../../main/ets/common/PhotoPositionUtils';
import { TestAsserts } from './base/TestAsserts';
import { TestDataFactory } from './base/TestDataFactory';
import { MockFocusController } from './base/TestDoubles';

class MockDeleteService {
  shouldFail: boolean = false;
  deletedBatches: PhotoModel[][] = [];

  async delete(photos: PhotoModel[]): Promise<void> {
    if (this.shouldFail) {
      throw new Error('delete failed');
    }
    this.deletedBatches.push([...photos]);
  }
}

interface DialogState {
  uri: string;
  name: string;
}

class HomeSelectionHarness {
  photoGroupList: PhotoGroupDataSource = new PhotoGroupDataSource();
  allPhotos: PhotoModel[] = [];
  selectedUriList: PhotoModel[] = [];
  dialogList: DialogState[] = [
    { uri: 'app.media.p_del_disabled', name: '删除' },
    { uri: 'app.media.p_share_disabled', name: '分享' },
    { uri: 'app.media.p_check_default', name: '选择' }
  ];
  dialogFlag: boolean = false;
  deleteFlag: boolean = false;
  deviceFlag: boolean = false;
  receiveFlag: boolean = false;
  showToDfsDialog: boolean = false;
  isSelecting: boolean = false;
  isCheckAll: boolean = false;
  chooseIndex: number = 0;
  focusStr: string = 'menu0';
  dialogFocusStr: string = '';
  currentPhotoPosition?: PhotoPosition = undefined;
  deleteIndex: number = 1;
  deviceIndex: number = 1;
  receiveIndex: number = 1;
  dialogIndex: number = 2;
  photoReloadCount: number = 0;
  routeHistory: string[] = [];
  videoLaunchHistory: string[] = [];
  toastHistory: string[] = [];
  terminated: boolean = false;
  scrollHistory: number[] = [];
  private focusController: MockFocusController;
  private deleteService: MockDeleteService;

  constructor(groups: PhotoGroupModel[], deleteService?: MockDeleteService, focusController?: MockFocusController) {
    this.photoGroupList.setData(groups);
    this.allPhotos = groups.flatMap((group) => group.photoList);
    this.deleteService = deleteService ?? new MockDeleteService();
    this.focusController = focusController ?? new MockFocusController();
    this.focusController.allow([
      'menu0',
      'menu1',
      'dialog0',
      'dialog1',
      'dialog2',
      'delete0',
      'delete1',
      'receive1',
      'photo_0_0',
      'photo_0_1',
      'photo_0_2',
      'photo_0_3',
      'photo_0_4',
      'photo_1_0',
      'photo_1_1',
      'photo_1_2',
      'photo_1_3',
      'photo_2_0',
      'photo_2_1',
      'photo_2_2',
      'photo_2_3'
    ]);
  }

  selectedAll(isSelectedAll: boolean): void {
    this.photoGroupList.getAllData().forEach((dateItem: PhotoGroupModel) => {
      dateItem.photoList.forEach((item: PhotoModel) => {
        if (isSelectedAll) {
          if (this.selectedUriList.indexOf(item) < 0) {
            this.selectedUriList.push(item);
          }
        } else {
          this.selectedUriList = [];
        }
      });
    });
    this.isCheckAll = isSelectedAll;
  }

  getDialogBack(): void {
    this.dialogFlag = false;
    let computeFocusStr = this.focusStr;
    if (this.focusStr.startsWith('photo') && this.currentPhotoPosition !== undefined) {
      const index = PhotoPositionUtils.getIndexByPhotoPosition(this.currentPhotoPosition);
      const positionAfterDelete = PhotoPositionUtils.findFocusPositionOnDelete(
        this.photoGroupList.getAllData(),
        this.currentPhotoPosition.groupIndex,
        index
      );
      if (positionAfterDelete) {
        const afterIndex = PhotoPositionUtils.getIndexByPhotoPosition(positionAfterDelete);
        computeFocusStr = `photo_${positionAfterDelete.groupIndex}_${afterIndex}`;
      } else {
        computeFocusStr = 'menu0';
      }
    }
    this.clickFocusBtn(computeFocusStr, false);
  }

  exitSelectedState(): void {
    this.isSelecting = false;
    this.selectedUriList = [];
    this.photoReloadCount++;
    this.isCheckAll = false;
    this.dialogList[0].uri = 'app.media.p_del_disabled';
    this.dialogList[1].uri = 'app.media.p_share_disabled';
    this.dialogList[2].name = '选择';
    this.dialogList[2].uri = 'app.media.p_check_default';
  }

  getDeleteBack(): void {
    this.deleteFlag = false;
    this.deleteIndex = 1;
    this.clickFocusBtn('dialog0', true);
  }

  getDeviceBack(): void {
    this.deviceFlag = false;
    this.deviceIndex = 1;
    this.clickFocusBtn('dialog1', true);
  }

  getReceiveBack(): void {
    this.receiveFlag = false;
    this.receiveIndex = 1;
    this.clickFocusBtn('menu0', false);
  }

  getPhotoTabBack(): void {
    this.scrollHistory.push(0);
    this.clickFocusBtn('menu0', false);
  }

  dismissToDfsDialog(): void {
    this.showToDfsDialog = false;
    this.clickFocusBtn(this.focusStr, false);
  }

  allBackFun(): boolean | void {
    if (this.showToDfsDialog) {
      this.dismissToDfsDialog();
      return true;
    }
    if (this.receiveFlag) {
      this.getReceiveBack();
      return true;
    }
    if (this.deviceFlag) {
      this.getDeviceBack();
      return true;
    }
    if (this.deleteFlag) {
      this.getDeleteBack();
      return true;
    }
    if (this.dialogFlag) {
      this.getDialogBack();
      return true;
    }
    if (this.isSelecting) {
      this.exitSelectedState();
      return true;
    }
    if (this.focusStr !== 'menu0' && this.chooseIndex === 0) {
      this.getPhotoTabBack();
      return true;
    }
    this.terminated = true;
  }

  getSharePhotoList(): PhotoModel[] {
    return this.selectedUriList;
  }

  getMenuClick(): void {
    const tempList: DialogState[] = [...this.dialogList];
    if (this.isSelecting && this.isCheckAll) {
      tempList[2].name = '取消全选';
      tempList[2].uri = 'app.media.p_check_all_default';
    } else if (this.isSelecting && !this.isCheckAll) {
      tempList[2].name = '全选';
      tempList[2].uri = 'app.media.p_check_no_default';
    } else {
      tempList[2].name = '选择';
      tempList[2].uri = 'app.media.p_check_default';
    }
    if (this.selectedUriList.length > 0) {
      tempList[0].uri = 'app.media.p_del_default';
      tempList[1].uri = 'app.media.p_share_default';
    } else {
      tempList[0].uri = 'app.media.p_del_disabled';
      tempList[1].uri = 'app.media.p_share_disabled';
    }
    this.dialogList = [...tempList];
    this.dialogFlag = true;
    this.clickFocusBtn('dialog2', true);
    this.dialogIndex = 2;
  }

  onMenuClickInPhoto(): void {
    this.getMenuClick();
  }

  clickFocusBtn(str: string, inDialog: boolean): boolean {
    const isSuccess = this.focusController.requestFocus(str);
    if (!isSuccess) {
      return false;
    }
    if (inDialog) {
      this.dialogFocusStr = str;
    } else {
      this.focusStr = str;
      if (!this.focusStr.startsWith('photo_')) {
        this.currentPhotoPosition = undefined;
      }
    }
    return true;
  }

  getPhotoModelByPosition(position: PhotoPosition): PhotoModel {
    const index = PhotoPositionUtils.getIndexByPhotoPosition(position);
    return this.photoGroupList.getData(position.groupIndex).photoList[index];
  }

  onEnterClickInPhoto(item: PhotoModel): void {
    if (this.isSelecting) {
      const resultIndex = this.selectedUriList.indexOf(item);
      if (resultIndex < 0) {
        this.selectedUriList.push(item);
      } else {
        this.selectedUriList.splice(resultIndex, 1);
      }
      this.isCheckAll = this.selectedUriList.length === this.allPhotos.length;
      return;
    }
    const indexInAll = this.allPhotos.findIndex((photo) => photo.uri === item.uri);
    if (item.photoType === Constants.PHOTO_TYPE_VIDEO) {
      this.videoLaunchHistory.push(item.uri);
      return;
    }
    this.routeHistory.push(`pages/PhotoWatch:${indexInAll}`);
  }

  changeFocusInPhoto(position: PhotoPosition): void {
    const index = PhotoPositionUtils.getIndexByPhotoPosition(position);
    const focusStr = `photo_${position.groupIndex}_${index}`;
    if (this.currentPhotoPosition === undefined || this.currentPhotoPosition.groupIndex !== position.groupIndex) {
      this.scrollHistory.push(position.groupIndex);
    }
    this.clickFocusBtn(focusStr, false);
    this.currentPhotoPosition = position;
  }

  onUpClickInPhoto(groupIndex: number, index: number): void {
    const upPosition = PhotoPositionUtils.findUpFocusPhoto(this.photoGroupList.getAllData(), groupIndex, index);
    if (upPosition) {
      this.changeFocusInPhoto(upPosition);
      return;
    }
    if (!this.isSelecting) {
      this.clickFocusBtn('menu0', false);
    }
  }

  async getDeleteAssets(): Promise<void> {
    try {
      await this.deleteService.delete(this.selectedUriList);
      this.getDeleteBack();
      this.exitSelectedState();
      this.getDialogBack();
      this.toastHistory.push('delete_success');
    } catch (e) {
      this.toastHistory.push('delete_error');
    }
  }

  getFocusHistory(): string[] {
    return this.focusController.getFocusHistory().map((item) => item.focusId);
  }

  getDeleteService(): MockDeleteService {
    return this.deleteService;
  }
}

function createGroups(): PhotoGroupModel[] {
  const groups: PhotoGroupModel[] = [];

  const group0 = new PhotoGroupModel();
  group0.createTime = 20250301;
  group0.photoList = TestDataFactory.createPhotoList(5, {
    namePrefix: 'HOME_A',
    type: Constants.PHOTO_TYPE_IMAGE
  });

  const group1 = new PhotoGroupModel();
  group1.createTime = 20250302;
  group1.photoList = TestDataFactory.createPhotoList(4, {
    namePrefix: 'HOME_B',
    uriPrefix: 'file://home_b',
    type: Constants.PHOTO_TYPE_IMAGE
  });

  const group2 = new PhotoGroupModel();
  group2.createTime = 20250303;
  group2.photoList = [
    TestDataFactory.createPhoto(0, undefined, {
      namePrefix: 'HOME_C',
      uriPrefix: 'file://home_c',
      type: Constants.PHOTO_TYPE_IMAGE
    }),
    TestDataFactory.createPhoto(1, undefined, {
      namePrefix: 'HOME_VIDEO',
      uriPrefix: 'file://home_c',
      type: Constants.PHOTO_TYPE_VIDEO
    })
  ];

  groups.push(group0);
  groups.push(group1);
  groups.push(group2);
  return groups;
}

export default function homeSelectionInteractionTest() {
  describe('HomeSelectionInteractionTest', () => {
    it('should select all photos across grouped homepage data without duplicates', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.selectedAll(true);

      expect(harness.isCheckAll).assertTrue();
      expect(harness.selectedUriList.length).assertEqual(harness.allPhotos.length);
      TestAsserts.assertUniqueUris(harness.selectedUriList);

      harness.selectedAll(true);
      expect(harness.selectedUriList.length).assertEqual(harness.allPhotos.length);
    });

    it('should clear selected photos when selectedAll is disabled', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.selectedAll(true);
      harness.selectedAll(false);

      expect(harness.isCheckAll).assertFalse();
      expect(harness.selectedUriList.length).assertEqual(0);
    });

    it('should keep selectedAll idempotent after multiple enable-disable cycles', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());

      harness.selectedAll(true);
      harness.selectedAll(false);
      harness.selectedAll(true);

      expect(harness.isCheckAll).assertTrue();
      expect(harness.selectedUriList.length).assertEqual(harness.allPhotos.length);
      TestAsserts.assertUniqueUris(harness.selectedUriList);
    });

    it('should build disabled dialog actions when no homepage photo is selected', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.getMenuClick();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogList[0].uri).assertEqual('app.media.p_del_disabled');
      expect(harness.dialogList[1].uri).assertEqual('app.media.p_share_disabled');
      expect(harness.dialogList[2].uri).assertEqual('app.media.p_check_default');
      expect(harness.dialogFocusStr).assertEqual('dialog2');
    });

    it('should build partial-select dialog actions when homepage enters edit mode', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.isSelecting = true;
      harness.selectedUriList.push(harness.allPhotos[0]);
      harness.getMenuClick();

      expect(harness.dialogList[0].uri).assertEqual('app.media.p_del_default');
      expect(harness.dialogList[1].uri).assertEqual('app.media.p_share_default');
      expect(harness.dialogList[2].uri).assertEqual('app.media.p_check_no_default');
      expect(harness.dialogList[2].name).assertEqual('全选');
    });

    it('should build cancel-all dialog action when homepage is fully selected', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.isSelecting = true;
      harness.selectedAll(true);
      harness.getMenuClick();

      expect(harness.dialogList[2].uri).assertEqual('app.media.p_check_all_default');
      expect(harness.dialogList[2].name).assertEqual('取消全选');
    });

    it('should reuse dialog index and focus target when homepage menu is reopened', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.getMenuClick();
      harness.dialogIndex = 0;

      harness.getMenuClick();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogIndex).assertEqual(2);
      expect(harness.dialogFocusStr).assertEqual('dialog2');
    });

    it('should reset homepage edit state and dialog assets on exitSelectedState', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.isSelecting = true;
      harness.isCheckAll = true;
      harness.selectedAll(true);
      harness.dialogList[0].uri = 'app.media.p_del_default';
      harness.dialogList[1].uri = 'app.media.p_share_default';
      harness.dialogList[2].uri = 'app.media.p_check_all_default';
      harness.exitSelectedState();

      expect(harness.isSelecting).assertFalse();
      expect(harness.isCheckAll).assertFalse();
      expect(harness.selectedUriList.length).assertEqual(0);
      expect(harness.photoReloadCount).assertEqual(1);
      expect(harness.dialogList[0].uri).assertEqual('app.media.p_del_disabled');
      expect(harness.dialogList[1].uri).assertEqual('app.media.p_share_disabled');
      expect(harness.dialogList[2].uri).assertEqual('app.media.p_check_default');
    });

    it('should return selectedUriList directly for share preparation', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.selectedUriList.push(harness.allPhotos[0], harness.allPhotos[2]);

      const sharePhotos = harness.getSharePhotoList();
      expect(sharePhotos.length).assertEqual(2);
      expect(sharePhotos[0].uri).assertEqual(harness.allPhotos[0].uri);
      expect(sharePhotos[1].uri).assertEqual(harness.allPhotos[2].uri);
    });

    it('should expose delete service instance for downstream assertions', 0, () => {
      const service = new MockDeleteService();
      const harness = new HomeSelectionHarness(createGroups(), service);

      expect(harness.getDeleteService()).assertEqual(service);
    });

    it('should toggle homepage selection and derive full-selection state from enter action', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.isSelecting = true;
      harness.allPhotos.forEach((photo) => harness.onEnterClickInPhoto(photo));

      expect(harness.selectedUriList.length).assertEqual(harness.allPhotos.length);
      expect(harness.isCheckAll).assertTrue();

      harness.onEnterClickInPhoto(harness.allPhotos[0]);
      expect(harness.selectedUriList.length).assertEqual(harness.allPhotos.length - 1);
      expect(harness.isCheckAll).assertFalse();
    });

    it('should open watch page for image tiles in browse mode', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.onEnterClickInPhoto(harness.allPhotos[0]);

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0]).assertEqual('pages/PhotoWatch:0');
      expect(harness.videoLaunchHistory.length).assertEqual(0);
    });

    it('should launch external video player for video tiles in browse mode', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      const videoPhoto = harness.allPhotos.find((photo) => photo.photoType === Constants.PHOTO_TYPE_VIDEO)!;
      harness.onEnterClickInPhoto(videoPhoto);

      expect(harness.videoLaunchHistory.length).assertEqual(1);
      expect(harness.videoLaunchHistory[0]).assertEqual(videoPhoto.uri);
      expect(harness.routeHistory.length).assertEqual(0);
    });

    it('should change homepage focus inside grouped grid and persist current position', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      const target = new PhotoPosition(1, 0, 1);
      harness.changeFocusInPhoto(target);

      expect(harness.focusStr).assertEqual('photo_1_1');
      expect(harness.currentPhotoPosition?.groupIndex).assertEqual(1);
      expect(harness.scrollHistory[0]).assertEqual(1);
    });

    it('should avoid duplicate group scroll when focus changes inside the same group', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());

      harness.changeFocusInPhoto(new PhotoPosition(1, 0, 0));
      harness.changeFocusInPhoto(new PhotoPosition(1, 0, 2));

      expect(harness.focusStr).assertEqual('photo_1_2');
      expect(harness.scrollHistory.length).assertEqual(1);
      expect(harness.scrollHistory[0]).assertEqual(1);
    });

    it('should resolve homepage photo model by grouped position', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      const position = new PhotoPosition(2, 0, 0);

      const photo = harness.getPhotoModelByPosition(position);

      expect(photo.uri).assertEqual('file://home_c/1');
      expect(photo.photoType).assertEqual(Constants.PHOTO_TYPE_VIDEO);
    });

    it('should move up to menu when photo grid reaches top row outside edit mode', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.focusStr = 'photo_0_0';
      harness.currentPhotoPosition = new PhotoPosition(0, 0, 0);
      harness.onUpClickInPhoto(0, 0);

      expect(harness.focusStr).assertEqual('menu0');
    });

    it('should move focus to upper photo when grouped grid has a valid previous row target', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.focusStr = 'photo_1_3';
      harness.currentPhotoPosition = new PhotoPosition(1, 0, 3);

      harness.onUpClickInPhoto(1, 3);

      expect(harness.focusStr.startsWith('photo_')).assertTrue();
      expect(harness.currentPhotoPosition?.groupIndex <= 1).assertTrue();
    });

    it('should keep focus in photo area when moving up during edit mode', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.isSelecting = true;
      harness.focusStr = 'photo_0_0';
      harness.currentPhotoPosition = new PhotoPosition(0, 0, 0);
      harness.onUpClickInPhoto(0, 0);

      expect(harness.focusStr).assertEqual('photo_0_0');
    });

    it('should restore dialog focus on delete back and device back flows', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.deleteFlag = true;
      harness.deviceFlag = true;

      harness.getDeleteBack();
      expect(harness.deleteFlag).assertFalse();
      expect(harness.deleteIndex).assertEqual(1);
      expect(harness.dialogFocusStr).assertEqual('dialog0');

      harness.getDeviceBack();
      expect(harness.deviceFlag).assertFalse();
      expect(harness.deviceIndex).assertEqual(1);
      expect(harness.dialogFocusStr).assertEqual('dialog1');
    });

    it('should restore homepage focus when receive dialog closes', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.receiveFlag = true;
      harness.getReceiveBack();

      expect(harness.receiveFlag).assertFalse();
      expect(harness.receiveIndex).assertEqual(1);
      expect(harness.focusStr).assertEqual('menu0');
    });

    it('should dismiss dfs target dialog and restore previous homepage focus', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.showToDfsDialog = true;
      harness.focusStr = 'photo_1_1';

      harness.dismissToDfsDialog();

      expect(harness.showToDfsDialog).assertFalse();
      expect(harness.focusStr).assertEqual('photo_1_1');
    });

    it('should reset photo-tab focus and record scroll when returning to top menu', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.focusStr = 'photo_2_1';

      harness.getPhotoTabBack();

      expect(harness.focusStr).assertEqual('menu0');
      expect(harness.scrollHistory[harness.scrollHistory.length - 1]).assertEqual(0);
    });

    it('should compute fallback focus after dialog closes from photo position', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.dialogFlag = true;
      harness.focusStr = 'photo_1_2';
      harness.currentPhotoPosition = new PhotoPosition(1, 0, 2);
      harness.getDialogBack();

      expect(harness.dialogFlag).assertFalse();
      expect(harness.focusStr.startsWith('photo_')).assertTrue();
    });

    it('should fall back to menu focus when dialog back has no current photo position', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.dialogFlag = true;
      harness.focusStr = 'menu1';
      harness.currentPhotoPosition = undefined;

      harness.getDialogBack();

      expect(harness.dialogFlag).assertFalse();
      expect(harness.focusStr).assertEqual('menu1');
    });

    it('should prioritize overlay dismissal before selection exit in allBackFun', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.showToDfsDialog = true;
      harness.receiveFlag = true;
      harness.deviceFlag = true;
      harness.deleteFlag = true;
      harness.dialogFlag = true;
      harness.isSelecting = true;
      const handled = harness.allBackFun();

      expect(handled).assertTrue();
      expect(harness.showToDfsDialog).assertFalse();
      expect(harness.receiveFlag).assertTrue();
      expect(harness.deviceFlag).assertTrue();
      expect(harness.deleteFlag).assertTrue();
      expect(harness.dialogFlag).assertTrue();
      expect(harness.isSelecting).assertTrue();
    });

    it('should exit selection through allBackFun when no overlay is active', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.isSelecting = true;
      harness.selectedUriList.push(harness.allPhotos[0]);
      const handled = harness.allBackFun();

      expect(handled).assertTrue();
      expect(harness.isSelecting).assertFalse();
      expect(harness.selectedUriList.length).assertEqual(0);
    });

    it('should dismiss receive overlay before device and delete overlays in allBackFun', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.receiveFlag = true;
      harness.deviceFlag = true;
      harness.deleteFlag = true;

      const handled = harness.allBackFun();

      expect(handled).assertTrue();
      expect(harness.receiveFlag).assertFalse();
      expect(harness.deviceFlag).assertTrue();
      expect(harness.deleteFlag).assertTrue();
      expect(harness.focusStr).assertEqual('menu0');
    });

    it('should dismiss device overlay before delete dialog in allBackFun', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.deviceFlag = true;
      harness.deleteFlag = true;
      harness.dialogFlag = true;

      const handled = harness.allBackFun();

      expect(handled).assertTrue();
      expect(harness.deviceFlag).assertFalse();
      expect(harness.deleteFlag).assertTrue();
      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogFocusStr).assertEqual('dialog1');
    });

    it('should dismiss delete overlay before homepage menu in allBackFun', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.deleteFlag = true;
      harness.dialogFlag = true;

      const handled = harness.allBackFun();

      expect(handled).assertTrue();
      expect(harness.deleteFlag).assertFalse();
      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogFocusStr).assertEqual('dialog0');
    });

    it('should dismiss homepage dialog before leaving current photo focus in allBackFun', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.dialogFlag = true;
      harness.focusStr = 'photo_0_1';
      harness.currentPhotoPosition = new PhotoPosition(0, 0, 1);

      const handled = harness.allBackFun();

      expect(handled).assertTrue();
      expect(harness.dialogFlag).assertFalse();
      expect(harness.focusStr.startsWith('photo_')).assertTrue();
    });

    it('should jump back to photo tab before terminating app shell', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.focusStr = 'menu1';
      harness.chooseIndex = 0;
      const handled = harness.allBackFun();

      expect(handled).assertTrue();
      expect(harness.focusStr).assertEqual('menu0');
      expect(harness.scrollHistory[0]).assertEqual(0);
      expect(harness.terminated).assertFalse();
    });

    it('should terminate shell when homepage is already at root state', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.focusStr = 'menu0';
      harness.chooseIndex = 0;
      harness.allBackFun();

      expect(harness.terminated).assertTrue();
    });

    it('should terminate shell immediately when homepage is not on photo tab root', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.focusStr = 'menu1';
      harness.chooseIndex = 1;

      harness.allBackFun();

      expect(harness.terminated).assertTrue();
      expect(harness.focusStr).assertEqual('menu1');
    });

    it('should reuse menu click builder from photo context', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.isSelecting = true;
      harness.selectedUriList.push(harness.allPhotos[0]);
      harness.onMenuClickInPhoto();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogIndex).assertEqual(2);
      expect(harness.dialogList[0].uri).assertEqual('app.media.p_del_default');
    });

    it('should delete selected homepage assets and clear edit state on success', 0, async () => {
      const service = new MockDeleteService();
      const harness = new HomeSelectionHarness(createGroups(), service);
      harness.dialogFlag = true;
      harness.deleteFlag = true;
      harness.isSelecting = true;
      harness.selectedUriList.push(harness.allPhotos[0], harness.allPhotos[1]);
      await harness.getDeleteAssets();

      expect(service.deletedBatches.length).assertEqual(1);
      expect(service.deletedBatches[0].length).assertEqual(2);
      expect(harness.deleteFlag).assertFalse();
      expect(harness.dialogFlag).assertFalse();
      expect(harness.selectedUriList.length).assertEqual(0);
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_success');
    });

    it('should still complete empty homepage delete request through service contract', 0, async () => {
      const service = new MockDeleteService();
      const harness = new HomeSelectionHarness(createGroups(), service);
      harness.dialogFlag = true;
      harness.deleteFlag = true;
      harness.isSelecting = true;

      await harness.getDeleteAssets();

      expect(service.deletedBatches.length).assertEqual(1);
      expect(service.deletedBatches[0].length).assertEqual(0);
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_success');
      expect(harness.isSelecting).assertFalse();
    });

    it('should keep homepage selection when delete action fails', 0, async () => {
      const service = new MockDeleteService();
      service.shouldFail = true;
      const harness = new HomeSelectionHarness(createGroups(), service);
      harness.dialogFlag = true;
      harness.deleteFlag = true;
      harness.isSelecting = true;
      harness.selectedUriList.push(harness.allPhotos[0]);
      await harness.getDeleteAssets();

      expect(service.deletedBatches.length).assertEqual(0);
      expect(harness.isSelecting).assertTrue();
      expect(harness.selectedUriList.length).assertEqual(1);
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_error');
    });

    it('should preserve dialog and delete overlays when homepage delete fails', 0, async () => {
      const service = new MockDeleteService();
      service.shouldFail = true;
      const harness = new HomeSelectionHarness(createGroups(), service);
      harness.dialogFlag = true;
      harness.deleteFlag = true;
      harness.isSelecting = true;
      harness.selectedUriList.push(harness.allPhotos[0], harness.allPhotos[1]);

      await harness.getDeleteAssets();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.deleteFlag).assertTrue();
      expect(harness.selectedUriList.length).assertEqual(2);
    });

    it('should keep focus trace consistent for homepage dialog navigation', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.getMenuClick();
      harness.getDeleteBack();
      harness.getDialogBack();

      TestAsserts.assertStringArrayContains(harness.getFocusHistory(), ['dialog2', 'dialog0']);
    });

    it('should return false and preserve homepage focus state for unsupported focus target', 0, () => {
      const harness = new HomeSelectionHarness(createGroups());
      harness.focusStr = 'menu0';
      harness.dialogFocusStr = 'dialog2';

      const focused = harness.clickFocusBtn('photo_9_9', false);

      expect(focused).assertFalse();
      expect(harness.focusStr).assertEqual('menu0');
      expect(harness.dialogFocusStr).assertEqual('dialog2');
    });
  });
}
