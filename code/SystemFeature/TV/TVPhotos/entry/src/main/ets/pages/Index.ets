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

import router from '@ohos.router';
import { AlbumModel, AlbumType, DialogModel, PhotoGroupModel, PhotoModel, PhotoPosition } from '../models/PhotoModel';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import promptAction from '@ohos.promptAction';
import { Util } from '../common/Util';
import { PhotoGroupDataSource } from '../models/IDataSource';
import { Constants } from '../common/Constants';
import { FileSendModel } from '../models/FileSendModel';
import wifiManager from '@ohos.wifiManager';
import { WifiDeviceManager } from '../common/WifiManager';
import { inputConsumer } from '@kit.InputKit';
import { common, launcherBundleManager } from '@kit.AbilityKit';
import { FIRST_ROW_MAX_INDEX, PhotoPositionUtils } from '../common/PhotoPositionUtils';
import Logger from '../common/Logger';
import { componentUtils } from '@kit.ArkUI';
import photoManager from '../manager/PhotoManager';
import { VideoImage } from './components/VideoImage';
import { JSON } from '@kit.ArkTS';
import { DistributedPhotoView } from '../component/DistributedPhotoView';
import { rdbManager } from '../manager/RdbManager';
import { dfsManager } from '../manager/DfsManager';
import nasSessionManager, { SessionModel } from '../smaba/NasSessionManager';
import { EventUtil } from '../common/EventUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { createRegister } from '../manager/ChangeRegister';

//判断是否安装此软件
export function isAppInstalled(): boolean {
  try {
    let data = launcherBundleManager.getShortcutInfoSync('com.ohos.demandplayer');
    console.log('data is ' + JSON.stringify(data));
    return true;
  } catch (errData) {
    let code = (errData as BusinessError).code;
    let message = (errData as BusinessError).message;
    console.error(`errData is errCode:${code}  message:${message}`);
  }
  return false;
}

// 跳转到播放视频软件
export function getToVideoApp(uri: string, name: string, img: PixelMap | undefined) {
  try {
    globalThis.abilityContext.startAbility({
      bundleName: 'com.ohos.demandplayer',
      abilityName: 'MainAbility',
      parameters: {
        startByOther: true,
        videoIndex: 0,
        videoList: [{
          url: uri,
          name: name,
          uri: uri,
          img: img,
          type: 'local'
        }]
      }
    }, (error: BusinessError) => {
      console.error(`startAbility err:${error}`);
    })
  } catch (e) {
    Logger.info(TAG, `try startAbility catch err:${e}`);
  }
}

const TAG = 'PhotoIndex';
const FOCUS_CHANGE_DELAY = 100;

