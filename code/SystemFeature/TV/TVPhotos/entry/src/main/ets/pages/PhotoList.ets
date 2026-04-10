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
import { AlbumModel, AlbumType, DialogModel, PhotoModel } from '../models/PhotoModel';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import promptAction from '@ohos.promptAction';
import { Util } from '../common/Util';
import { PhotoDataModel, PhotoDataSource } from '../models/IDataSource';
import { Constants } from '../common/Constants';
import { inputConsumer } from '@kit.InputKit';
import wifiManager from '@ohos.wifiManager';
import { WifiDeviceManager } from '../common/WifiManager';
import Logger from '../common/Logger';
import photoManager from '../manager/PhotoManager';
import { VideoImage } from './components/VideoImage';
import { NasImage } from './components/NasImage';
import { DirectoryEntry, smbUtil } from 'smbProtocol';
import nasSessionManager from '../smaba/NasSessionManager';
import { EventUtil } from '../common/EventUtil';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import utd from '@ohos.data.uniformTypeDescriptor';
import { common, launcherBundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { getToVideoApp, isAppInstalled } from './Index';

export enum ShareType {
  SAVE_TO_MEDIA_ASSET = 1,
  SAVE_AS_FILE = 2,
  SAVE_AS_FOLDER = 10,
}

interface ShareData {
  utd: string
  title: string
  uri: string
}

interface shareWant {
  type: ShareType
  data: ShareData[]
}

const TAG = 'PhotoList';
const FOCUS_CHANGE_DELAY = 100;
const DIALOG_INDEX_1 = 1
const DIALOG_INDEX_2 = 2
const SHARE_BUNDLE_NAME: string = 'com.ohos.oneconnect.share';
const SHARE_ABILITY_NAME: string = 'ServiceExtAbility';
const SHARE_MAX_SIZE: number = 1024 * 1024 * 1024;

@Entry
@Component
struct PhotoList {
  @State params: object = router.getParams() as Record<string, number>;
  @State photoTitle: ResourceStr = this.params['photoTitle'];
  @State photoType: AlbumType = this.params['photoType'];
  @State photoList: PhotoDataSource = new PhotoDataSource();
  @State photoListSize: number = 0
  @State pictureIndex: number = 0;
  @State pictureFlag: boolean = false;
  @State isPhotoData: boolean = false;
  private gridRowCount: number = 6;
  @State focusPhotoStr: string = 'picture0';
  @State focusDialogStr: string = '';
  private scroller: Scroller = new Scroller();
  @State dialogIndex: number = 0;
  @State pictureChooseFlags: boolean[] = [];
  @State isCheckAll: boolean = false;
  @State dialogList: DialogModel[] = [{ uri: 'app.media.p_del_disabled', name: $r('app.string.delete') }, {
    uri: 'app.media.p_share_disabled',
    name: $r('app.string.share')
  }, {
    uri: 'app.media.p_check_default',
    name: $r('app.string.choose'),
  }];
  @State dialogFlag: boolean = false;
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
  private photoObserver = (photos: PhotoModel[], albumModel: AlbumModel) => {
    this.photoList.setData(photos);
    this.pictureChooseFlags = new Array(this.photoList.totalCount()).fill(false);
    this.photoListSize = photos.length;
  }
  private nasImageObserver = (files: DirectoryEntry[]) => {
    this.photoList.setData(files);
    this.pictureChooseFlags = new Array(this.photoList.totalCount()).fill(false);
    this.photoListSize = files.length;
  }
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
    if (!this.dialogFlag) {
      this.getMenuClick()
    }
  }

  aboutToAppear(): void {
  }

  onPageShow(): void {
    try {
      inputConsumer.on('key', this.keyOptions, this.keyCallback);
      inputConsumer.on('key', this.keyOptionsMenu, this.keyCallback);
    } catch (error) {
      Logger.error(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
    if (this.photoType === AlbumType.NAS_SESSION) {
      nasSessionManager.registerFileChangeCallback(this.photoTitle as string, this.nasImageObserver)
    } else {
      photoManager.getLoader(this.photoType)?.registerChangeCallback(this.photoObserver)
    }
  }

  onPageHide(): void {
    inputConsumer.off('key', this.keyOptions, this.keyCallback);
    inputConsumer.off('key', this.keyOptionsMenu, this.keyCallback);
    if (this.photoType === AlbumType.NAS_SESSION) {
      nasSessionManager.unRegisterFileChangeCallback(this.photoTitle as string, this.nasImageObserver)
    } else {
      photoManager.getLoader(this.photoType)?.unRegisterChangeCallback(this.photoObserver)
    }
  }

  onBackPress(): boolean | void {
    return this.allBackFun()
  }

  // 统一返回封装
  allBackFun(): boolean | void {
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
    if (this.pictureFlag) {
      this.getPhotoBack();
      return true
    }
  }

  changeDevice() {
    if (this.deviceList.length == 0) {
      this.currentName = ''
    }
  }

  //批量删除相册
  async getDeleteAssets(uris: PhotoDataModel[]) {
    if (uris.length === 0) {
      return
    }
    this.isPhotoData = false;
    try {
      if (this.isPhotoModel(uris[0])) {
        await photoManager.delete(this.photoType, uris as PhotoModel[])
      } else {
        await nasSessionManager.deleteImage(this.photoTitle as string, uris as DirectoryEntry[])
        Logger.warn(TAG, 'TODO delete nas images')
      }
      this.getPhotoBack();
      this.deleteFlag = false;
      this.deleteIndex = 1;
      this.getDialogBack();
      promptAction.showToast({
        message: $r('app.string.delete_success')
      });
    } catch (e) {
      promptAction.showToast({
        message: $r('app.string.delete_error')
      });
    }

  }

  shareAction(items:PhotoModel[]){
    Logger.info(TAG, `share file length is ${items.length}`);
    promptAction.showToast({
      message: '该功能开发中，敬请期待'
    })
  }
  //获取选择之后的照片uri
  getPhotoUris(): PhotoDataModel[] {
    let uris: PhotoDataModel[] = [];
    this.pictureChooseFlags.forEach((item, index) => {
      if (item === true) {
        uris.push(this.photoList.getData(index));
      }
    })
    return uris;
  }

  //弹出框的返回
  getDialogBack() {
    this.dialogFlag = false;
    setTimeout(() => {
      this.clickFocusBtn(this.focusPhotoStr, false)
    }, FOCUS_CHANGE_DELAY)
  }

  //编辑状态的照片返回
  getPhotoBack() {
    this.pictureFlag = false;
    this.isCheckAll = false;
    this.pictureChooseFlags = this.pictureChooseFlags.fill(false)
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
      this.clickFocusBtn('dialog0', true);
    }, FOCUS_CHANGE_DELAY)
  }

  //设备弹出框的返回
  getDeviceBack() {
    this.deviceFlag = false;
    setTimeout(() => {
      this.clickFocusBtn('dialog1', true);
    }, FOCUS_CHANGE_DELAY)
  }

  //获取分享选择之后的照片List
  getSharePhotoList(): PhotoDataModel[] {
    let sharePhotoList: PhotoDataModel[] = [];
    this.pictureChooseFlags.forEach((item, index) => {
      if (item === true) {
        sharePhotoList.push(this.photoList.getData(index));
      }
    })
    return sharePhotoList;
  }

  getMenuClick() {
    let tempList: DialogModel[] = [...this.dialogList]
    if (this.pictureFlag && this.isCheckAll) {
      tempList[2].name = $r('app.string.cancel_all_select')
      tempList[2].uri = 'app.media.p_check_all_default'
    } else if (this.pictureFlag && !this.isCheckAll) {
      tempList[2].name = $r('app.string.select_all')
      tempList[2].uri = 'app.media.p_check_no_default'
    } else {
      tempList[2].name = $r('app.string.choose')
      tempList[2].uri = 'app.media.p_check_default'
    }
    // 判断删除按钮和分享按钮
    const count = this.pictureChooseFlags.filter(item => item).length;
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
    }, FOCUS_CHANGE_DELAY)
  }

  defaultFocusBtn() {
    setTimeout(() => {
      this.clickFocusBtn(this.focusPhotoStr, false);
    }, 50)
  }

  clickFocusBtn(str: string, inDialog: boolean) {
    const isSuccess = focusControl.requestFocus(str);
    if (isSuccess) {
      if (inDialog) {
        this.focusDialogStr = str;
      } else {
        this.focusPhotoStr = str;
      }
    } else {
      Logger.error(TAG, `requestFocus is failed , focusStr = ${str}`);
    }
    return isSuccess;
  }

  build() {
    Column() {
      Row() {
        Row() {
          Text(this.photoTitle)
            .fontFamily('HarmonyOS Sans')
            .fontColor(Color.White)
            .fontSize('64lpx')
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: '33lpx',
        right: '33lpx',
        top: '48lpx',
        bottom: '56lpx'
      })

      if (this.photoListSize === 0) {
        Text($r('app.string.no_data'))
          .fontColor(Color.White)
          .fontSize('34lpx')
          .size({ height: `calc(100% - 520lpx)` })
      } else {
        Row() {
          Grid(this.scroller) {
            LazyForEach(this.photoList, (item: PhotoDataModel, index: number) => {
              GridItem() {
                Column() {
                  Stack() {
                    if (this.isPhotoModel(item)) {
                      VideoImage({
                        photoModel: item as PhotoModel,
                        focusId: 'picture' + index,
                        defaultInFocus: this.focusPhotoStr === 'picture' + index,
                        eventCallback: (event) => {
                          this.onItemKeyEvent(event, index)
                        }
                      })
                        .width('100%')
                        .onHover(() => {
                          this.clickFocusBtn('picture' + index, false)
                        })
                    } else {
                      NasImage({
                        host: (this.photoTitle as string),
                        imageFile: item as DirectoryEntry,
                        focusId: 'picture' + index,
                        defaultInFocus: this.focusPhotoStr === 'picture' + index,
                        eventCallback: (event) => {
                          this.onItemKeyEvent(event, index)
                        }
                      })
                        .width('100%')
                        .onHover(() => {
                          this.clickFocusBtn('picture' + index, false)
                        })
                    }
                    Row() {
                      if (this.isPhotoModel(item)) {
                        // 缩略图左下角视频时长
                        Text(item != null && (item as PhotoModel).photoType == Constants.PHOTO_TYPE_VIDEO ?
                        Util.getFormattedDuration(Number((item as PhotoModel).duration)) : '')
                          .fontSize('24lpx')
                          .fontFamily('HarmonyOS Sans')
                          .fontColor('#DBFFFFFF')
                          .lineHeight('28lpx')
                          .margin({ left: '8%', bottom: '4%' })
                      }
                      // 照片编辑状态
                      if (this.pictureFlag) {
                        Image(this.pictureChooseFlags[index] ? $r('app.media.p_yes') : $r('app.media.p_no'))
                          .width('24lpx')
                          .aspectRatio(1)
                          .margin({ right: '5%', bottom: '5%' })
                      }
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.SpaceBetween)
                    .align(Alignment.BottomStart)
                  }.align(Alignment.BottomEnd)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .borderRadius('22lpx')
                .margin('24lpx')
                .padding('6lpx')
                .border({
                  width: 2,
                  color: this.focusPhotoStr == ('picture' + index) ? '#fff' : Color.Transparent,
                  style: BorderStyle.Solid
                })
              }
              .onAppear(()=>{
                if (index ==  0) {
                  this.clickFocusBtn(this.focusPhotoStr, false)
                }
              })
            }, (item: string, index: number) => (JSON.stringify(item, smbUtil.bigIntReplacer) + index))
          }
          .onScrollStop(() => {
            setTimeout(() => {
              this.clickFocusBtn(this.focusPhotoStr, false);
            }, FOCUS_CHANGE_DELAY)
          })
          .cachedCount(18)
          .columnsTemplate('1fr '.repeat(this.gridRowCount))
          .width('100%')
          .scrollBar(BarState.Off)
          .padding({ left: '4lpx', right: '4lpx' })
          .size({ height: `calc(100% - 210lpx)` })
        }
      }

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
                      color: this.focusDialogStr == ('dialog' + index) ? '#fff' : Color.Transparent, // 边框颜色
                      style: BorderStyle.Solid
                    })
                    .onKeyEvent(e => {
                      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
                        const count = this.pictureChooseFlags.filter(item => item).length;
                        if (this.focusDialogStr === 'dialog2' && count === 0) {
                          promptAction.showToast({
                            message: $r('app.string.please_choose_photo')
                          });
                          return;
                        } else if (this.dialogIndex !== 0) {
                          const step = this.photoType === AlbumType.NAS_SESSION ? 2 : 1
                          this.clickFocusBtn('dialog' + (this.dialogIndex - step), true)
                          this.dialogIndex -= step;
                        }
                      }
                      if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                        if (this.dialogIndex == this.dialogList.length - 1) {
                          return
                        }
                        const step = this.photoType === AlbumType.NAS_SESSION ? 2 : 1
                        this.clickFocusBtn('dialog' + (this.dialogIndex + step), true)
                        this.dialogIndex += step
                      }
                      // 电脑回车键KEYCODE_ENTER
                      if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                        e.type == KeyType.Down) {
                      }
                      //返回键
                      if (e.keyCode == KeyCode.KEYCODE_NUMPAD_2 && e.type == KeyType.Down) {
                        this.getDialogBack();
                      }
                    })
                    .onClick(()=>{
                      this.dialogIndex = index
                      this.clickFocusBtn('dialog' + this.dialogIndex, true)
                      if (this.focusDialogStr === 'dialog0') {
                        this.deleteFlag = true;
                        setTimeout(() => {
                          this.clickFocusBtn('delete1', true)
                        }, 50)
                      } else if (this.focusDialogStr === 'dialog1') {
                        //分享逻辑
                        let res = this.getSharePhotoList() as PhotoModel[]
                        this.shareAction(res)
                      } else if (this.focusDialogStr === 'dialog2') {
                        //选择状态
                        if (this.pictureFlag) {
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
                          this.pictureChooseFlags =
                            this.isCheckAll ? new Array(this.photoList.totalCount()).fill(false) :
                              new Array(this.photoList.totalCount()).fill(true)
                          this.isCheckAll = !this.isCheckAll;
                          setTimeout(() => {
                            this.clickFocusBtn('dialog2', true)
                            this.dialogIndex = 2;
                          }, 50)
                        } else {
                          this.dialogFlag = false;
                          this.pictureFlag = true;
                          this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO);
                          setTimeout(() => {
                            this.clickFocusBtn(this.focusPhotoStr, false)
                            this.selectPhoto(this.pictureIndex)
                          }, FOCUS_CHANGE_DELAY)
                        }
                      }
                    })
                    .onHover(() => {
                      this.clickFocusBtn('dialog' + index, true)
                    })
                    .onTouch((event) => {
                      if (!EventUtil.isTouchEvent(event)) {
                        return
                      }
                      if (event.sourceTool !== SourceTool.Pen &&
                        event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                        return;
                      }
                      //Tips:这里不使用下标index是因为数组改变，所以使用focusPhotoStr
                      if (this.focusDialogStr === 'dialog0') {
                        this.deleteFlag = true;
                        setTimeout(() => {
                          this.clickFocusBtn('delete1', true)
                        }, 50)
                      } else if (this.focusDialogStr === 'dialog1') {
                        //分享逻辑
                        let res = this.getSharePhotoList() as PhotoModel[]
                        this.shareAction(res)
                      } else if (this.focusDialogStr === 'dialog2') {

                        //选择状态
                        if (this.pictureFlag) {
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
                          this.pictureChooseFlags =
                            this.isCheckAll ? new Array(this.photoList.totalCount()).fill(false) :
                            new Array(this.photoList.totalCount()).fill(true)
                          this.isCheckAll = !this.isCheckAll;
                          setTimeout(() => {
                            this.clickFocusBtn('dialog2', true)
                            this.dialogIndex = 2;
                          }, 50)
                        } else {
                          this.dialogFlag = false;
                          this.pictureFlag = true;
                          this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO);
                          setTimeout(() => {
                            this.clickFocusBtn(this.focusPhotoStr, false)
                            this.selectPhoto(this.pictureIndex)
                          }, FOCUS_CHANGE_DELAY)
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
              .visibility(this.photoType === AlbumType.NAS_SESSION && index === 1 ? Visibility.None :
              Visibility.Visible)
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
        .position({ x: '0%', y: '75%' })
      }

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
                        if (this.deleteIndex == this.deleteList.length - 1) {
                          return
                        }
                        this.clickFocusBtn('delete' + (this.deleteIndex + 1), true)
                        this.deleteIndex++
                      }
                      // 电脑回车键KEYCODE_ENTER
                      if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                        e.type == KeyType.Down) {
                      }
                    })
                    .onClick(()=>{
                      this.deleteIndex = index
                      this.clickFocusBtn('delete' + this.deleteIndex, true)
                      if (this.deleteIndex === 0) {
                        setTimeout(() => {
                          this.clickFocusBtn('dialog0', true)
                          this.getDeleteBack();
                        }, 50)
                      } else {
                        let uris: PhotoDataModel[] = this.getPhotoUris();
                        this.getDeleteAssets(uris);
                      }
                    })
                }
                .borderRadius('200lpx')
                .padding('6lpx')
                .border({
                  width: 2,
                  color: this.focusDialogStr == ('delete' + index) ? '#fff' : Color.Transparent,
                  style: BorderStyle.Solid
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
                            // 电脑回车键KEYCODE_ENTER
                            if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                              e.type == KeyType.Down) {
                            }
                            //返回键
                            if (e.keyCode == KeyCode.KEYCODE_NUMPAD_2 && e.type == KeyType.Down) {
                              this.getDeviceBack();
                            }
                          })
                          .onClick(()=>{
                            if (WifiDeviceManager.getInstance().isGroup) {
                              WifiDeviceManager.getInstance().connectTcpServer()
                            } else {
                              WifiDeviceManager.getInstance().connectP2pDevice(item)
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
                        color: this.focusDialogStr == ('device' + index) ? '#fff' : Color.Transparent,
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
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.main_color'))
    .padding({ left: '63lpx', right: '63lpx' })
  }

  selectPhoto(index: number) {
    this.pictureChooseFlags[index] = !this.pictureChooseFlags[index];
    const count = this.pictureChooseFlags.filter(item => item).length;
    this.isCheckAll = count === this.photoList.totalCount() ? true : false;
  }

  onItemKeyEvent(e: KeyEvent, index: number) {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
      if (this.pictureIndex !== 0) {
        this.pictureIndex--;
        this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO)
        this.clickFocusBtn('picture' + this.pictureIndex, false)
      }
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
      if (this.pictureIndex == this.photoList.totalCount() - 1) {
        return;
      }
      this.pictureIndex++;
      this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO)
      this.clickFocusBtn('picture' + this.pictureIndex, false)
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
      if (this.pictureIndex + this.gridRowCount > this.photoList.totalCount() - 1) {
        return;
      }
      this.pictureIndex += this.gridRowCount;
      this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO)
      this.clickFocusBtn('picture' + this.pictureIndex, false)
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
      if (this.pictureIndex >= this.gridRowCount) {
        this.pictureIndex -= this.gridRowCount;
        this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO)
        this.clickFocusBtn('picture' + this.pictureIndex, false)
      }
    }
    // 电脑回车键KEYCODE_ENTER
    if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
      e.type == KeyType.Down) {
      if (this.pictureFlag) {
        this.selectPhoto(index)
      } else {
        let host = this.isPhotoModel(this.photoList.getData(index)) ? undefined : (this.photoTitle as string);
        if (host) {
          let data = this.photoList.getData(index) as PhotoModel
          if (data && data.photoType === Constants.PHOTO_TYPE_VIDEO) {
            if (isAppInstalled()) {
              getToVideoApp(data.uri, data.displayName, data.thumbnail);
            }
          } else {
            router.pushUrl({
              url: 'pages/PhotoWatch',
              params: {
                photoIndex: index,
                nasHost: host
              }
            })
          }
        } else {
          let data = this.photoList.getData(index) as PhotoModel
          if (data && data.photoType === Constants.PHOTO_TYPE_VIDEO) {
            if (isAppInstalled()) {
              getToVideoApp(data.uri, data.displayName, data.thumbnail);
            }
          } else {
            router.pushUrl({
              url: 'pages/PhotoWatch',
              params: {
                photoIndex: index,
                photoList: this.photoList.getAllData()
              }
            })
          }
        }
      }
    }
    // 数字1KEYCODE_NUMPAD_1
    if ((e.keyCode == KeyCode.KEYCODE_MENU || e.keyCode == KeyCode.KEYCODE_NUMPAD_1) &&
      e.type == KeyType.Down) {
      let tempList: DialogModel[] = [...this.dialogList]
      if (this.pictureFlag && this.isCheckAll) {
        tempList[DIALOG_INDEX_2].name = $r('app.string.cancel_all_select')
        tempList[DIALOG_INDEX_2].uri = 'app.media.p_check_all_default'
      } else if (this.pictureFlag && !this.isCheckAll) {
        tempList[DIALOG_INDEX_2].name = $r('app.string.select_all')
        tempList[DIALOG_INDEX_2].uri = 'app.media.p_check_no_default'
      } else {
        tempList[DIALOG_INDEX_2].name = $r('app.string.choose')
        tempList[DIALOG_INDEX_2].uri = 'app.media.p_check_default'
      }
      // 判断删除按钮和分享按钮
      const count = this.pictureChooseFlags.filter(item => item).length;
      if (count > 0) {
        tempList[0].uri = 'app.media.p_del_default';
        tempList[1].uri = 'app.media.p_share_default';
      } else {
        tempList[0].uri = 'app.media.p_del_disabled';
        tempList[DIALOG_INDEX_1].uri = 'app.media.p_share_disabled';
      }
      this.dialogList = [...tempList];
      this.dialogFlag = true;
      setTimeout(() => {
        this.clickFocusBtn('dialog2', true); //默认在选择焦点
        this.dialogIndex = DIALOG_INDEX_2;
      }, FOCUS_CHANGE_DELAY)
    }
    //返回键KEYCODE_BACK
    if (e.keyCode == KeyCode.KEYCODE_NUMPAD_2 && e.type == KeyType.Down) {
      this.getPhotoBack();
    }
  }

  private isPhotoModel(model: PhotoDataModel) {
    return Object.getOwnPropertyNames(model).includes('uri')
  }
}
