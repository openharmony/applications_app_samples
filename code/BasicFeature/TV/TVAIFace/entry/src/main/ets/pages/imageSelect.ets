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

import { initInfo } from '../utils/log';
import { KeyCode } from '@kit.InputKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { ImageListDataSource } from '../models/ImageListDataSource';
import { image } from '@kit.ImageKit';
import { EventUtil } from '../common/EventUtil';

let log: (tag?: string | number, log?: string | number | undefined) => void = initInfo('imageSelect.ets');

class ImageInfo {
  public fileAsset?: ResourceStr | photoAccessHelper.PhotoAsset; // 媒体文件的FileAsset,应该是资源类型
  public uri?: ResourceStr = ''; //媒体文件的uri,应该是资源类型不是any类型
  public name?: string = '';
  public type?: string = '';
  public smallImg?: image.PixelMap;
}

let rawImgs: ImageInfo[] = [
  {
    fileAsset: '',
    name: 'h_1.jpg',
    uri: $rawfile('h_1.jpg'),
    type: 'rawfile'
  },
  {
    fileAsset: '',
    name: 'h_2.jpg',
    uri: $rawfile('h_2.jpg'),
    type: 'rawfile'
  }
];

@Builder
export function ImageSelectBuilder() {
  ImageSelect();
}

@Component
struct ImageSelect {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  private phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
  private scroller: Scroller = new Scroller();
  @State imageData: ImageInfo[] = [];
  private lazyImageData: ImageListDataSource = new ImageListDataSource();
  @State focusId: number = 0;
  @State isLoading: boolean = true;
  @StorageProp('screen_lpx_h') screenH: number = 1080;
  @State rowNum: number = 0; // 图片的行数
  @State colNum: number = 6; // 图片的列数
  @State imgNun: number = 0; // 图片的数量
  @Consume('NavPathStack') pageStack: NavPathStack;

  aboutToAppear() {
    this.focusId = AppStorage.get<number>('imageFocusId') || 0;
    this.getThumbnail();
  }

  // 获取图库所有缩略图
  async getThumbnail() {
    this.isLoading = true;
    this.imageData = [...rawImgs];
    let imageData: ImageInfo[] = [...rawImgs];
    this.imgNun = imageData.length;
    this.rowNum = Math.ceil(this.imgNun / this.colNum);
    this.lazyImageData.reloadData(this.imageData);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates
    };

