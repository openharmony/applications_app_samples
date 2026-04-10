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

import { Constants } from '../../common/Constants';
import { AlbumModel, AlbumType, PhotoModel } from '../../models/PhotoModel';
import { inputConsumer, inputEventClient, KeyCode } from '@kit.InputKit';
import { Util } from '../../common/Util';
import { PhotoDataModel, PhotoDataSource } from '../../models/IDataSource';
import photoManager from '../../manager/PhotoManager';
import Logger from '../../common/Logger';
import { promptAction } from '@kit.ArkUI';
import { createRegister } from '../../manager/ChangeRegister';
import { PickImageVideo } from './PickImageVideo';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'ThirdSelectPhotoGridBase';

const keyOptions: inputConsumer.KeyOptions = {
  preKeys: [],
  finalKey: KeyCode.KEYCODE_MENU,
  isFinalKeyDown: true,
  finalKeyDownDuration: 0,
};

const DELAY_TIME = 1000;

@Component
export struct ThirdSelectPhotoGridBase {
  @Link isFirstEnter: boolean;
  @State cancelPreviewFocus: boolean = false;
  @State isFocusable: boolean = true;
  @StorageProp('pickMaxSelectCount')
  maxSelectCount: number = 5;
  private videoController: VideoController = new VideoController();
  @State isVideoPlaying: boolean = false;
  @State focusStr: string = '';
  @State blurAlbumStr: string = 'pickerAlbum_0';
  @State selectCount: number = 0;
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @State isOriginalCheck: boolean = false;
  private gridRowCount: number = 4;
  private albumScroller: Scroller = new Scroller();
  private photoListScroller: Scroller = new Scroller();
  private previewScroller: Scroller = new Scroller();
  @State photoList: PhotoDataSource = new PhotoDataSource();
  @State subTypeModels: (AlbumModel | undefined)[] = [];
  @State focusDialogStr: string = '';
  @State currentPhotoItem: PhotoModel | undefined = undefined;
  @State currentClickPhoto: PhotoModel | undefined = undefined;
  @State photoListSize: number = 0
  @State pictureChooseFlags: boolean[] = [];
  @State loadImageErrorFlags: boolean[] = [];
  @State selectedPhotoList: PhotoModel[] = [];
  @State previewPhotoList: PhotoModel[] = [];
  @State isPreviewVisible: boolean = false;
  @State previewOpening: boolean = false;
  @State currentPreviewIndex: number = 0;
  @State currentAlbumIndex: number = 0;
  private photoObserver = (photos: PhotoModel[], albumModel: AlbumModel) => {
    this.photoList.setData(photos);
    this.photoListSize = photos.length;
    this.subTypeModels[AlbumType.ALL] = albumModel;
    // 触发UI刷新
    this.subTypeModels.push(undefined);
    this.subTypeModels.pop();
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

  onPageChanged() {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  tabClick() {
    let keyDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectKeyEvent({ keyEvent: keyDownOpt });
      inputEventClient.injectKeyEvent({ keyEvent: keyUpOpt });
      console.log('手动触发tab点击成功');
    } catch (e) {
      console.log('手动触发tab点击失败');
    }
  }

  // 注册菜单监听
  registerMenuKeyListener() {
    // 注册菜单键监听
    inputConsumer.on('key', keyOptions, (keyOptions: inputConsumer.KeyOptions) => {
      // 焦点在图片上
      if (this.focusStr.includes('pickerPhoto_')) {
        const index = parseInt(this.focusStr.replace('pickerPhoto_', ''));
        if (!isNaN(index) && index >= 0 && index < this.photoList.totalCount()) {
          const item = this.photoList.getData(index) as PhotoModel;
          if (item) {
            this.openPreview(item, index);
          }
        }
      }
    })
  }

  aboutToAppear(): void {
    this.getAllPhoto();
    // 注册菜单键监听
    this.registerMenuKeyListener();
    this.isFirstEnter = true;
  }

  onPageShow(): void {
    if (this.isFirstEnter) {
      setTimeout(() => {
        this.tabClick();
        this.isFirstEnter = false;
      }, DELAY_TIME)
    } else {
      this.clickFocusBtn(this.focusStr, false);
    }
  }

  onPageHide(): void {
    Logger.info(TAG, 'onPageHide')
  }

  aboutToDisappear(): void {
    this.resetSelectionState();
    // 取消注册图片数据源监听
    photoManager.getLoader(AlbumType.ALL)?.unRegisterChangeCallback(this.photoObserver)
    photoManager.getLoader(AlbumType.FAVORITE)?.unRegisterChangeCallback(this.favoritePhotoObserver)
    photoManager.getLoader(AlbumType.SCREENSHOT)?.unRegisterChangeCallback(this.screenShotPhotoObserver)
    // 取消监听菜单键
    inputConsumer.off('key', keyOptions);
  }

  // 注册相册图片数据源监听
  async getAllPhoto() {
    photoManager.getLoader(AlbumType.ALL)?.registerChangeCallback(this.photoObserver);
    photoManager.getLoader(AlbumType.FAVORITE)?.registerChangeCallback(this.favoritePhotoObserver);
    photoManager.getLoader(AlbumType.SCREENSHOT)?.registerChangeCallback(this.screenShotPhotoObserver);
    // 注册监听相册变化
    createRegister(() => {
      photoManager.refresh();
    })
  }

  getPhotoUris(): PhotoDataModel[] {
    return this.selectedPhotoList as PhotoDataModel[];
  }

  getPhotoUrisFinal() {
    let uris: string[] = [];
    this.selectedPhotoList.forEach(photo => {
      uris.push(photo.uri);
    });
    console.log('===>uris (in selection order)', JSON.stringify(uris));
    return uris;
  }

  // 获取当前已选数量
  getSelectedCount(): number {
    return this.pictureChooseFlags.filter(flag => flag === true).length;
  }

  // 处理图片选择逻辑
  handlePhotoSelection(index: number): void {
    const currentSelected = this.getSelectedCount();
    const selectedPhoto = this.photoList.getData(index) as PhotoModel;

    // 如果当前图片已经被选中，取消选择
    if (this.pictureChooseFlags[index]) {
      this.pictureChooseFlags[index] = false;
      this.selectCount = currentSelected - 1;

      const removeIndex = this.selectedPhotoList.findIndex(photo => photo.uri === selectedPhoto.uri);
      if (removeIndex !== -1) {
        this.selectedPhotoList.splice(removeIndex, 1);
      }
    } else {
      // 如果当前图片未被选中，检查是否达到上限
      if (currentSelected >= this.maxSelectCount) {
        promptAction.showToast({
          message: `已选素材数量达到上限`,
          backgroundColor: 'rgba(46,48,51,0.9)',
          backgroundBlurStyle: BlurStyle.NONE,
          textColor: 'rgba(255,255,255,0.9)'
        });
        return;
      }
      // 未达到上限，选择图片
      this.pictureChooseFlags[index] = true;
      this.selectCount = currentSelected + 1;

      this.selectedPhotoList.push(selectedPhoto);
    }
  }

  // 重置选择状态
  private resetSelectionState(): void {
    // 清空已选图片列表
    this.selectedPhotoList = [];
    this.pictureChooseFlags = new Array(this.photoList.totalCount()).fill(false);
    this.selectCount = 0;
    this.isOriginalCheck = false;
    // 重置预览相关状态
    this.previewPhotoList = [];
    this.currentPreviewIndex = 0;
    this.currentPhotoItem = undefined;
    this.currentClickPhoto = undefined;
    this.isPreviewVisible = false;
    // 重置视频播放状态
    this.isVideoPlaying = false;
    if (this.videoController) {
      this.videoController.stop();
    }
    Logger.info(TAG, 'All selection states completely reset');
  }

  async switchSubAlbum(type: AlbumType) {
    switch (type) {
      case AlbumType.ALL:
        photoManager.getLoader(AlbumType.ALL)?.registerChangeCallback(this.photoObserver);
        break;
      case AlbumType.FAVORITE:
        photoManager.getLoader(AlbumType.FAVORITE)?.registerChangeCallback((photos: PhotoModel[],
          albumModel: AlbumModel) => {
          // 更新图片数据源
          this.photoList.setData(photos);
          this.photoListSize = photos.length;
          this.subTypeModels[AlbumType.FAVORITE] = albumModel;
          // 触发UI刷新
          this.subTypeModels.push(undefined);
          this.subTypeModels.pop();
        });
        break;
      case AlbumType.SCREENSHOT:
        photoManager.getLoader(AlbumType.SCREENSHOT)?.registerChangeCallback((photos: PhotoModel[],
          albumModel: AlbumModel) => {
          this.photoList.setData(photos);
          this.photoListSize = photos.length;
          this.subTypeModels[AlbumType.SCREENSHOT] = albumModel;
          this.subTypeModels.push(undefined);
          this.subTypeModels.pop();
        });
        break;
    }
  }

  // 打开预览
  private openPreview(item: PhotoModel, index: number): void {
    if (this.previewOpening) {
      return;
    }
    this.previewOpening = true;
    // 当前预览图片
    this.currentPhotoItem = item;
    this.currentClickPhoto = item;
    this.currentPreviewIndex = index;
    this.previewPhotoList = this.photoList.getAllData() as PhotoModel[];

    setTimeout(() => {
      this.isPreviewVisible = true;
      this.previewOpening = false;
    }, DELAY_TIME)
  }

  // 顶部栏
  @Builder
  buildTopBar() {
    Row() {
      Text('选择图片')
        .fontFamily('HarmonyOS Sans')
        .fontColor('rgba(255,255,255,0.86)')
        .fontSize('48lpx')
        .fontWeight(FontWeight.Bold)

      // 关闭按钮
      Image($r('app.media.ic_pick_off'))
        .width('72lpx')
        .aspectRatio(1)
        .borderRadius('50%')
        .focusable(this.isFocusable)
        .id('pickOffBtn')
        .stateStyles({
          focused: {
            .border({
              color: Color.Transparent
            })
          }
        })
        .border({
          width: '2lpx',
          color: this.focusStr === 'pickOffBtn' ? Color.White : Color.Transparent,
          style: BorderStyle.Solid
        })
        .onFocus(() => {
          this.focusStr = 'pickOffBtn';
        })
        .onHover(() => {
          this.focusStr = 'pickOffBtn';
        })
        .onClick(() => {
          // 关闭图库选择应用
          globalThis.pickAbilityContext.terminateSelf().then(() => {
            console.info(`Succeeded in terminating self.`);
          })
            .catch((err: BusinessError) => {
              console.error(`Failed to terminate self, code: ${err.code}, msg: ${err.message}`);
            });
          ;
        })
    }
    .width('100%')
    .height('130lpx')
    .focusable(!this.isFirstEnter)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 相册列表
  @Builder
  buildAlbumItem(item: AlbumModel, index: number) {
    ListItem() {
      Row() {
        // 封面
        Image(item.cover || $r('app.media.p_picture'))
          .width('48lpx')
          .aspectRatio(1)
          .margin({ right: '32lpx' })

        Text(item.name)
          .fontFamily('HarmonyOS Sans')
          .width('180lpx')
          .height('42lpx')
          .fontWeight(FontWeight.Medium)
          .fontColor(this.focusStr == 'pickerAlbum_' + index ? Color.Black : '#DBFFFFFF')
          .fontSize('36lpx')
          .focusable(true)
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })

        Blank()

        Text(item.count.toString())
          .width('76lpx')
          .fontFamily('HarmonyOS Sans')
          .height('42lpx')
          .fontWeight(FontWeight.Medium)
          .fontColor(this.focusStr == 'pickerAlbum_' + index ? 'rgba(0,0,0,0.6)' : '#DBFFFFFF')
          .fontSize('36lpx')
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .padding('24lpx')
      .backgroundColor(this.focusStr == 'pickerAlbum_' + index ? Color.White :
        (this.blurAlbumStr === 'pickerAlbum_' + index ? 'rgba(255,255,255,0.2)' : Color.Transparent))
      .borderRadius('18lpx')
    }
    .width('100%')
    .height('108lpx')
    .padding('6lpx')
    .id('pickerAlbum_' + index)
    .focusable(this.isPreviewVisible ? false : (index === 0 ? true : !this.isFirstEnter))
    .borderRadius('24lpx')
    .border({
      width: '2lpx',
      color: this.focusStr == 'pickerAlbum_' + index ? Color.White : Color.Transparent,
    })
    .onFocus(() => {
      this.focusStr = 'pickerAlbum_' + index;
      this.currentAlbumIndex = index;
      this.blurAlbumStr = '';
      this.albumScroller.scrollToIndex(index, true, ScrollAlign.CENTER)
      // 重置选择状态
      this.resetSelectionState();
      // 切换数据
      this.switchSubAlbum(item.type);
    })
    .onHover(() => {
      this.focusStr = 'pickerAlbum_' + index;
    })
    .onBlur(() => {
      this.blurAlbumStr = 'pickerAlbum_' + index;
    })
    .onClick(() => {
      this.currentAlbumIndex = index;
      this.blurAlbumStr = '';
      this.albumScroller.scrollToIndex(index, true, ScrollAlign.CENTER)
      // 重置选择状态
      this.resetSelectionState();
      // 切换数据
      this.switchSubAlbum(item.type);
    })
  }

  // 图片列表与预览图片列表
  @Builder
  buildGrid() {
    Column() {
      // 图片列表
      Grid(this.photoListScroller) {
        // 图片资源
        LazyForEach(this.photoList, (item: PhotoModel, index: number) => {
          GridItem() {
            Stack({ alignContent: Alignment.Start }) {
              if (this.loadImageErrorFlags[index]) {
                Image(item.photoType != null && item.photoType === Constants.PHOTO_TYPE_VIDEO
                  ? $r('app.media.alt_video_placeholder') : $r('app.media.p_picture'))
                  .aspectRatio(1)
                  .rotate({
                    x: 0,
                    y: 0,
                    z: 1,
                    angle: 0
                  })
                  .objectFit(ImageFit.Cover)
                  .autoResize(false)
                  .onAppear(() => {
                    Logger.debug(TAG, `appear the default image!`);
                  })
              } else {
                Stack({ alignContent: Alignment.BottomEnd }) {
                  PickImageVideo({
                    photoModel: item,
                    focusId: 'pickerPhoto_' + index,
                    eventClickBack: () => {
                      // 处理图片选择逻辑
                      this.handlePhotoSelection(index);
                    }
                  })
                    .width('100%')
                    .onAppear(() => {
                      Logger.info(TAG, `appear the image success, index = ${index}, uri = ${item.uri}`);
                    })
                  // 显示视频时长以及选择按钮
                  Row() {
                    // 缩略图左下角视频时长
                    Text(item != null && (item as PhotoModel).photoType == Constants.PHOTO_TYPE_VIDEO ?
                      Util.getFormattedDuration(Number((item as PhotoModel).duration)) : '')
                      .fontSize('24lpx')
                      .fontFamily('HarmonyOS Sans')
                      .fontColor('#DBFFFFFF')
                      .lineHeight('28lpx')
                      .margin({ left: '8%', bottom: '4%' })

                    // 照片编辑状态
                    Image(this.pictureChooseFlags[index] ? $r('app.media.p_yes') : $r('app.media.p_no'))
                      .width('24lpx')
                      .aspectRatio(1)
                      .margin({ right: '5%', bottom: '5%' })
                      .focusable(false)
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                  .align(Alignment.BottomStart)
                }
                .borderRadius('18lpx')
                .aspectRatio(1)
              }
            }
            .aspectRatio(1)
          }
          .padding('6lpx')
          .focusable(this.isPreviewVisible ? false : true)
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
          .onFocus(() => {
            this.focusStr = 'pickerPhoto_' + index;
          })
          .onHover(() => {
            this.focusStr = 'pickerPhoto_' + index;
          })
          .border({
            width: '2lpx',
            color: this.focusStr === ('pickerPhoto_' + index) ? Color.White : Color.Transparent,
            radius: '24lpx'
          })
          .onKeyEvent((event?: KeyEvent) => {
            if (!event) {
              return;
            }
            if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_LEFT &&
              index % this.gridRowCount === 0) {
              this.clickFocusBtn('pickerAlbum_' + this.currentAlbumIndex, false);
            }
          })
        }, (item: PhotoModel, index: number) => {
          return JSON.stringify(item.uri) + index;
        })
      }
      .focusable(!this.isFirstEnter)
      .cachedCount(18)
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .gridStyle(this.gridRowCount)
      .visibility(this.isPreviewVisible ? Visibility.None : Visibility.Visible)

      // 预览部分
      Column() {
        Stack({ alignContent: Alignment.BottomEnd }) {
          Stack({ alignContent: Alignment.TopStart }) {
            Column() {
            }
            .width('100%')
            .height('100%')
            .backgroundColor('rgba(0,0,0,0.2)')

            // 中间图片或是视频
            if (this.currentPhotoItem?.photoType === Constants.PHOTO_TYPE_VIDEO) {
              // 视频预览
              Stack({ alignContent: Alignment.Center }) {
                Video({
                  src: this.currentPhotoItem?.uri,
                  controller: this.videoController,
                  previewUri: this.currentPhotoItem.pickVideoPreview
                })
                  .focusable(false)
                  .width('100%')
                  .height('100%')
                  .autoPlay(false)
                  .controls(false)
                  .objectFit(ImageFit.Contain)
                  .onStart(() => {
                    this.isVideoPlaying = true;
                  })
                  .onPause(() => {
                    this.isVideoPlaying = false;
                  })
                  .onFinish(() => {
                    this.isVideoPlaying = false;
                  })

                // 视频播放控制按钮
                if (!this.isVideoPlaying) {
                  Column() {
                    Image($r('app.media.p_video_pause'))
                      .width('100lpx')
                      .aspectRatio(1)
                      .fillColor('rgba(255,255,255,0.86)')
                      .onClick(() => {
                        this.videoController.start();
                        this.isVideoPlaying = true;
                      })
                      .focusable(true)
                      .id('video_play_btn')
                      .onKeyEvent((event?: KeyEvent) => {
                        if (!event) {
                          return;
                        }
                        if (event.type !== KeyType.Down) {
                          return;
                        }
                        if (event.keyCode === KeyCode.KEYCODE_DPAD_UP || event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
                          this.clickFocusBtn('pick_preview_off', false);
                        }
                        if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN ||
                          event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
                          this.clickFocusBtn('preview_select_btn', false);
                        }
                      })
                      .onFocus(() => {
                        this.focusStr = 'video_play_btn';
                      })
                      .onHover(() => {
                        this.focusStr = 'video_play_btn';
                      })
                      .onBlur(() => {
                        this.focusStr = 'video_pause_column';
                        this.clickFocusBtn(this.focusStr, false);
                      })
                      .stateStyles({
                        focused: {
                          .border({
                            color: Color.Transparent
                          })
                        }
                      })
                  }
                  .padding('2lpx')
                  .border({
                    width: '2lpx',
                    color: this.focusStr === 'video_play_btn' ? Color.Blue : Color.Transparent,
                    radius: '50%'
                  })
                } else {
                  Column() {
                  }
                  .width('100%')
                  .height('100%')
                  .id('video_pause_column')
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .onClick(() => {
                    this.videoController.pause();
                    this.isVideoPlaying = false;
                  })
                }
              }
              .width('100%')
              .height('100%')
              .onAppear(() => {
                // 当视频预览出现时，检查并重置播放状态
                Logger.info(TAG, 'Video preview appeared, resetting play state');
                this.isVideoPlaying = false;
                this.videoController.stop();
              })
            } else {
              // 图片预览
              Image(this.currentPhotoItem?.uri || '')
                .objectFit(ImageFit.Contain)
                .width('100%')
                .height('100%')
                .key(this.currentPhotoItem?.uri + '_' + this.currentPreviewIndex)
            }

            // 退出框
            Row() {
              Image($r('app.media.p_preview_off'))
                .width('100%')
                .aspectRatio(1)
                .id('pick_preview_off')
                .onKeyEvent((event?: KeyEvent) => {
                  if (!event) {
                    return;
                  }
                  if (event.type !== KeyType.Down) {
                    return;
                  }
                  let nextBtn =
                    this.currentPhotoItem?.photoType === Constants.PHOTO_TYPE_VIDEO && !this.isVideoPlaying
                      ? 'video_play_btn'
                      : 'preview_select_btn';
                  if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN || event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
                    this.clickFocusBtn(nextBtn, false);
                  }
                  if (event.keyCode === KeyCode.KEYCODE_DPAD_UP || event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
                    this.clickFocusBtn('originalCheck', false);
                  }
                })
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.Transparent
                    })
                  }
                })
                .onClick(() => {
                  // 退出预览
                  this.closePreview();
                })
                .onFocus(() => {
                  this.focusStr = 'pick_preview_off';
                })
                .onHover(() => {
                  this.focusStr = 'pick_preview_off';
                })
            }
            .width('43lpx')
            .aspectRatio(1)
            .margin({
              top: '20lpx',
              left: '30lpx'
            })
            .padding('3lpx')
            .border({
              width: '2lpx',
              color: this.focusStr === 'pick_preview_off' ? Color.White : Color.Transparent,
              radius: '50%'
            })
          }

          Row() {
            // 选择框
            Image(this.getCurrentPhotoSelectedState() ? $r('app.media.p_yes') : $r('app.media.p_no'))
              .width('100%')
              .aspectRatio(1)
              .id('preview_select_btn')
              .onKeyEvent((event?: KeyEvent) => {
                if (!event) {
                  return;
                }
                if (event.type !== KeyType.Down) {
                  return;
                }
                if (event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
                  let upBtn = this.currentPhotoItem?.photoType === Constants.PHOTO_TYPE_VIDEO && !this.isVideoPlaying ?
                    'video_play_btn' : 'pick_preview_off';
                  this.clickFocusBtn(upBtn, false);
                }
                if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
                  this.clickFocusBtn('pickerListPhoto0', false);
                }
              })
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .onClick(() => {
                this.handlePreviewPhotoSelection();
              })
              .onFocus(() => {
                this.focusStr = 'preview_select_btn';
              })
              .onHover(() => {
                this.focusStr = 'preview_select_btn';
              })
          }
          .width('43lpx')
          .aspectRatio(1)
          .margin({
            bottom: '20lpx',
            right: '20lpx'
          })
          .padding('3lpx')
          .border({
            width: '2lpx',
            color: this.focusStr === 'preview_select_btn' ? Color.White : Color.Transparent,
            radius: '50%'
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height('420lpx')
        .margin({ bottom: '36lpx' })
        .onKeyEvent((event?: KeyEvent) => {
          if (!event) {
            return;
          }
          this.onPreviewKeyEvent(event);
        })
        .onClick(() => {
          // 如果是图片，处理选择；如果是视频，播放/暂停
          if (this.currentPhotoItem?.photoType === Constants.PHOTO_TYPE_VIDEO) {
            if (this.isVideoPlaying) {
              this.videoController.pause();
              this.isVideoPlaying = false;
            } else {
              this.videoController.start();
              this.isVideoPlaying = true;
            }
          } else {
            this.handlePreviewPhotoSelection();
          }
        })
        .focusable(this.cancelPreviewFocus ? false : true)

        // 预览下的图片列表
        if (this.selectedPhotoList.length > 0) {
          List({ space: '36lpx', scroller: this.previewScroller }) {
            ForEach(this.selectedPhotoList, (item: PhotoModel, index: number) => {
              ListItem() {
                Stack({ alignContent: Alignment.TopEnd }) {
                  // 根据类型显示图片或者视频的缩略图
                  if (item.photoType === Constants.PHOTO_TYPE_VIDEO) {
                    Stack({ alignContent: Alignment.BottomStart }) {
                      Image(item.pickVideoPreview || $r('app.media.alt_video_placeholder'))
                        .width('100%')
                        .aspectRatio(1)
                        .objectFit(ImageFit.Cover)
                        .borderRadius('18lpx')

                      // 视频时长
                      Text(item.duration ? (Util.getFormattedDuration(Number(item.duration))) : '')
                        .fontSize('24lpx')
                        .fontFamily('HarmonyOS Sans')
                        .fontColor('#DBFFFFFF')
                        .lineHeight('28lpx')
                        .margin({ left: '8%', bottom: '4%' })
                    }
                    .aspectRatio(1)
                  } else {
                    Image(item.uri)
                      .aspectRatio(1)
                      .focusable(false)
                      .objectFit(ImageFit.Cover)
                      .borderRadius('18lpx')
                  }

                  // 预览图列表右上角删除按钮
                  Image($r('app.media.pick_watch_off'))
                    .width('36lpx')
                    .aspectRatio(1)
                    .focusable(true)
                    .id('pickerListPhoto' + index)
                    .margin({ right: '12lpx', top: '12lpx' })
                    .stateStyles({
                      focused: {
                        .border({
                          color: Color.Transparent
                        })
                      }
                    })
                    .onKeyEvent((event?: KeyEvent) => {
                      if (!event) {
                        return;
                      }
                      if (event.type !== KeyType.Down) {
                        return;
                      }
                      if (event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
                        this.clickFocusBtn('preview_select_btn', false);
                      }
                      if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
                        this.clickFocusBtn(index === 0 ? 'preview_select_btn' : 'pickerListPhoto' + (index - 1), false);
                      }
                    })
                }
                .border({
                  width: '3lpx',
                  color: this.focusStr == 'pickerListPhoto' + index ? Color.White : Color.Transparent,
                  radius: '18lpx'
                })
              }
              .width('190lpx')
              .padding('3lpx')
              .borderRadius('18lpx')
              .focusable(true)
              .onKeyEvent((e?: KeyEvent) => {
                if (!e) {
                  return;
                }
                if (index === 0) {
                  if (e.type === KeyType.Down && e.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
                    return;
                  }
                }
              })
              .onHover(() => {
                this.changeListPhoto(item, index);
              })
              .onFocus(() => {
                this.changeListPhoto(item, index);
              })
              .onClick(() => {
                this.removeSelectedPhoto(index);
              })
            })
          }
          .width('100%')
          .height('190lpx')
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
          .onKeyEvent((event?: KeyEvent) => {
            if (!event) {
              return;
            }
            if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
              this.cancelPreviewFocus = true;
              setTimeout(() => {
                this.cancelPreviewFocus = false;
              })
            }
          })
        }

      }
      .layoutWeight(1)
      .visibility(this.isPreviewVisible ? Visibility.Visible : Visibility.None)
    }
    .layoutWeight(1)
  }

  changeListPhoto(item: PhotoModel, index: number) {
    this.focusStr = 'pickerListPhoto' + index;
    this.previewScroller.scrollToIndex(index, true, ScrollAlign.CENTER);

    // 停止当前视频播放
    if (this.currentPhotoItem?.photoType === Constants.PHOTO_TYPE_VIDEO) {
      Logger.info(TAG, 'Switching from video, stopping playback');
      this.videoController.stop();
      this.isVideoPlaying = false;
    }

    Promise.resolve().then(() => {
      // 每次切换时显示当前图片
      this.currentPhotoItem = item;
      // 更新当前预览索引
      const mainIndex = this.findPhotoIndexInMainList(item.uri);
      if (mainIndex !== -1) {
        this.currentPreviewIndex = mainIndex;
      }

      // 如果是视频，确保播放状态重置
      if (item.photoType === Constants.PHOTO_TYPE_VIDEO) {
        Logger.info(TAG, 'Switching to video, resetting play state');
        this.isVideoPlaying = false;
        setTimeout(() => {
          this.videoController.reset();
        }, 50);
      }
    });
  }

  onPreviewKeyEvent(e: KeyEvent): void {
    if (e.keyCode === KeyCode.KEYCODE_BACK && e.type === KeyType.Down) {
      // 退出预览时停止视频播放
      if (this.currentPhotoItem?.photoType === Constants.PHOTO_TYPE_VIDEO) {
        this.videoController.stop();
        this.isVideoPlaying = false;
      }
      this.isPreviewVisible = false;
      const currentIndex = this.findPhotoIndexInMainList(this.currentPhotoItem!.uri);
      if (currentIndex !== -1) {
        this.focusStr = 'pickerPhoto_' + currentIndex;
      }
    }

    if (e.keyCode === KeyCode.KEYCODE_SPACE && e.type === KeyType.Down) {
      if (this.currentPhotoItem?.photoType === Constants.PHOTO_TYPE_VIDEO) {
        if (this.isVideoPlaying) {
          this.videoController.pause();
          this.isVideoPlaying = false;
        } else {
          this.videoController.start();
          this.isVideoPlaying = true;
        }
      }
    }
  }

  getCurrentPhotoSelectedState(): boolean {
    if (!this.currentPhotoItem) {
      return false;
    }

    const index = this.findPhotoIndexInMainList(this.currentPhotoItem.uri);
    if (index !== -1) {
      return this.pictureChooseFlags[index];
    }
    return false;
  }

  // 处理预览中的图片选择
  handlePreviewPhotoSelection(): void {
    if (!this.currentPhotoItem) {
      return;
    }
    // 通过当前预览图片的URI在主列表中查找索引
    const index = this.findPhotoIndexInMainList(this.currentPhotoItem.uri);
    if (index !== -1) {
      this.handlePhotoSelection(index);
    }
  }

  // 在主图片列表中查找图片索引
  findPhotoIndexInMainList(uri: string): number {
    const allData = this.photoList.getAllData() as PhotoModel[];
    return allData.findIndex(photo => photo.uri === uri);
  }

  // 移除选中的图片
  removeSelectedPhoto(index: number): void {
    if (index >= 0 && index < this.selectedPhotoList.length) {
      const removedPhoto = this.selectedPhotoList[index];

      // 找到在主列表中的索引
      const mainIndex = this.findPhotoIndexInMainList(removedPhoto.uri);
      if (mainIndex !== -1) {
        this.pictureChooseFlags[mainIndex] = false;
        this.selectCount = this.getSelectedCount();
      }

      this.selectedPhotoList.splice(index, 1);

      let newFocusIndex = -1;

      if (this.selectedPhotoList.length > 0) {
        if (index < this.selectedPhotoList.length) {
          newFocusIndex = index;
        } else {
          newFocusIndex = this.selectedPhotoList.length - 1;
        }
        this.currentPhotoItem = this.selectedPhotoList[newFocusIndex];
        // 焦点回到新的图片
        if (newFocusIndex >= 0) {
          this.focusStr = 'pickerListPhoto' + newFocusIndex;
          this.clickFocusBtn(this.focusStr, false);
        }
      } else {
        // 没有预览图片，退出预览
        this.isFocusable = false;
        this.isPreviewVisible = false;
        const currentIndex = this.findPhotoIndexInMainList(this.currentClickPhoto!.uri);
        this.focusStr = 'pickerPhoto_' + currentIndex;
        this.clickFocusBtn(this.focusStr, false);
        setTimeout(() => {
          this.isFocusable = true;
        }, 100);
      }
    }
  }

  closePreview(): void {
    // 退出预览时重置视频播放
    if (this.currentPhotoItem?.photoType === Constants.PHOTO_TYPE_VIDEO) {
      this.videoController.reset();
      this.isVideoPlaying = false;
    }
    this.isFocusable = false;
    this.isPreviewVisible = false;

    // 清空当前预览的图片
    this.currentPhotoItem = undefined;
    const currentIndex = this.findPhotoIndexInMainList(this.currentClickPhoto!.uri);
    if (currentIndex !== -1) {
      this.focusStr = 'pickerPhoto_' + currentIndex;
      this.clickFocusBtn(this.focusStr, false)
    }

    setTimeout(() => {
      this.isFocusable = true;
    }, 100);
  }

  build() {
    Column() {
      // 顶部操作栏
      this.buildTopBar();

      Row() {
        // 左侧相册列表
        Column() {
          List({ space: '24lpx', scroller: this.albumScroller }) {
            ForEach(this.subTypeModels, (item: AlbumModel, index: number) => {
              this.buildAlbumItem(item, index);
            })
          }
          .width('100%')
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.None)
          .padding({ bottom: '60lpx' })
          .layoutWeight(1)

          Row() {
            Image($r('app.media.person_shield_fill'))
              .width('48lpx')
              .aspectRatio(1)

            Text('仅可访问所选图片或视频')
              .fontColor('rgba(255,255,255,0.4)')
              .fontSize('32lpx')
              .fontFamily('HarmonyOS Sans')
              .fontWeight(FontWeight.Regular)
              .margin({ left: '12lpx' })
          }
          .width('100%')
          .margin({ bottom: '48lpx' })
        }
        .width('36%')
        .height('100%')


        // 右侧图片列表
        Column() {
          // 已选、原图、完成
          Row() {
            // 显示已选图片数量
            Text(`已选 ${this.selectCount}/${this.maxSelectCount}`)
              .fontSize('32lpx')
              .fontWeight(FontWeight.Medium)
              .fontColor('rgba(255,255,255,0.6)')
              .fontFamily('HarmonyOS Sans')

            // 原图
            Row() {
              Column() {
                Radio({ value: 'Radio1', group: 'radioGroup' })
                  .checked(this.isOriginalCheck)
                  .focusable(this.isFocusable)
                  .borderRadius('59lpx')
                  .width('32.5lpx')
                  .aspectRatio(1)
                  .margin(0)
                  .radioStyle({
                    uncheckedBorderColor: Color.Transparent,
                  })
                  .onClick(() => {
                    this.isOriginalCheck = !this.isOriginalCheck;
                  })
                  .id('originalCheck')
                  .onKeyEvent((event?: KeyEvent) => {
                    if (!event) {
                      return;
                    }
                    if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
                      this.clickFocusBtn(this.isPreviewVisible ? 'pick_preview_off' : 'pickerAlbum_0', false);
                    }
                  })
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .onFocus(() => {
                    this.focusStr = 'originalCheck';
                  })
              }
              .width('40lpx')
              .aspectRatio(1)
              .padding('3.75lpx')
              .border({
                width: '2lpx',
                color: this.focusStr === 'originalCheck' ? Color.White : Color.Transparent,
                radius: '50%'
              })
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .margin({ right: '12lpx' })

              Text('原图')
                .fontSize('32lpx')
                .fontWeight(FontWeight.Medium)
                .fontFamily('HarmonyOS Sans')
                .fontColor('#DBFFFFFF')
            }
            .height('40lpx')
            .alignItems(VerticalAlign.Center)

            //完成按钮
            Row() {
              Text('完成')
                .onClick(() => {
                  this.setPickResult();
                })
                .focusable(this.isFocusable)
                .width('100%')
                .height('100%')
                .textAlign(TextAlign.Center)
                .fontSize('36lpx')
                .fontFamily('HarmonyOS Sans')
                .fontWeight(FontWeight.Medium)
                .fontColor(this.focusStr === 'pickComplete' ? 'rgba(0,0,0,0.86)' : '#DBFFFFFF')
                .backgroundColor(this.focusStr === 'pickComplete' ? 'rgba(255,255,255,0.86)' : 'rgba(255,255,255,0.2)')
                .borderRadius('200lpx')
                .id('pickComplete')
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.Transparent
                    })
                  }
                })
                .onFocus(() => {
                  this.focusStr = 'pickComplete';
                })
            }
            .height('84lpx')
            .width('202lpx')
            .padding('6lpx')
            .border({
              width: '2lpx',
              color: this.focusStr == 'pickComplete' ? Color.White : Color.Transparent,
              radius: '205lpx'
            })
          }
          .width('100%')
          .height('153lpx')
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)

          // 图片列表
          this.buildGrid();
        }
        .width('58%')
        .height('100%')
        .focusable(!this.isFirstEnter)
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Top)

    }
    .width('1599lpx')
    .height('972lpx')
    .backgroundColor('rgba(60,60,60,0.9)')
    .borderRadius('48lpx')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [['rgba(0,0,0,0.1)', 0.4], ['rgba(60,60,60,0.9)', 0.4]]
    })
    .padding({
      left: '48lpx',
      right: '48lpx',
      top: '24lpx',
      bottom: '24lpx'
    })
  }

  setPickResult() {
    // 保存结果
    let uriArray: string[] = [];
    uriArray = this.getPhotoUrisFinal();
    console.log('uriArray: ' + JSON.stringify(uriArray));
    let abilityResult: common.AbilityResult = {
      resultCode: 0,
      want: {
        parameters: {
          'imgList': uriArray
        }
      }
    };

    try {
      // 使用terminateSelfWithResult返回结果
      globalThis.pickAbilityContext.terminateSelfWithResult(abilityResult, (err: BusinessError) => {
        if (err) {
          console.error(`Failed to terminate self with result, code: ${err.code}, msg: ${err.message}`);
          return;
        }
        console.info(`Succeeded in terminating self with result.`);
      });
    } catch (err) {
      // 处理入参错误异常
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      console.error(`terminateSelfWithResult failed, code is ${code}, message is ${message}`);
    }
  }

  clickFocusBtn(str: string, inDialog: boolean) {
    let isSuccess = focusControl.requestFocus(str);
    Logger.info(TAG, `requestFocusState is ${isSuccess} , focusStr = ${str}`)
    if (isSuccess) {
      if (inDialog) {
        this.focusDialogStr = str;
      } else {
        this.focusStr = str;
      }
    } else {
      Logger.error(TAG, `requestFocus is failed , focusStr = ${str}`);
    }
    return isSuccess;
  }
}

@Extend(Grid)
function gridStyle(gridCount: number) {
  .columnsTemplate('1fr '.repeat(gridCount))
  .columnsGap('36lpx')
  .rowsGap('36lpx')
  .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
  .layoutWeight(1)
}