@Entry
@Component
struct PhotoIndex {
  private menuList: Resource[] =
    [$r('app.string.picture'), $r('app.string.album'), $r('app.string.menu_distributed_photo')];
  @State chooseIndex: number = 0;
  @State albumIndex: number = 0;
  @State photoGroupList: PhotoGroupDataSource = new PhotoGroupDataSource();
  @State focusStr: string = 'menu0';
  @State dialogFocusStr: string = ''
  private gridRowCount: number = 6;
  private albumGridRowCount: number = 4;
  @State isSelecting: boolean = false;
  @State selectedUriList: PhotoModel[] = [];
  @State dialogIndex: number = 0;
  @State isCheckAll: boolean = false;
  @State dialogList: DialogModel[] = [{ uri: 'app.media.p_del_disabled', name: $r('app.string.delete') }, {
    uri: 'app.media.p_share_disabled',
    name: $r('app.string.share')
  }, {
    uri: 'app.media.p_check_default',
    name: $r('app.string.choose'),
  }];
  @State dialogFlag: boolean = false;
  private scroller: Scroller = new Scroller();
  //删除
  @State deleteFlag: boolean = false;
  private deleteList: Resource[] = [$r('app.string.cancel'), $r('app.string.delete')];
  @State deleteIndex: number = 1;
  //分享
  @StorageLink('deviceList') @Watch('changeDevice') deviceList: wifiManager.WifiP2pDevice[] = []
  @State currentName: string = '';
  private scrollerShareList: Scroller = new Scroller()
  @State deviceFlag: boolean = false;
  @State deviceIndex: number = 0;
  //接收
  @State receiveFlag: boolean = false;
  private receiveList: Resource[] = [$r('app.string.cancel'), $r('app.string.confirm')];
  @State receiveIndex: number = 1;
  // 0 未开始  1 未确认  2 确认中 3 确认 4 拒绝 5 接收中 6 接收完成
  @StorageLink('receivedState') @Watch('receivedStateChange') receivedState: number = 2;
  @StorageLink('receivedInfo') receivedInfo: FileSendModel = {} as FileSendModel;
  @StorageLink('progressValue') @Watch('progressChange') progressValue: number = 0;
  @State progress: number = 0;
  @State fullSize: string = '';
  @State typeName: string = '';
  sizeConvert = 1024;
  private currentPhotoPosition: PhotoPosition | undefined = undefined;
  @State gridItemHeight: number = 0;
  private screenHeight: number = 0;
  private photoContainerCenterY: number = 0;
  private allPhotos: PhotoModel[] = [];
  private photoGroupModels: PhotoGroupModel[] = [];
  @State subTypeModels: (AlbumModel | undefined)[] = [];
  @State showToDfsDialog: boolean = false;
  private keyOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: Constants.TAB_KEY,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  private keyOptionsMenu: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: Constants.MENU_KEY,
    isFinalKeyDown: false,
    finalKeyDownDuration: Constants.KEY_DOWN_DURATION
  };
  private keyCallback = (keyOptions: inputConsumer.KeyOptions) => {
    if (!this.dialogFlag && this.chooseIndex == 0 && this.photoGroupList.totalCount()) {
      if (this.focusStr == 'menu0') {
        this.dialogFlag = true;
        setTimeout(() => {
          this.clickFocusBtn('dialog2', true) //默认在选择焦点
          this.dialogIndex = 2;
        }, 100)
      } else {
        this.getMenuClick();
      }
    }

    if (this.chooseIndex === 2) {
      this.showToDfsDialog = true;
      setTimeout(() => {
        this.clickFocusBtn('dfs_dialog_confirm', true);
      }, 100)
    }
  }
  private allPhotoObserver = (photos: PhotoModel[], albumModel: AlbumModel) => {
    this.allPhotos = photos;
    rdbManager.insertDfsPhotoData(getContext(), photos);
    let tmpList: PhotoGroupModel[] = [];
    if (photos && photos.length > 0) {
      photos.forEach((photo: PhotoModel) => {
        let index = tmpList.findIndex((item: PhotoGroupModel) => {
          return item.createTime === photo.dateAdded;
        });
        if (index >= 0) {
          tmpList[index].photoList.push(photo);
        } else {
          let photoDateModel = new PhotoGroupModel();
          photoDateModel.createTime = photo.dateAdded;
          photoDateModel.photoList.push(photo);
          tmpList.push(photoDateModel);
        }
      })
    }
    this.photoGroupModels = tmpList;
    this.photoGroupList.setData(this.photoGroupModels);
    this.photoGroupModels.forEach((group,groupIndex)=>{
      group.photoList.forEach((photo,photoIndex)=>{
        photo.photoTag='photo_' + groupIndex + '_' + photoIndex;
      })
    })
    this.subTypeModels[AlbumType.ALL] = albumModel

    this.subTypeModels.push(undefined)
    this.subTypeModels.pop()
  }
  private favoritePhotoObserver = (photos: PhotoModel[], albumModel: AlbumModel) => {
    this.subTypeModels[AlbumType.FAVORITE] = albumModel
    this.subTypeModels.push(undefined)
    this.subTypeModels.pop()
  }
  private screenShotPhotoObserver = (photos: PhotoModel[], albumModel: AlbumModel) => {
    this.subTypeModels[AlbumType.SCREENSHOT] = albumModel
    this.subTypeModels.push(undefined)
    this.subTypeModels.pop()
  }
  private trashPhotoObserver = (photos: PhotoModel[], albumModel: AlbumModel) => {
    this.subTypeModels[AlbumType.TRASH] = albumModel
    this.subTypeModels[AlbumType.TRASH].cover = $r('app.media.cover_trash');
    this.subTypeModels.push(undefined)
    this.subTypeModels.pop()
  }
  private nasSessionObserver = (models: SessionModel[]) => {
    this.subTypeModels[AlbumType.NAS_SESSION] = new AlbumModel(AlbumType.NAS_SESSION, $r('app.string.album_name_more'))
    this.subTypeModels[AlbumType.NAS_SESSION].count = models.length
    this.subTypeModels[AlbumType.NAS_SESSION].cover = $r('app.media.cover_more')
    this.subTypeModels.push(undefined)
    this.subTypeModels.pop()
  }

  aboutToAppear() {
    this.screenHeight = AppStorage.get<number>('window_height') ?? 0;
    if (this.receivedInfo && this.receivedInfo.size) {
      this.fullSize = this.getSize(this.receivedInfo.size)
      this.typeName = this.getMediaType(this.receivedInfo.type)
    }
  }

  onPageShow() {
    try {
      inputConsumer.on('key', this.keyOptions, this.keyCallback);
      inputConsumer.on('key', this.keyOptionsMenu, this.keyCallback);
    } catch (error) {
      Logger.error(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
    this.defaultFocusBtn();

    photoManager.getLoader(AlbumType.ALL)?.registerChangeCallback(this.allPhotoObserver)
    photoManager.getLoader(AlbumType.FAVORITE)?.registerChangeCallback(this.favoritePhotoObserver)
    photoManager.getLoader(AlbumType.SCREENSHOT)?.registerChangeCallback(this.screenShotPhotoObserver)
    photoManager.getLoader(AlbumType.TRASH)?.registerChangeCallback(this.trashPhotoObserver)
    nasSessionManager.registerSessionCallback(this.nasSessionObserver)
    // 注册监听相册变化
    setTimeout(() => {
      createRegister(() => {
        photoManager.refresh();
      })
    }, 100)
  }

  onBackPress(): boolean | void {
    return this.allBackFun();
  }

  onPageHide() {
    inputConsumer.off('key', this.keyOptions, this.keyCallback);
    inputConsumer.off('key', this.keyOptionsMenu, this.keyCallback);
    AppStorage.setOrCreate<string>('focusStr', this.focusStr);

    photoManager.getLoader(AlbumType.ALL)?.unRegisterChangeCallback(this.allPhotoObserver)
    photoManager.getLoader(AlbumType.FAVORITE)?.unRegisterChangeCallback(this.favoritePhotoObserver)
    photoManager.getLoader(AlbumType.SCREENSHOT)?.unRegisterChangeCallback(this.screenShotPhotoObserver)
    photoManager.getLoader(AlbumType.TRASH)?.unRegisterChangeCallback(this.trashPhotoObserver)

    nasSessionManager.unRegisterSessionCallback(this.nasSessionObserver)
  }

  //批量删除相册
  async getDeleteAssets() {
    try {
      await photoManager.delete(AlbumType.ALL, this.selectedUriList);
      this.getDeleteBack();
      this.exitSelectedState();
      setTimeout(() => {
        this.getDialogBack();
        promptAction.showToast({
          message: $r('app.string.delete_success'),
          duration: 2000
        });
      }, 1000)
    } catch (e) {
      promptAction.showToast({
        message: $r('app.string.delete_error'),
        duration: 2000
      });
    }
  }

  selectedAll(isSelectedAll: boolean) {
    this.photoGroupList.getAllData().forEach((dateItem: PhotoGroupModel) => {
      dateItem.photoList.forEach((item: PhotoModel) => {
        if (isSelectedAll) {
          if (this.selectedUriList.indexOf(item) < 0) {
            this.selectedUriList.push(item);
          }
        } else {
          this.selectedUriList = [];
        }
      })
    })
    this.isCheckAll = isSelectedAll;
  }

  //弹出框的返回
  getDialogBack() {
    this.dialogFlag = false;
    //数据加载完获取焦点，照片为0，焦点放在菜单上
    setTimeout(() => {
      let computeFocusStr = this.focusStr
      if (this.focusStr.startsWith('photo') && this.currentPhotoPosition !== undefined ){
        let index = PhotoPositionUtils.getIndexByPhotoPosition(this.currentPhotoPosition);
        let positionAfterDelete = PhotoPositionUtils.findFocusPositionOnDelete(
          this.photoGroupList.getAllData(), this.currentPhotoPosition.groupIndex, index);

        if (positionAfterDelete) {
          let afterIndex = PhotoPositionUtils.getIndexByPhotoPosition(positionAfterDelete);
          computeFocusStr = 'photo_' + positionAfterDelete.groupIndex + '_' + afterIndex;
        }else{
          computeFocusStr = 'menu0'
        }
      }
      this.clickFocusBtn(computeFocusStr, false)
    }, 100)
  }

  //编辑状态的照片返回
  exitSelectedState() {
    this.isSelecting = false;
    this.selectedUriList = [];
    this.photoGroupList.notifyDataReload();
    this.isCheckAll = false;
    this.dialogList[0].uri = 'app.media.p_del_disabled';
    this.dialogList[1].uri = 'app.media.p_share_disabled';
    this.dialogList[2].name = $r('app.string.choose');
    this.dialogList[2].uri = 'app.media.p_check_default';
  }

  //删除状态的返回
  getDeleteBack() {
    this.deleteFlag = false;
    this.deleteIndex = 1;
    setTimeout(() => {
      this.clickFocusBtn('dialog0', true) //默认在选择焦点
    }, 100)
  }

  //设备状态的返回
  getDeviceBack() {
    this.deviceFlag = false;
    this.deviceIndex = 1;
    setTimeout(() => {
      this.clickFocusBtn('dialog1', true) //默认在选择焦点
    }, 100)
  }

  //接收的弹窗
  getReceiveBack() {
    this.receiveFlag = false;
    this.receiveIndex = 1;
    setTimeout(() => {
      this.clickFocusBtn('menu0', false) //默认在菜单焦点
    }, 100)
  }

  // 先返回到照片Tab
  getPhotoTabBack() {
    this.scroller.scrollToIndex(0, false, ScrollAlign.AUTO)
    this.clickFocusBtn('menu0', false);
  }

  //监听接收状态的变化
  async receivedStateChange() {
    if (this.receivedState === 6) {
      this.getReceiveBack();
      await WifiDeviceManager.getInstance().ConnectionClose()
      AppStorage.setOrCreate('receivedState', 0)
    } else if (this.receivedState === 2) {
      this.receiveFlag = true;
      this.receiveIndex = 1;
      setTimeout(() => {
        this.clickFocusBtn('receive1', true)
      }, 500)
    }
  }

  progressChange() {
    this.progress = Math.round((this.progressValue / this.receivedInfo.size) * 100)
  }

  getSize(size: number): string {
    if (size / (this.sizeConvert * this.sizeConvert) > 1) {
      return `${(size / (this.sizeConvert * this.sizeConvert)).toFixed(2)}MB`;
    } else {
      return `${(size / this.sizeConvert).toFixed(2)}KB`;
    }
  }

  getMediaType(type: number) {
    return type === 1 ? '张图片' : '个视频'
  }

  // 分享
  changeDevice() {
    if (this.deviceList.length == 0) {
      this.currentName = ''
    }
  }

  shareAction(items:PhotoModel[]){
    Logger.info(TAG, `share file length is ${items.length}`);
    promptAction.showToast({
      message: '该功能开发中，敬请期待'
    })
  }

  dismissToDfsDialog() {
    this.showToDfsDialog = false;
    setTimeout(() => {
      this.clickFocusBtn(this.focusStr, false)
    }, 100)
  }

  // 统一返回封装
  allBackFun(): boolean | void {
    if (this.showToDfsDialog) {
      this.dismissToDfsDialog();
      return true;
    }
    if (this.receiveFlag) {
      this.getReceiveBack();
      return true
    }
    if (this.deviceFlag) {
      this.getDeviceBack();
      return true
    }
    if (this.deleteFlag) {
      this.getDeleteBack();
      return true
    }
    if (this.dialogFlag) {
      this.getDialogBack();
      return true
    }
    if (this.isSelecting) {
      this.exitSelectedState();
      return true
    }
    if(this.focusStr !== 'menu0' && this.chooseIndex === 0) {
      this.getPhotoTabBack();
      return true
    }
    // 杀死进程
    (getContext(this) as common.UIAbilityContext).terminateSelf();
  }

  //获取分享选择之后的照片List
  getSharePhotoList(): PhotoModel[] {
    return this.selectedUriList;
  }

  getMenuClick() {
    let tempList: DialogModel[] = [...this.dialogList]
    if (this.isSelecting && this.isCheckAll) {
      tempList[2].name = $r('app.string.cancel_all_select')
      tempList[2].uri = 'app.media.p_check_all_default'
    } else if (this.isSelecting && !this.isCheckAll) {
      tempList[2].name = $r('app.string.select_all')
      tempList[2].uri = 'app.media.p_check_no_default'
    } else {
      tempList[2].name = $r('app.string.choose')
      tempList[2].uri = 'app.media.p_check_default'
    }
    // 判断删除按钮和分享按钮
    const count = this.selectedUriList.length;
    if (count > 0) {
      tempList[0].uri = 'app.media.p_del_default';
      tempList[1].uri = 'app.media.p_share_default';
    } else {
      tempList[0].uri = 'app.media.p_del_disabled';
      tempList[1].uri = 'app.media.p_share_disabled';
    }
    this.dialogList = [...tempList];
    this.dialogFlag = true;
    setTimeout(() => {
      this.clickFocusBtn('dialog2', true) //默认在选择焦点
      this.dialogIndex = 2;
    }, 100)
  }

  defaultFocusBtn() {
    let focusStr = AppStorage.get<string>('focusStr') || this.focusStr;
    let id=setTimeout(() => {
      this.clickFocusBtn(focusStr, false)
      clearTimeout(id)
    }, 500)
  }

  clickFocusBtn(str: string, inDialog: boolean): boolean {
    let isSuccess = focusControl.requestFocus(str);
    if (isSuccess) {
      if (inDialog) {
        this.dialogFocusStr = str;
      } else {
        this.focusStr = str;
        AppStorage.setOrCreate<string>('focusStr', str);
        if (!this.focusStr.startsWith('photo_')) {
          this.currentPhotoPosition = undefined
        }
      }
    } else {
      Logger.error(TAG, `requestFocus is failed , focusStr = ${str}`);
      let id=setTimeout(() => {
        // 在相册中某一模块消失时，让焦点走到上面的相册按钮上
        if(str.substring(0, 5)=='album'){
          this.clickFocusBtn('menu1', false)
        }
        clearTimeout(id)
      }, 500)
    }
    return isSuccess;
  }

  onDownClickInPhoto(groupIndex: number, index: number, count: number) {
    let downPosition =
      PhotoPositionUtils.findDownFocusPhoto(this.photoGroupList.getAllData(), groupIndex, index, count);
    if (downPosition) {
      this.changeFocusInPhoto(downPosition);
    }
  }

  onUpClickInPhoto(groupIndex: number, index: number) {
    let upPosition = PhotoPositionUtils.findUpFocusPhoto(this.photoGroupList.getAllData(), groupIndex, index);
    if (upPosition) {
      this.changeFocusInPhoto(upPosition);
    } else {
      // 向上焦点需要切换到 menu ,编辑态不可移动menu
      if (!this.isSelecting) {
        this.clickFocusBtn('menu0', false);
      }
    }
  }

  onLeftClickInPhoto(groupIndex: number, index: number) {
    let leftPosition = PhotoPositionUtils.findLeftFocusPhoto(groupIndex, index);
    if (leftPosition) {
      this.changeFocusInPhoto(leftPosition);
    }
  }

  onRightClickInPhoto(groupIndex: number, index: number) {
    let rightPosition = PhotoPositionUtils.findRightFocusPhoto(this.photoGroupList.getAllData(), groupIndex, index);
    if (rightPosition) {
      this.changeFocusInPhoto(rightPosition);
    }
  }

  getPhotoModelByPosition(position: PhotoPosition): PhotoModel {
    let index = PhotoPositionUtils.getIndexByPhotoPosition(position);
    return this.photoGroupList.getData(position.groupIndex).photoList[index]
  }

  onEnterClickInPhoto(item: PhotoModel) {
    if (this.isSelecting) {
      let resultIndex = this.selectedUriList.indexOf(item);
      if (resultIndex < 0) {
        this.selectedUriList.push(item);
      } else {
        this.selectedUriList.splice(resultIndex, 1);
      }
      const count = this.selectedUriList.length;
      this.isCheckAll = count === this.allPhotos.length ? true : false;
    } else {
      let indexInAll = this.allPhotos.findIndex((photo) => {
        return photo.uri === item.uri;
      })
      if (item && item.photoType === Constants.PHOTO_TYPE_VIDEO) {
        if (isAppInstalled()) {
          getToVideoApp(item.uri, item.displayName, item.thumbnail);
        }
      } else {
        router.pushUrl({
          url: 'pages/PhotoWatch',
          params: {
            photoIndex: indexInAll,
            photoList: this.allPhotos
          }
        })
      }
    }
  }

  onMenuClickInPhoto() {
    let tempList: DialogModel[] = [...this.dialogList]
    if (this.isSelecting && this.isCheckAll) {
      tempList[2].name = $r('app.string.cancel_all_select')
      tempList[2].uri = 'app.media.p_check_all_default'
    } else if (this.isSelecting && !this.isCheckAll) {
      tempList[2].name = $r('app.string.select_all')
      tempList[2].uri = 'app.media.p_check_no_default'
    } else {
      tempList[2].name = $r('app.string.choose')
      tempList[2].uri = 'app.media.p_check_default'
    }
    // 判断删除按钮和分享按钮
    const count = this.selectedUriList.length;
    if (count > 0) {
      tempList[0].uri = 'app.media.p_del_default';
      tempList[1].uri = 'app.media.p_share_default';
    } else {
      tempList[0].uri = 'app.media.p_del_disabled';
      tempList[1].uri = 'app.media.p_share_disabled';
    }
    this.dialogList = [...tempList];
    this.dialogFlag = true;
    setTimeout(() => {
      this.clickFocusBtn('dialog2', true) //默认在选择焦点
      this.dialogIndex = 2;
    }, 100)
  }

  changeFocusInPhoto(position: PhotoPosition) {
    Logger.info(TAG, `changeFocusInPhoto = ${JSON.stringify(position)}`)
    let index = PhotoPositionUtils.getIndexByPhotoPosition(position);
    let focusStr = 'photo_' + position.groupIndex + '_' + index;
    if (this.currentPhotoPosition === undefined || this.currentPhotoPosition.groupIndex !== position.groupIndex) {
      this.scroller.scrollToIndex(position.groupIndex, false, ScrollAlign.AUTO);
    } else {
      if ((position.rowIndex > this.currentPhotoPosition.rowIndex && position.rowIndex > 1) ||
        (position.rowIndex < this.currentPhotoPosition.rowIndex)) {
        let componentInfo = componentUtils.getRectangleById(focusStr);
        let componentCenterY = Math.floor(componentInfo.size.height / 2) + componentInfo.windowOffset.y
        let offsetY = componentCenterY - this.photoContainerCenterY;
        if (offsetY !== 0) {
          this.scroller.scrollBy(0, offsetY + 'px');
        }
      }
    }
    setTimeout(() => {
      this.clickFocusBtn(focusStr, false);
      this.currentPhotoPosition = position;
    }, FOCUS_CHANGE_DELAY);
  }

  layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: [0], // 索引为0和7的GridItem占用的列数由onGetIrregularSizeByIndex指定
    onGetIrregularSizeByIndex: (index: number) => {
      return [2, 2]
    }
  }

  getGridHeight(groupIndex: number, count: number): string {
    let height = 0;
    let maxRow = PhotoPositionUtils.getPhotoPosition(groupIndex, count - 1).rowIndex;
    if (maxRow <= 1) {
      height = vp2px(this.gridItemHeight) * 2;
    } else {
      height = vp2px(this.gridItemHeight) * (maxRow + 1);
    }
    return height + 'px';
  }

  onPhotoKeyEvent(event: KeyEvent, dateIndex: number, index: number, dateItem: PhotoGroupModel, item: PhotoModel) {
    if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT && event.type === KeyType.Down) {
      this.onLeftClickInPhoto(dateIndex, index);
    }
    if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && event.type === KeyType.Down) {
      this.onRightClickInPhoto(dateIndex, index);
    }
    if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN && event.type === KeyType.Down) {
      this.onDownClickInPhoto(dateIndex, index, dateItem.photoList.length);
    }
    if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Down) {
      this.onUpClickInPhoto(dateIndex, index);
    }
    // 电脑回车键KEYCODE_ENTER
    if ((event.keyCode === KeyCode.KEYCODE_DPAD_CENTER || event.keyCode === KeyCode.KEYCODE_ENTER) &&
      event.type === KeyType.Down) {
      this.onEnterClickInPhoto(item);
    }
    // 数字1KEYCODE_NUMPAD_1
    if ((event.keyCode === KeyCode.KEYCODE_MENU || event.keyCode === KeyCode.KEYCODE_NUMPAD_1) &&
      event.type === KeyType.Down) {
      this.onMenuClickInPhoto();
    }
    //返回键KEYCODE_BACK
    if (event.keyCode === KeyCode.KEYCODE_NUMPAD_2 && event.type === KeyType.Down) {
      this.exitSelectedState();
    }
  }

  onTabMenuLeftClick(index: number) {
    if (index > 0) {
      this.chooseIndex--;
      this.clickFocusBtn('menu' + this.chooseIndex, false);
      photoManager.refresh();
    }
  }

  onTabMenuRightClick(index: number) {
    if (index <= 1) {
      this.chooseIndex++;
      this.clickFocusBtn('menu' + this.chooseIndex, false);
      photoManager.refresh();
    }
  }

  onTabMenuDownClick(index: number) {
    if (this.chooseIndex === 0 && this.photoGroupList.totalCount()) {
      this.changeFocusInPhoto(new PhotoPosition(0, 0, 0));
    } else if (this.chooseIndex === 1 && this.subTypeModels.length > 0) {
      this.focusFirstAlbum();
    } else {
      if (dfsManager.isConnected()) {
        this.clickFocusBtn('dfs_photo_0', false);
      } else {
        this.clickFocusBtn('to_dfs_manage', false);
      }
    }
  }

  toDfsDevicePage() {
    router.pushUrl({
      url: 'pages/DistributedDevicePage'
    });
    this.dismissToDfsDialog();
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.photo'))
          .fontFamily('HarmonyOS Sans')
          .fontColor(Color.White)
          .fontSize('64lpx')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: '33lpx',
        right: '33lpx',
        top: '48lpx',
        bottom: '56lpx'
      })

      Row() {
        ForEach(this.menuList, (item: string, index: number) => {
          ListItem() {
            Column() {
              Column() {
                Text(item)
                  .fontFamily('HarmonyOS Sans')
                  .fontSize('36lpx')
                  .fontWeight(500)
                  .fontColor((this.chooseIndex === index) ?
                    this.focusStr == ('menu' + index) ? '#DBFFFFFF' : '#DB000000' : '#DBFFFFFF')
                  .textAlign(TextAlign.Center)
                  .height('64lpx')
                  .borderRadius('200lpx')
                  .backgroundColor((this.chooseIndex === index) ?
                    this.focusStr == ('menu' + index) ? '#33FFFFFF' : '#DBFFFFFF' : '#33FFFFFF')
                  .focusable(true)
                  .defaultFocus(index === 0)
                  .id('menu' + index)
                  .padding({
                    left: '22lpx',
                    right: '22lpx'
                  })
                  .onKeyEvent(e => {
                    if (e.keyCode === KeyCode.KEYCODE_DPAD_LEFT && e.type === KeyType.Down) {
                      this.onTabMenuLeftClick(index);
                    }
                    if (e.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && e.type === KeyType.Down) {
                      this.onTabMenuRightClick(index);
                    }
                    if (e.keyCode === KeyCode.KEYCODE_DPAD_DOWN && e.type === KeyType.Down) {
                      this.onTabMenuDownClick(index);
                    }
                    // 数字1KEYCODE_NUMPAD_1
                    if ((e.keyCode == KeyCode.KEYCODE_MENU || e.keyCode == KeyCode.KEYCODE_NUMPAD_1) &&
                      e.type == KeyType.Down) {
                      if (this.chooseIndex === 0 && this.photoGroupList.totalCount()) {
                        this.dialogFlag = true;
                        setTimeout(() => {
                          this.clickFocusBtn('dialog2', true) //默认在选择焦点
                          this.dialogIndex = 2;
                        }, 100)
                      }
                    }
                  })
                  .onClick(()=>{
                    this.chooseIndex = index
                    this.clickFocusBtn('menu' + this.chooseIndex, false);
                    photoManager.refresh();

                  })
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .borderRadius('200lpx')
              .padding('6lpx')
              .border({
                width: 2,
                color: this.focusStr == ('menu' + index) ? '#fff' : Color.Transparent,
                style: BorderStyle.Solid
              })
              .onHover(() => {
                this.clickFocusBtn('menu' + index, false);
                photoManager.refresh();
              })
              .onHover(() => {
                this.chooseIndex = index;
              })
            }
            .margin({
              left: '33lpx',
              right: '4lpx'
            })
          }
        })
      }
      .width('100%')
      .margin({
        bottom: '31lpx',
      })

      if (this.chooseIndex === 0) {
        if (this.photoGroupList.totalCount() === 0) {
          Text($r('app.string.no_data'))
            .fontColor(Color.White)
            .fontSize('34lpx')
            .size({ height: `calc(100% - 520lpx)` })
        } else {
          Row() {
            List({ scroller: this.scroller, space: 36 }) {
              LazyForEach(this.photoGroupList, (dateItem: PhotoGroupModel, dateIndex: number) => {
                ListItem() {
                  Column() {
                    Text(Util.isToday(dateItem.createTime) ? $r('app.string.today') :
                      (Util.isYesterday(dateItem.createTime) ? $r('app.string.yesterday') :
                      Util.getDateFormatString(dateItem.createTime)))
                      .fontFamily('HarmonyOS Sans')
                      .fontSize('36lpx')
                      .fontWeight(500)
                      .margin({ left: '24lpx', bottom: '12lpx' })
                      .alignSelf(ItemAlign.Start)
                      .fontColor(Color.White)

                    Grid(undefined, this.layoutOptions) {
                      ForEach(dateItem.photoList, (item: PhotoModel, index: number) => {
                        GridItem() {
                          Stack() {
                            VideoImage({
                              photoModel: item,
                              focusId: 'photo_' + dateIndex + '_' + index,
                              eventCallback: (event) => {
                                this.onPhotoKeyEvent(event, dateIndex, index, dateItem, item);
                              }
                            })
                              .width('100%')
                            Row() {
                              // 缩略图左下角视频时长
                              Text(item != null && item.photoType == Constants.PHOTO_TYPE_VIDEO ?
                              Util.getFormattedDuration(Number(item.duration)) : '')
                                .fontSize('24lpx')
                                .fontFamily('HarmonyOS Sans')
                                .fontColor('#DBFFFFFF')
                                .lineHeight('28lpx')
                                .margin({ left: '8%', bottom: '4%' })
                              // 照片编辑状态
                              if (this.isSelecting) {
                                Image(this.selectedUriList.indexOf(item) >= 0 ? $r('app.media.p_yes') :
                                $r('app.media.p_no'))
                                  .width('24lpx')
                                  .aspectRatio(1)
                                  .margin({ right: '5%', bottom: '5%' })
                              }
                            }
                            .width('100%')
                            .justifyContent(FlexAlign.SpaceBetween)
                            .align(Alignment.BottomStart)
                          }
                          .align(Alignment.BottomEnd)
                          .borderRadius('22lpx')
                          .margin('24lpx')
                          .padding('6lpx')
                          .border({
                            width: 2,
                            color: this.focusStr === ('photo_' + dateIndex + '_' + index) ? '#fff' : Color.Transparent,
                            style: BorderStyle.Solid
                          })
                        }.onAreaChange((oldValue, newValue) => {
                          if (index === 0) {
                            this.gridItemHeight = (newValue.height as number) / 2;
                          } else {
                            this.gridItemHeight = (newValue.height as number);
                          }
                        })
                        .onHover(() => {
                          let position: PhotoPosition = PhotoPositionUtils.getPhotoPosition(dateIndex, index);
                          this.changeFocusInPhoto(position);
                        })
                      }, (item: PhotoModel) => item.photoTag)
                    }
                    .height(this.getGridHeight(dateIndex, dateItem.photoList.length))
                    .cachedCount(18)
                    .columnsTemplate('1fr '.repeat(this.gridRowCount))
                    .width('100%')
                    .scrollBar(BarState.Off)
                  }.padding({ left: '4lpx', right: '4lpx' })
                }.width('100%')
              }, (item: PhotoGroupModel) => JSON.stringify(item))
            }
            .onAreaChange((oldValue, newValue) => {
              let containerY = newValue.globalPosition.y as number;
              this.photoContainerCenterY = vp2px(containerY) + Math.floor((this.screenHeight - vp2px(containerY)) / 2);
            })
            .width('100%')
            .height('calc(100% - 320lpx)')
          }
        }
        // 菜单弹窗
        if (this.dialogFlag) {
          Flex({ justifyContent: FlexAlign.Center }) {
            Row() {
              ForEach(this.dialogList, (item: DialogModel, index: number) => {
                ListItem() {
                  Column() {
                    Image($r(item.uri))
                      .width('80lpx')
                      .aspectRatio(1)
                      .margin({ bottom: '12lpx' })
                      .id('dialog' + index)
                      .focusable(true)
                      .defaultFocus(this.dialogFlag)
                      .borderRadius('40lpx')
                      .padding('6lpx')
                      .border({
                        width: 2,
                        color: this.dialogFocusStr == ('dialog' + index) ? '#fff' : Color.Transparent, // 边框颜色
                        style: BorderStyle.Solid
                      })
                      .onKeyEvent(e => {
                        if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
                          const count = this.selectedUriList.length;
                          if (this.dialogFocusStr === 'dialog2' && count === 0) {
                            promptAction.showToast({
                              message: $r('app.string.please_choose_photo'),
                              duration: 2000
                            });
                            return;
                          } else if (this.dialogIndex !== 0) {
                            this.clickFocusBtn('dialog' + (this.dialogIndex - 1), true)
                            this.dialogIndex--;
                          }
                        }
                        if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                          if (this.dialogIndex == this.dialogList.length - 1) {
                            return
                          }
                          this.clickFocusBtn('dialog' + (this.dialogIndex + 1), true)
                          this.dialogIndex++
                        }
                        // 电脑回车键KEYCODE_ENTER
                        if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                          e.type == KeyType.Down) {
                          //Tips:这里不使用下标index是因为数组改变，所以使用focusStr
                            if (this.dialogFocusStr === 'dialog0') {
                            this.deleteFlag = true;
                            setTimeout(() => {
                              this.clickFocusBtn('delete1', true)
                            }, FOCUS_CHANGE_DELAY)
                          } else if (this.dialogFocusStr === 'dialog1') {
                            //分享逻辑
                            let res = this.getSharePhotoList()
                            this.shareAction(res)
                          } else if (this.dialogFocusStr === 'dialog2') {
                            //选择状态
                            if (this.isSelecting) {
                              let tempList: DialogModel[] = [...this.dialogList]
                              if (this.isCheckAll) {
                                tempList[0].uri = 'app.media.p_del_disabled';
                                tempList[1].uri = 'app.media.p_share_disabled';
                                tempList[2].name = $r('app.string.select_all')
                                tempList[2].uri = 'app.media.p_check_no_default'
                              } else {
                                tempList[0].uri = 'app.media.p_del_default';
                                tempList[1].uri = 'app.media.p_share_default';
                                tempList[2].name = $r('app.string.cancel_all_select')
                                tempList[2].uri = 'app.media.p_check_all_default'
                              }
                              this.dialogList = [...tempList]
                              this.selectedAll(!this.isCheckAll);
                              setTimeout(() => {
                                this.clickFocusBtn('dialog2', true)
                                this.dialogIndex = 2;
                              }, FOCUS_CHANGE_DELAY)
                            } else {
                              this.isSelecting = true;
                              this.clickFocusBtn(this.focusStr, false)
                              this.currentPhotoPosition &&
                              this.onEnterClickInPhoto(this.getPhotoModelByPosition(this.currentPhotoPosition))
                              this.dialogFlag = false;
                            }
                          }
                        }
                        //返回键
                        if (e.keyCode == KeyCode.KEYCODE_NUMPAD_2 && e.type == KeyType.Down) {
                          if (this.deviceFlag) {
                            this.getDeviceBack();
                          } else {
                            this.getDialogBack();
                          }
                        }
                      })
                      .onClick(()=>{
                        //Tips:这里不使用下标index是因为数组改变，所以使用focusStr
                        this.dialogIndex = index
                        this.clickFocusBtn('dialog' + this.dialogIndex, true)
                        const count = this.selectedUriList.length;
                        if ((this.dialogFocusStr === 'dialog0' || this.dialogFocusStr === 'dialog1') && count === 0) {
                          promptAction.showToast({
                            message: $r('app.string.please_choose_photo'),
                            duration: 2000
                          });
                          return;
                        }
                        //Tips:这里不使用下标index是因为数组改变，所以使用focusStr
                        if (this.dialogFocusStr === 'dialog0') {
                          this.deleteFlag = true;
                          setTimeout(() => {
                            this.clickFocusBtn('delete1', true)
                          }, FOCUS_CHANGE_DELAY)
                        } else if (this.dialogFocusStr === 'dialog1') {
                          //分享逻辑
                          let res = this.getSharePhotoList()
                          this.shareAction(res)
                        } else if (this.dialogFocusStr === 'dialog2') {
                          //选择状态
                          if (this.isSelecting) {
                            let tempList: DialogModel[] = [...this.dialogList]
                            if (this.isCheckAll) {
                              tempList[0].uri = 'app.media.p_del_disabled';
                              tempList[1].uri = 'app.media.p_share_disabled';
                              tempList[2].name = $r('app.string.select_all')
                              tempList[2].uri = 'app.media.p_check_no_default'
                            } else {
                              tempList[0].uri = 'app.media.p_del_default';
                              tempList[1].uri = 'app.media.p_share_default';
                              tempList[2].name = $r('app.string.cancel_all_select')
                              tempList[2].uri = 'app.media.p_check_all_default'
                            }
                            this.dialogList = [...tempList]
                            this.selectedAll(!this.isCheckAll);
                            setTimeout(() => {
                              this.clickFocusBtn('dialog2', true)
                              this.dialogIndex = 2;
                            }, FOCUS_CHANGE_DELAY)
                          } else {
                            this.isSelecting = true;
                            this.clickFocusBtn(this.focusStr, false)
                            this.currentPhotoPosition &&
                            this.onEnterClickInPhoto(this.getPhotoModelByPosition(this.currentPhotoPosition))
                            this.dialogFlag = false;
                          }
                        }
                      })
                    Text(item.name)
                      .fontSize('24lpx')
                      .height('35lpx')
                      .lineHeight('35lpx')
                      .fontColor(Color.White)
                  }
                  .width('100lpx')
                  .margin({
                    left: '4lpx',
                    right: '4lpx'
                  })
                }
                .onHover(() => {
                  this.dialogIndex = index
                  this.clickFocusBtn('dialog' + (this.dialogIndex), true)
                })
                .onTouch((event) => {
                  if (!EventUtil.isTouchEvent(event)) {
                    return
                  }
                  if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                    return;
                  }
                  const count = this.selectedUriList.length;
                  if ((this.dialogFocusStr === 'dialog0' || this.dialogFocusStr === 'dialog1') && count === 0) {
                    promptAction.showToast({
                      message: $r('app.string.please_choose_photo'),
                      duration: 2000
                    });
                    return;
                  }
                  //Tips:这里不使用下标index是因为数组改变，所以使用focusStr
                  if (this.dialogFocusStr === 'dialog0') {
                    this.deleteFlag = true;
                    setTimeout(() => {
                      this.clickFocusBtn('delete1', true)
                    }, FOCUS_CHANGE_DELAY)
                  } else if (this.dialogFocusStr === 'dialog1') {
                    //分享逻辑
                    let res = this.getSharePhotoList()
                    this.shareAction(res)
                  } else if (this.dialogFocusStr === 'dialog2') {
                    //选择状态
                    if (this.isSelecting) {
                      let tempList: DialogModel[] = [...this.dialogList]
                      if (this.isCheckAll) {
                        tempList[0].uri = 'app.media.p_del_disabled';
                        tempList[1].uri = 'app.media.p_share_disabled';
                        tempList[2].name = $r('app.string.select_all')
                        tempList[2].uri = 'app.media.p_check_no_default'
                      } else {
                        tempList[0].uri = 'app.media.p_del_default';
                        tempList[1].uri = 'app.media.p_share_default';
                        tempList[2].name = $r('app.string.cancel_all_select')
                        tempList[2].uri = 'app.media.p_check_all_default'
                      }
                      this.dialogList = [...tempList]
                      this.selectedAll(!this.isCheckAll);
                      setTimeout(() => {
                        this.clickFocusBtn('dialog2', true)
                        this.dialogIndex = 2;
                      }, FOCUS_CHANGE_DELAY)
                    } else {
                      this.isSelecting = true;
                      this.clickFocusBtn(this.focusStr, false)
                      this.currentPhotoPosition &&
                      this.onEnterClickInPhoto(this.getPhotoModelByPosition(this.currentPhotoPosition))
                      this.dialogFlag = false;
                    }
                  }
                })
              })
            }
            .backgroundColor('#CC424242')
            .borderRadius('48lpx')
            .padding({
              top: '20lpx',
              right: '26lpx',
              bottom: '20lpx',
              left: '26lpx'
            })
            .justifyContent(FlexAlign.Center)
          }
          .position({ x: '0%', y: '80%' })
        }
        // 删除弹窗
        if (this.deleteFlag) {
          Flex({ justifyContent: FlexAlign.Center }) {
            Column() {
              Column() {
                Text($r('app.string.to_delete_the_file'))
                  .fontSize('40lpx')
                  .fontColor(Color.White)
                  .width('100%')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
              }.margin({ bottom: '40lpx' })

              Row() {
                ForEach(this.deleteList, (item: string, index: number) => {
                  Column() {
                    Text(item)
                      .width('230lpx')
                      .height('72lpx')
                      .id('delete' + index)
                      .focusable(true)
                      .backgroundColor(index == 1 ? this.deleteIndex === 0 ? '#99E52424' : '#FFE52424' : '#33FFFFFF')
                      .borderRadius('200lpx')
                      .fontFamily('HarmonyOS Sans')
                      .fontSize('36lpx')
                      .textAlign(TextAlign.Center)
                      .fontColor('#DBFFFFFF')
                      .fontWeight(FontWeight.Bold)
                      .onKeyEvent(e => {
                        if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
                          if (this.deleteIndex !== 0) {
                            this.clickFocusBtn('delete' + (this.deleteIndex - 1), true)
                            this.deleteIndex--;
                          }
                        }
                        if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                          if (this.dialogIndex == this.deleteList.length - 1) {
                            return
                          }
                          this.clickFocusBtn('delete' + (this.deleteIndex + 1), true)
                          this.deleteIndex++
                        }
                        // 电脑回车键KEYCODE_ENTER
                        if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                          e.type == KeyType.Down) {
                          if (this.deleteIndex === 0) {
                            setTimeout(() => {
                              this.clickFocusBtn('dialog0', true)
                              this.getDeleteBack();
                            }, FOCUS_CHANGE_DELAY)
                          } else {
                            this.getDeleteAssets();
                          }
                        }
                      })
                      .onClick(()=>{
                        this.deleteIndex = index
                        this.clickFocusBtn('delete' + this.deleteIndex, true)
                        if (this.deleteIndex === 0) {
                          setTimeout(() => {
                            this.clickFocusBtn('dialog0', true)
                            this.getDeleteBack();
                          }, FOCUS_CHANGE_DELAY)
                        } else {
                          this.getDeleteAssets();
                        }
                      })
                  }
                  .borderRadius('200lpx')
                  .padding('6lpx')
                  .border({
                    width: 2,
                    color: this.dialogFocusStr == ('delete' + index) ? '#fff' : Color.Transparent,
                    style: BorderStyle.Solid
                  })
                  .onHover(() => {
                    this.deleteIndex = index;
                  })
                  .onTouch((event) => {
                    if (!EventUtil.isTouchEvent(event)) {
                      return;
                    }
                    if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                      return;
                    }
                    if (this.deleteIndex === 0) {
                      setTimeout(() => {
                        this.clickFocusBtn('dialog0', true)
                        this.getDeleteBack();
                      }, FOCUS_CHANGE_DELAY)
                    } else {
                      this.getDeleteAssets();
                    }
                  })
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width('640lpx')
            .height('260lpx')
            .backgroundColor('rgba(64, 64, 64, 1.0)')
            .shadow({ radius: 4, color: 'rgba(255, 255, 255, 0.25)' })
            .borderRadius('24lpx')
            .padding('48lpx')
          }
          .position({ x: '0%', y: '39%' })
        }

        // 设备列表弹窗
        if (this.deviceFlag) {
          Flex({ justifyContent: FlexAlign.Center }) {
            Column() {
              Column() {
                Text($r('app.string.select_the_sharing_device'))
                  .fontSize('40lpx')
                  .fontColor(Color.White)
                  .width('100%')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
              }.margin({ bottom: '24lpx' })

              Stack() {
                if (this.deviceList.length == 0) {
                  Column() {
                    LoadingProgress()
                      .color(Color.White)
                      .width('160lpx')
                      .height('160lpx')
                    Text($r('app.string.search_for_the_device'))
                      .fontSize('30lpx')
                      .fontColor(Color.White)
                  }
                  .height('270lpx')
                  .justifyContent(FlexAlign.Center)
                } else {
                  List({ scroller: this.scrollerShareList }) {
                    ForEach(this.deviceList, (item: wifiManager.WifiP2pDevice, index: number) => {
                      ListItem() {
                        Row() {
                          Row() {
                            Image($r('app.media.p_phone'))
                              .width('34lpx')
                              .height('36lpx')
                            Text(item.deviceName)
                              .fontFamily('HarmonyOS Sans')
                              .textAlign(TextAlign.Start)
                              .fontSize('30lpx')
                              .fontColor('#DBFFFFFF')
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: '12lpx', right: '12lpx' })
                          }

                          Image(this.deviceIndex === index ? $r('app.media.p_yes') : $r('app.media.p_no'))
                            .id('device' + index)
                            .focusable(true)
                            .width('34lpx')
                            .height('36lpx')
                            .onKeyEvent(e => {
                              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                                if (this.deviceIndex !== 0) {
                                  this.scrollerShareList.scrollToIndex(this.deviceIndex - 1, true, ScrollAlign.AUTO)
                                  this.clickFocusBtn('device' + (this.deviceIndex - 1), true)
                                  this.deviceIndex--;
                                }
                              }
                              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                                if (this.deviceIndex == this.deviceList.length - 1) {
                                  return
                                }
                                this.scrollerShareList.scrollToIndex(this.deviceIndex + 1, true, ScrollAlign.AUTO)
                                this.clickFocusBtn('device' + (this.deviceIndex + 1), true)
                                this.deviceIndex++
                              }
                              //返回键
                              if (e.keyCode == KeyCode.KEYCODE_NUMPAD_2 && e.type == KeyType.Down) {
                                this.getDeviceBack();
                              }
                            })
                        }
                        .width('440lpx')
                        .borderRadius('16lpx')
                        .padding({
                          top: '18lpx',
                          right: '24lpx',
                          bottom: '18lpx',
                          left: '24lpx'
                        })
                        .margin({ bottom: '12lpx' })
                        .backgroundColor('rgba(255, 255, 255, 0.1)')
                        .justifyContent(FlexAlign.SpaceBetween)
                        .width('100%')
                        .border({
                          width: 2,
                          color: this.dialogFocusStr == ('device' + index) ? '#fff' : Color.Transparent,
                          style: BorderStyle.Solid
                        })
                      }
                    })
                  }
                  .scrollBar(BarState.Off)
                  .height('270lpx')
                }
              }
            }
            .width('640lpx')
            .backgroundColor('rgba(64, 64, 64, 1.0)')
            .shadow({ radius: 4, color: 'rgba(255, 255, 255, 0.25)' })
            .borderRadius('24lpx')
            .padding('48lpx')
          }
          .position({ x: '0%', y: '30%' })
        }
        // 接收弹窗
        if (this.receiveFlag) {
          Flex({ justifyContent: FlexAlign.Center }) {
            Column() {
              Column() {
                Text('1' + this.typeName + '接收中，共' + this.fullSize + ',是否接收此文件？')
                  .fontSize('36lpx')
                  .fontColor(Color.White)
                  .width('100%')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
              }.margin({ bottom: '40lpx' })

              Row() {
                ForEach(this.receiveList, (item: string, index: number) => {
                  Column() {
                    Text(item)
                      .width('230lpx')
                      .height('72lpx')
                      .id('receive' + index)
                      .focusable(true)
                      .backgroundColor(index == 1 ? this.receiveIndex === 0 ? '#99E52424' : '#FFE52424' : '#33FFFFFF')
                      .borderRadius('200lpx')
                      .fontFamily('HarmonyOS Sans')
                      .fontSize('36lpx')
                      .textAlign(TextAlign.Center)
                      .fontColor('#DBFFFFFF')
                      .fontWeight(FontWeight.Bold)
                      .onKeyEvent(e => {
                        if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
                          if (this.receiveIndex !== 0) {
                            this.receiveIndex--;
                            this.clickFocusBtn('receive' + this.receiveIndex, true)
                          }
                        }
                        if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                          if (this.receiveIndex == this.receiveList.length - 1) {
                            return
                          }
                          this.receiveIndex++
                          this.clickFocusBtn('receive' + this.receiveIndex, true)
                        }
                        // 电脑回车键KEYCODE_ENTER
                        if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                          e.type == KeyType.Down) {
                        }
                      })
                      .onClick(()=>{
                        if (this.receiveIndex === 0) {
                          setTimeout(() => {
                            this.clickFocusBtn('dialog0', true)
                            this.getDeleteBack();
                          }, FOCUS_CHANGE_DELAY)
                        } else {
                          this.getDeleteAssets();
                        }
                      })
                  }
                  .borderRadius('200lpx')
                  .padding('6lpx')
                  .border({
                    width: 2,
                    color: this.dialogFocusStr == ('receive' + index) ? '#fff' : Color.Transparent,
                    style: BorderStyle.Solid
                  })
                  .onHover(() => {
                    this.receiveIndex = index;
                  })
                  .onTouch((event) => {
                    if (!EventUtil.isTouchEvent(event)) {
                      return;
                    }
                    if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                      return;
                    }
                    if (this.receiveIndex === 0) {
                      setTimeout(() => {
                        this.clickFocusBtn('dialog0', true)
                        this.getDeleteBack();
                      }, FOCUS_CHANGE_DELAY)
                    } else {
                      this.getDeleteAssets();
                    }
                  })
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width('640lpx')
            .height('260lpx')
            .backgroundColor('rgba(64, 64, 64, 1.0)')
            .shadow({ radius: 4, color: 'rgba(255, 255, 255, 0.25)' })
            .borderRadius('24lpx')
            .padding('48lpx')
          }
          .position({ x: '0%', y: '39%' })
        }
      } else
        if (this.chooseIndex === 1) {
        if (this.subTypeModels.length === 0) {
          Text($r('app.string.no_data'))
            .fontColor(Color.White)
            .fontSize('34lpx')
            .size({ height: `calc(100% - 520lpx)` })
        } else {
          Row() {
            Grid() {
              ForEach(this.subTypeModels, (item: AlbumModel | undefined, index: number) => {
                if (item && (item.count > 0 || item?.type === AlbumType.NAS_SESSION)) {
                  GridItem() {
                    Column() {
                      Stack({ alignContent: Alignment.Bottom }) {
                        Image(item.cover)
                          .id('album' + index)
                          .focusable(true)
                          .borderRadius('18lpx')
                          .width('100%')
                          .aspectRatio(1)
                          .shadow({ radius: 1, color: Color.Gray })
                          .backgroundImageSize({ width: '100%', height: '100%' })
                          .focusable(true)
                          .autoResize(false)
                          .interpolation(ImageInterpolation.Medium)
                          .align(Alignment.Top)
                          .onKeyEvent(e => {
                            e?.stopPropagation()
                            if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
                              if (index === 0) {
                                this.clickFocusBtn('menu1', false)
                              } else {
                                this.nextAlbumClick(this.albumIndex, 'left')
                              }
                            }
                            if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                              if (this.albumIndex == this.subTypeModels.length - 1) {
                                return
                              }
                              this.nextAlbumClick(this.albumIndex, 'right')
                            }
                            if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                              if (this.albumIndex + this.albumGridRowCount > this.subTypeModels.length - 1) {
                                return;
                              }
                              this.nextAlbumClick(this.albumIndex, 'down')
                            }
                            if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                              if (index < this.albumGridRowCount) {
                                this.clickFocusBtn('menu1', false)
                              } else {
                                this.nextAlbumClick(this.albumIndex, 'up')
                              }
                            }
                            if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                              e.type == KeyType.Down) {
                              if (item.type === AlbumType.NAS_SESSION) {
                                router.pushUrl({
                                  url: 'pages/NasSessionPage'
                                })
                              } else if (item.type === AlbumType.TRASH) {
                                router.pushUrl({
                                  url: 'pages/PhotoDeleteList'
                                })
                              } else {
                                router.pushUrl({
                                  url: 'pages/PhotoList',
                                  params: {
                                    photoTitle: item.name,
                                    photoType: item.type
                                  }
                                })
                              }
                            }
                          })
                          .onFocus(() => {
                            this.albumIndex = index
                          })
                          .onHover(() => {
                            this.clickFocusBtn('album' + index, false)
                          })
                          .onTouch((event) => {
                            if (!EventUtil.isTouchEvent(event)) {
                              return;
                            }
                            if (event.sourceTool !== SourceTool.Pen &&
                              event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                              return;
                            }
                            if (event.type == TouchType.Up) {
                            }
                          })
                          .onClick(()=>{
                            if (item.type === AlbumType.NAS_SESSION) {
                              router.pushUrl({
                                url: 'pages/NasSessionPage'
                              })
                            } else if (item.type === AlbumType.TRASH) {
                              router.pushUrl({
                                url: 'pages/PhotoDeleteList'
                              })
                            } else {
                              router.pushUrl({
                                url: 'pages/PhotoList',
                                params: {
                                  photoTitle: item.name,
                                  photoType: item.type
                                }
                              })
                            }
                          })
                        Column() {
                          Text(item.name)
                            .fontFamily('HarmonyOS Sans')
                            .width('100%')
                            .height('32lpx')
                            .fontWeight(500)
                            .fontColor('#DBFFFFFF')
                            .fontSize('32lpx')
                            .margin({ bottom: '12lpx' })
                          Text(item.count.toString())
                            .fontFamily('HarmonyOS Sans')
                            .width('100%')
                            .height('32lpx')
                            .fontWeight(500)
                            .fontColor('#DBFFFFFF')
                            .fontSize('32lpx')
                            .margin({ bottom: '10%' })
                        }
                        .backgroundImage($r('app.media.mask'))
                        .width('100%')
                        .align(Alignment.Bottom)
                        .padding({ top: '46lpx', left: '10%' })
                      }
                      .width('100%')
                      .borderRadius('18lpx')
                      .aspectRatio(1)
                    }
                    .borderRadius('22lpx')
                    .margin('24lpx')
                    .padding('6lpx')
                    .border({
                      width: 2,
                      color: this.focusStr == ('album' + index) ? '#fff' : Color.Transparent, // 边框颜色
                      style: BorderStyle.Solid
                    })
                  }
                  .backgroundImageSize({ width: '100%', height: '100%' })
                }
              })
            }
            .columnsTemplate('1fr '.repeat(this.albumGridRowCount))
            .padding({ left: '4lpx', right: '4lpx' })
            .width('100%')
          }
        }
      } else {
        // 分布式图库
        DistributedPhotoView({ focusStr: this.focusStr }).width('100%').layoutWeight(1);

        if (this.showToDfsDialog) {
          Flex({ justifyContent: FlexAlign.Center }) {
            Column() {
              Column() {
                Text($r('app.string.dialog_title_to_distributed_device'))
                  .fontSize('40lpx')
                  .fontColor(Color.White)
                  .width('100%')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
              }.margin({ bottom: '40lpx' })

              Row() {
                Column() {
                  Text($r('app.string.cancel'))
                    .width('230lpx')
                    .height('72lpx')
                    .id('dfs_dialog_cancel')
                    .focusable(true)
                    .backgroundColor('#33FFFFFF')
                    .borderRadius('200lpx')
                    .fontFamily('HarmonyOS Sans')
                    .fontSize('36lpx')
                    .textAlign(TextAlign.Center)
                    .fontColor('#DBFFFFFF')
                    .fontWeight(FontWeight.Bold)
                    .onKeyEvent(e => {
                      if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                        this.clickFocusBtn('dfs_dialog_confirm', true);
                      }
                      // 电脑回车键KEYCODE_ENTER
                      if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                        e.type == KeyType.Down) {
                      }
                    })
                    .onClick(()=>{
                      this.dismissToDfsDialog();
                    })
                }
                .borderRadius('200lpx')
                .padding('6lpx')
                .border({
                  width: 2,
                  color: this.dialogFocusStr === 'dfs_dialog_cancel' ? '#fff' : Color.Transparent,
                  style: BorderStyle.Solid
                })

                Column() {
                  Text($r('app.string.confirm'))
                    .width('230lpx')
                    .height('72lpx')
                    .id('dfs_dialog_confirm')
                    .focusable(true)
                    .backgroundColor('#33FFFFFF')
                    .borderRadius('200lpx')
                    .fontFamily('HarmonyOS Sans')
                    .fontSize('36lpx')
                    .textAlign(TextAlign.Center)
                    .fontColor('#DBFFFFFF')
                    .fontWeight(FontWeight.Bold)
                    .onKeyEvent(e => {
                      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
                        this.clickFocusBtn('dfs_dialog_cancel', true);
                      }
                      // 电脑回车键KEYCODE_ENTER
                      if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                        e.type == KeyType.Down) {
                      }
                    })
                    .onClick(()=>{
                      this.toDfsDevicePage();
                    })
                }
                .borderRadius('200lpx')
                .padding('6lpx')
                .border({
                  width: 2,
                  color: this.dialogFocusStr === 'dfs_dialog_confirm' ? '#fff' : Color.Transparent,
                  style: BorderStyle.Solid
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width('640lpx')
            .height('260lpx')
            .backgroundColor('rgba(64, 64, 64 , 1)')
            .shadow({ radius: 4, color: 'rgba(255, 255, 255, 0.25)' })
            .borderRadius('24lpx')
            .padding('48lpx')
          }
          .position({ x: '0%', y: '39%' })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.main_color'))
    .padding({ left: '63lpx', right: '63lpx' })
    .onTouch((event) => {
      EventUtil.isTouchEvent(event);
    })
  }

  focusFirstAlbum() {
    let index = this.subTypeModels.findIndex((value) => {
      return (value && value.count > 0)
    })
    this.clickFocusBtn('album' + index, false)
  }

  nextAlbumClick(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down') {
    const index = this.getNextAlbum(currentIndex, direction)
    if (index !== -1) {
      this.clickFocusBtn('album' + index, false)
    }
  }

  getNextAlbum(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down'): number {
    const indexs: number[] = []
    let trueIndex = 0
    this.subTypeModels.forEach((value, index) => {
      if (value && (value.count > 0 || value.type == AlbumType.NAS_SESSION)) {
        indexs.push(index)
        if (index === currentIndex) {
          trueIndex = indexs.length - 1
        }
      }
    })

    let newIndex = -1
    if (direction === 'left' && trueIndex > 0) {
      newIndex = indexs[trueIndex - 1]
    }
    if (direction === 'right' && trueIndex < indexs.length - 1) {
      newIndex = indexs[trueIndex + 1]
    }
    if (direction === 'up' && trueIndex > FIRST_ROW_MAX_INDEX) {
      newIndex = indexs[trueIndex - FIRST_ROW_MAX_INDEX]
    }
    if (direction === 'down' && trueIndex < indexs.length - FIRST_ROW_MAX_INDEX) {
      newIndex = indexs[trueIndex + FIRST_ROW_MAX_INDEX]
    }
    return newIndex
  }
}