    try {
      this.phAccessHelper.getAssets(fetchOptions).then((fetchFileResult) => { //获取图片和视频资源
        log('getPhotoAssets success');
        if (fetchFileResult !== undefined) {
          fetchFileResult.getAllObjects().then(async (fileAsset) => {
            log('getAllObjects success');
            let len: number = fileAsset.length;
            if (len > 0) {
              for (let i = 0; i < fileAsset.length; i++) {
                if (fileAsset[i].photoType === photoAccessHelper.PhotoType.IMAGE) {
                  let iInfo: ImageInfo = {
                    fileAsset: fileAsset[i],
                    uri: fileAsset[i].uri,
                    name: fileAsset[i].displayName,
                    type: 'media'
                  } as ImageInfo;
                  try {
                    if (i < 24) {
                      let thumbnailPixelMap: image.PixelMap = await fileAsset[i].getThumbnail();
                      iInfo.smallImg = thumbnailPixelMap;
                      log('getThumbnail success');
                    }
                  } catch (e) {
                    log('getThumbnail err', JSON.stringify(e));
                  } finally {
                    imageData.push(iInfo);
                  }
                }
              }
            }
            this.imageData = imageData;
            this.lazyImageData.reloadData(this.imageData);
            this.imgNun = imageData.length;
            this.rowNum = Math.ceil(this.imgNun / this.colNum);
            setTimeout(() => {
              this.isLoading = false;
            }, 300);
          }).catch((error1: Error) => {
            log('getAllObject err', JSON.stringify(error1));
          });
        }
      }).catch((err: Error) => {
        log('getPhotoAssets err', JSON.stringify(err));
        setTimeout(() => {
          this.isLoading = false;
        }, 300);
      });
    } catch (e1) {
      log('getPhotoAccessHelper err', JSON.stringify(e1));
      setTimeout(() => {
        this.isLoading = false;
      }, 300);
    }
  }

  imageOnFocus(ind: number) {
    if (!this.scroller || !this.scroller.currentOffset()) {
      return;
    }
    let len: number = this.rowNum;
    let scrollHeight: number = this.screenH - 170;
    let maxScrollY: number = 300 * len - scrollHeight;
    let scrollY: number = px2lpx(vp2px(this.scroller.currentOffset().yOffset));
    let yOffset: number = scrollY;

    if (ind === 0) {
      yOffset = 0;
    } else if (ind === (len - 1)) {
      yOffset = maxScrollY;
    } else {
      let itemOffset: number = 300 * ind;
      let s: number = itemOffset - scrollY;
      if (s < 100) {
        yOffset = itemOffset - 170;
      } else if (s > (scrollHeight - 300)) {
        yOffset = itemOffset + 320 - scrollHeight;
      }
    }
    if (yOffset !== scrollY) {
      this.scroller.scrollTo({
        xOffset: 0,
        yOffset: px2vp(lpx2px(yOffset)),
        animation: {
          duration: 500,
          curve: Curve.Linear
        }
      });
    }
  }

  /**
   * 图片点击事件，如果图片的类型是media则异步打开，表明图片存储在在媒体库，否则同步打开，表示图片是资源库的一部分
   */
  async imgClick() {
    let image: ImageInfo = this.imageData[this.focusId];
    //创建PhotoAsset类型的fd
    if (image.type === 'media') {
      try {
        let photoAsset: photoAccessHelper.PhotoAsset = image.fileAsset as photoAccessHelper.PhotoAsset;
        let fd: number = await photoAsset.requestSource();
        AppStorage.setOrCreate('imageFd', fd);
      } catch (err) {
        log(`media open err ${JSON.stringify(err)}`);
        return;
      }
    } else {
      AppStorage.setOrCreate('imageFd', image.name);
    }
    AppStorage.setOrCreate<boolean>('shouldScan', true);
    this.pageStack.pushPath({ name: 'ImagePreview' }, { launchMode: LaunchMode.POP_TO_SINGLETON });
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Text('') {
          }
          .width('2lpx')
          .height('2lpx')
          .backgroundColor('#00000000')
          .focusable(true)
          .defaultFocus(true)
          .position({ x: 0, y: 0 });

          Column() {
            Text($r('app.string.local_image'))
              .fontSize('64lpx')
              .width('100%')
              .margin({ bottom: '46lpx' })
              .fontColor('#e6ffffff');
            Row() {
              if (this.imageData.length > 0) {
                Grid(this.scroller) {
                  LazyForEach(this.lazyImageData, (item: ImageInfo, index: number) => {
                    GridItem() {
                      Image(item.smallImg || item.uri)
                        .width('248lpx')
                        .height('248lpx')
                        .padding('6lpx')
                        .objectFit(ImageFit.Cover)
                        .borderRadius('18lpx')
                        .clip(true);
                    }
                    .margin({ bottom: '30lpx', right: '30lpx' })
                    .border({
                      width: '4lpx',
                      color: this.focusId === index ? '#ffffffff' : '#00ffffff',
                      radius: '18lpx',
                      style: BorderStyle.Solid
                    })
                    .onHover(() => {
                      this.focusId = index;
                    })
                    .onTouch((e) => {
                      EventUtil.isTouchEvent(e);
                      if (e.type === TouchType.Up) {
                        this.imgClick();
                      }
                    });
                  });
                }
                .scrollBar(BarState.Off)
                .align(Alignment.Top)
                .height('100%')
                .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr');
              }
              if (this.imageData.length === 0 && !this.isLoading) {
                Text($r('app.string.no_image_tips'))
                  .fontSize('64lpx')
                  .fontColor('#ffffff');
              }
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center);
          }
          .width('100%')
          .padding({ left: '96lpx', right: '96lpx', top: '48lpx' });
        }
        .zIndex(1)
        .width('100%')
        .height('100%')
        .focusable(true)
        .onKeyEvent(e => {
          // 阻止冒泡到上级路由
          e.stopPropagation();
          if (e.keyCode === KeyCode.KEYCODE_F24) {
            return;
          }
          if (this.imgNun > 0) {
            if (e.keyCode === KeyCode.KEYCODE_DPAD_UP && e.type === KeyType.Up) {
              if (this.focusId > (this.colNum - 1)) {
                this.focusId = this.focusId - this.colNum;
              }
            }
            if (e.keyCode === KeyCode.KEYCODE_DPAD_DOWN && e.type === KeyType.Up) {
              let focusId: number = this.focusId + this.colNum;
              if (this.focusId < (this.imgNun - this.colNum)) {
                this.focusId = focusId;
              }
            }
            if (e.keyCode === KeyCode.KEYCODE_DPAD_LEFT && e.type === KeyType.Up) {
              if (this.focusId > 0) {
                this.focusId = this.focusId - 1;
              }
            }
            if (e.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && e.type === KeyType.Up) {
              let focusId: number = this.focusId + 1;
              if (focusId < this.imgNun) {
                this.focusId = focusId;
              } else {
                this.focusId = this.imgNun - 1;
              }
            }
            let rowIndex: number = Math.floor(this.focusId / this.colNum);
            this.imageOnFocus(rowIndex);
            if (e.keyCode === KeyCode.KEYCODE_ENTER && e.type === KeyType.Up) {
              // 存储当前图片的FocusId
              AppStorage.setOrCreate<number>('imageFocusId', this.focusId);
              this.imgClick();
            }
          }
        })
        .zIndex(1);

        // 加载中
        Row() {
          LoadingProgress().color('#aaffffff').width('120lpx');
        }
        .backgroundColor('#4d000000')
        .width('100%')
        .height('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .zIndex(5)
        .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden);
      }
      .width('100%')
      .height('100%');
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor('#18181A');
  }
}
