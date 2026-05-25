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
import { Attachment, fpChangeLpx, TIME_INT, vpChangeLpx } from '../../IssueReporter/models/IssueDetailInfo';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import image from '@ohos.multimedia.image';
import { ColorMetrics, LengthMetrics, promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { registerInputConsumer, unregisterInputConsumer } from './IssueReportSelectItem';
import { KeyCode } from '@kit.InputKit';
import { PhotoGroupDataSource } from '../../../models/PhotoModel';
import { tabClick } from '../../Index';
import fileUtil from '../../../manager/utils/FileUtils';
import { loadVideoThumb } from '../../../manager/VideoThumbLoader';
import { emitter } from '@kit.BasicServicesKit';
import { EventUtil } from '../../common/EventUtil';

const TAG = 'issueAttachment';
const sourceToolMouseClick: number = 7;

@Observed
export class PhotoModel {
  public uri: string = '';
  public displayName: string = '';
  public dateAdded: number = 0;
  public duration?: number;
  public dateTrashed?: number;
  public photoType?: photoAccessHelper.PhotoType;
  public thumbnail?: image.PixelMap;
  public imageUri?: string;
  public thumbWidth?: number;
  public thumbHeight?: number;
  public photoAsset?: photoAccessHelper.PhotoAsset;

  constructor() {
  }
}

export class LazyIndex {
  public start: number = 0;
  public end: number = 0;

  constructor() {
  }
}

@Component
export default struct issueAttachment {
  canEdit: boolean = false;
  @Prop thumbnails: Attachment[] = [];
  @Prop keyFocus: string = '';
  @Link previewImage: boolean;
  @Link previewImageIndex: number;
  selectedPhotoHandle?: (photoInfos: PhotoModel[], size: number) => void;
  @State photoPixels: image.PixelMap[] = [];
  @State photoInfos: photoAccessHelper.PhotoAsset[] = [];
  private controller: VideoController = new VideoController();
  private previewUris: Resource = $r('app.media.ic_video_play_btn_png');
  @StorageProp('isSelectPhoto') @Watch('isSelectPhotoFunc') flag: boolean = false;
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State imageInfo: PhotoGroupDataSource = new PhotoGroupDataSource();
  @State selectedImage: PhotoModel[] = [];
  @State isFocus: boolean = false;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: SelectImageDialog({
      imageInfo: this.imageInfo,
      thumbnails: this.thumbnails,
      selectedPhotoHandle: this.selectedPhotoHandle,
      selectedImage: this.selectedImage
    }),
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    backgroundColor: $r('app.color.global_default_background'),
    cornerRadius: 10,
    width: '70%',
    height: '80%'
  });

  @Builder
  customBuilder() {
  }

  @BuilderParam titleBuilderParam: () => void = this.customBuilder;

  isSelectPhotoFunc() {
    this.dialogController?.open();
    this.imageInfo.setData(AppStorage.get('photoGroupList') as PhotoModel[]);
    console.info('issueAttachment aboutToAppear' + JSON.stringify(this.imageInfo.getAllData()));
  }

  aboutToAppear(): void {
    emitter.on('auto_focus', (data) => {
      let title: string = String(data?.data);
      if (this.getUniqueId().toString() == title) {
        return;
      }
      this.isFocus = false;
    });
  }

  @Builder
  addItem(size: Length, color: ResourceColor) {
    Column() {
      Image($r('app.media.icon_add'))
        .width(vpChangeLpx(size as number))
        .height(vpChangeLpx(size as number));
    }
    .focusBox({
      margin: LengthMetrics.px(2),
      strokeColor: ColorMetrics.resourceColor($r('app.color.default_white')),
      strokeWidth: LengthMetrics.px(2)
    })
    .width('100%')
    .height(vpChangeLpx(100))
    .justifyContent(FlexAlign.Center);
  }

  build() {
    Column() {
      this.titleBuilderParam();

      Column() {
        if (this.canEdit) {
          if (this.selectedImage?.length) {
            Grid() {
              ForEach(this.selectedImage, (item: PhotoModel, index: number) => {
                GridItem() {
                  Column() {
                    ThumbnailShow({ item: item });
                  }
                  .width('100%')
                  .height(vpChangeLpx(150))
                  .justifyContent(FlexAlign.Center);
                };
              });
            }
            .columnsTemplate('1fr 1fr 1fr 1fr')
            .rowsTemplate('1fr')
            .columnsGap(vpChangeLpx(14))
            .height(vpChangeLpx(192));

          } else {
            Row() {
              Column() {
                Text($r('app.string.no_attachment_uploaded'))
                  .fontSize(fpChangeLpx(42))
                  .fontWeight(400)
                  .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'));
              }
              .alignItems(HorizontalAlign.Center)
              .height(vpChangeLpx(150))
              .justifyContent(FlexAlign.Center)
              .width('85%');
            };
          }
        } else {
          if (this.thumbnails?.length) {
            Grid() {
              ForEach(this.thumbnails, (item: Attachment, index: number) => {
                GridItem() {
                  Column() {
                    if (item.type == 'image') {
                      Image(item.thumbnail)
                        .width(vpChangeLpx(150))
                        .height(vpChangeLpx(120))
                        .borderRadius(vpChangeLpx(29));
                    } else if (item.type == 'video') {
                      Image(this.previewUris)
                        .width(vpChangeLpx(150))
                        .height(vpChangeLpx(120))
                        .borderRadius(vpChangeLpx(29));
                    }
                  }
                  .width('100%')
                  .height(vpChangeLpx(150))
                  .justifyContent(FlexAlign.Center)
                  .onClick(() => {
                    this.previewImage = true;
                    this.previewImageIndex = index;
                  });
                }
                .focusable(false)
                .focusBox({
                  margin: LengthMetrics.px(2),
                  strokeColor: ColorMetrics.resourceColor($r('app.color.default_white')),
                  strokeWidth: LengthMetrics.px(2)
                });
              });
            }
            .columnsTemplate('1fr 1fr 1fr 1fr')
            .rowsTemplate('1fr')
            .columnsGap(vpChangeLpx(34))
            .height(vpChangeLpx(192))
            .padding({ left: vpChangeLpx(10), right: vpChangeLpx(10) });
          } else {
            Row() {
              Column() {
                Text($r('app.string.no_attachment_uploaded'))
                  .fontSize(fpChangeLpx(42))
                  .fontWeight(400)
                  .fontColor($r('app.color.default_white'));
              }
              .alignItems(HorizontalAlign.Center)
              .height(vpChangeLpx(150))
              .justifyContent(FlexAlign.Center)
              .width('85%');
            };
          }
        }
      }
      .width('100%')
      .height(vpChangeLpx(239))
      .padding({ left: vpChangeLpx(25), right: vpChangeLpx(25) })
      .margin({ top: vpChangeLpx(20) })
      .backgroundColor(this.isFocus ? $r('app.color.default_white') : $r('app.color.choose_background'))
      .borderRadius(vpChangeLpx(24))
      .justifyContent(FlexAlign.Center);
    }
    .backgroundColor($r('app.color.global_default_background'))
    .padding({ left: vpChangeLpx(10), right: vpChangeLpx(10) })
    .focusable(true)
    .onFocus(() => {
      this.isFocus = true;
    })
    .onBlur(() => {
      this.isFocus = false;
    })
    .onHover((isHover: boolean) => {
      focusControl.requestFocus(this.keyFocus);
      if (isHover) {
        try {
          emitter.emit('auto_focus', { data: this.getUniqueId() });
        } catch (e) {
          console.error(e);
        }
      }
    })
    .onClick(() => {
      focusControl.requestFocus(this.keyFocus);
      tabClick();
    })
    .onTouch((event) => {
      focusControl.requestFocus(this.keyFocus);
      if (!EventUtil.isTouchEvent(event)) {
        return;
      }
      if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
        return;
      }
    })
    .padding({ left: vpChangeLpx(10), right: vpChangeLpx(10) })
    .border(this.isFocus ? { width: vpChangeLpx(2), color: $r('app.color.default_white'), radius: vpChangeLpx(24) } :
      null);
  }
}

@CustomDialog
struct SelectImageDialog {
  controller?: CustomDialogController;
  @State isFocusCancel: boolean = false;
  @State isFocusAccept: boolean = false;
  scroller: Scroller = new Scroller();
  @Prop imageInfo: PhotoGroupDataSource = new PhotoGroupDataSource();
  @Link selectedImage: PhotoModel[];
  @Link thumbnails: Attachment[];
  @State photoInfos: photoAccessHelper.PhotoAsset[] = [];
  selectedPhotoHandle?: (photoInfos: PhotoModel[], size: number) => void;
  @State currentIndex: number = 0;

  build() {
    Column() {
      Text($r('app.string.select_images_videos'))
        .fontSize(fpChangeLpx(36))
        .fontColor($r('app.color.default_white'));

      Row() {
        Text($r('app.string.local_picture'))
          .fontSize(fpChangeLpx(30))
          .fontColor($r('app.color.default_white'))
          .opacity(0.6);
      }
      .width('100%')
      .margin({ top: vpChangeLpx(42) })
      .padding({ left: vpChangeLpx(54), right: vpChangeLpx(54) })
      .justifyContent(FlexAlign.Start);

      Grid() {
        LazyForEach(this.imageInfo, (item: PhotoModel, index: number) => {
          GridItem() {
            Column() {
              Row() {
                ThumbnailShow({ item: item });
              }
              .padding(vpChangeLpx(5))
              .border(this.currentIndex == index ? {
                width: vpChangeLpx(2),
                color: $r('app.color.default_white'),
                radius: vpChangeLpx(24)
              } : null);
            }
            .width('100%')
            .height(vpChangeLpx(150))
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              const isItemSelected = this.selectedImage.some(selectedItem => selectedItem === item);
              if (isItemSelected) {
                // 如果已经选中，移除该元素
                const selectedIndex = this.selectedImage.indexOf(item);
                if (selectedIndex > -1) {
                  this.selectedImage.splice(selectedIndex, 1);
                  this.thumbnails.splice(selectedIndex, 1);
                }
              } else {
                // 如果未选中，且选择数量未超过限制，添加该元素
                if (this.selectedImage.length < 4) {
                  this.selectedImage.push(item);
                  this.thumbnails.push({
                    type: item.photoType == photoAccessHelper.PhotoType.IMAGE ? 'image' : 'video',
                    url: item.uri,
                    thumbnail: item.thumbnail as PixelMap,
                    id: ''
                  });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.more_select_images_videos')
                  });
                }
              }
            });
          }
          .key('ThumbnailShow' + index)
          .focusable(true)
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          })
          .onFocus(() => {
            this.currentIndex = index;
          })
          .onBlur(() => {
            this.currentIndex = -1;
          })
          .onHover(() => {
            focusControl.requestFocus('ThumbnailShow' + index);
          })
          .onTouch((event) => {
            focusControl.requestFocus('ThumbnailShow' + index);
            if (!EventUtil.isTouchEvent(event)) {
              return;
            }
            if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
              return;
            }
          });
        });
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(vpChangeLpx(24))
      .columnsGap(vpChangeLpx(21))
      .layoutWeight(3)
      .margin({ bottom: vpChangeLpx(20) })
      .padding({
        left: vpChangeLpx(20),
        right: vpChangeLpx(20),
        top: vpChangeLpx(23),
        bottom: vpChangeLpx(10)
      });


      Row() {
        Text($r('app.string.selected_picture'))
          .fontSize(fpChangeLpx(30))
          .fontColor($r('app.color.default_white'))
          .opacity(0.6);
      }
      .width('100%')
      .padding({ left: vpChangeLpx(54), right: vpChangeLpx(54) })
      .justifyContent(FlexAlign.Start);

      Grid() {
        ForEach(this.selectedImage, (item: PhotoModel, index: number) => {
          GridItem() {
            Column() {
              ThumbnailShow({ item: item });
            }
            .width('100%')
            .height(vpChangeLpx(150))
            .justifyContent(FlexAlign.Center);
          };
        });
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(vpChangeLpx(51))
      .columnsGap(vpChangeLpx(30))
      .layoutWeight(2)
      .padding({ left: vpChangeLpx(20), right: vpChangeLpx(20), top: vpChangeLpx(10) });

      Row() {
        Row() {
          Button($r('app.string.cancel'))
            .key('cancel')
            .focusable(true)
            .width('148lpx')
            .height('48lpx')
            .fontSize('32lpx')
            .fontColor(this.isFocusCancel ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .backgroundColor(this.isFocusCancel ? $r('app.color.default_white') : $r('app.color.button_gray'))
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                });
              }
            })
            .borderRadius('30lpx')
            .onHover(() => {
              focusControl.requestFocus('cancel');
            })
            .onTouch((event) => {
              focusControl.requestFocus('cancel');
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                return;
              }
            })
            .onFocus(() => {
              this.isFocusCancel = true;
              registerInputConsumer(KeyCode.KEYCODE_DPAD_DOWN, () => {
                tabClick();
              });
            })
            .onBlur(() => {
              this.isFocusCancel = false;
              unregisterInputConsumer(KeyCode.KEYCODE_DPAD_DOWN);
            })
            .onClick(() => {
              this.selectedImage = [];
              this.controller?.close();
            });
        }
        .width('160lpx')
        .height('60lpx')
        .border({
          width: this.isFocusCancel ? '2lpx' : 0,
          radius: '30lpx',
          color: Color.White,
          style: BorderStyle.Solid
        })
        .justifyContent(FlexAlign.Center);

        Row() {
          Button($r('app.string.sure'))
            .key('confirm')
            .width('148lpx')
            .height('48lpx')
            .fontSize('32lpx')
            .borderRadius('30lpx')
            .fontColor(this.isFocusAccept ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .backgroundColor(this.isFocusAccept ? $r('app.color.default_white') : $r('app.color.button_gray'))
            .focusBox({
              margin: LengthMetrics.lpx(2),
              strokeColor: ColorMetrics.resourceColor($r('app.color.default_white')),
              strokeWidth: LengthMetrics.lpx(0)
            })
            .onHover(() => {
              focusControl.requestFocus('confirm');
            })
            .onTouch((event) => {
              focusControl.requestFocus('confirm');
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                return;
              }
            })
            .onFocus(() => {
              this.isFocusAccept = true;
              registerInputConsumer(KeyCode.KEYCODE_DPAD_DOWN, () => {
                tabClick();
              });
            })
            .onBlur(() => {
              this.isFocusAccept = false;
              unregisterInputConsumer(KeyCode.KEYCODE_DPAD_DOWN);
            })
            .onClick(() => {
              this.selectedPhotoHandle && this.selectedPhotoHandle(this.selectedImage, 99);
              this.controller?.close();
            });
        }
        .width('160lpx')
        .height('60lpx')
        .border({
          width: this.isFocusAccept ? '2lpx' : 0,
          radius: '30lpx',
          color: Color.White,
          style: BorderStyle.Solid
        })
        .justifyContent(FlexAlign.Center);
      }
      .width('100%')
      .height('60lpx')
      .justifyContent(FlexAlign.SpaceAround);
    }
    .width('100%')
    .height('100%')
    .padding({
      top: vpChangeLpx(32),
      bottom: vpChangeLpx(36),
      left: vpChangeLpx(133),
      right: vpChangeLpx(133)
    })
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .backgroundColor('#FF404040')
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio >= 1.0) {
        setTimeout(() => {
          tabClick();
        }, TIME_INT);
      }
    });
  }
}

@Component
export struct ThumbnailShow {
  @Prop item: PhotoModel;
  @State album: string | undefined = undefined;
  MILLISECONDS_PER_SECOND: number = 1000;
  SECONDS_PER_MINUTE: number = 60;
  SECONDS_PER_HOUR: number = 3600;
  SECONDS_PER_DAY: number = 3600 * 24;
  ALL_REMAINING_DAYS: number = 30;

  aboutToAppear(): void {
    if (this.item.photoType == photoAccessHelper.PhotoType.VIDEO) {
      this.getThumbByUri(getContext(), this.item, 'videoImage').then((thumbUri) => {
        this.album = thumbUri;
      });
    }
  }

  async getThumbByUri(context: Context, photoModel: PhotoModel, tag: string): Promise<string> {
    const thumbPath = await this.getSavedThumbPath(context, photoModel.uri);
    if (thumbPath) {
      return 'file://' + thumbPath;
    } else {
      let result = await this.getVideoAlbum(context, photoModel.uri, 150, 130);
      return result;
    }
  }

  async getSavedThumbPath(context: Context, uri: string): Promise<string | undefined> {
    const cacheDir = await fileUtil.getCacheDir(context);
    const imageName = fileUtil.getLocalFilePathByUri(uri);
    const localPath = cacheDir + imageName;
    const thumbExist = await fileUtil.fileExist(localPath);
    if (thumbExist) {
      return localPath;
    } else {
      return undefined;
    }
  }

  async getVideoAlbum(context: Context, uri: string, width: number,
    height: number): Promise<string> {
    const widthScale = width / 150;
    const heightScale = height / 130;
    const scale = widthScale < heightScale ? widthScale : heightScale;
    const thumbWidth = width / scale;
    const thumbHeight = height / scale;

    const result = await loadVideoThumb(context, uri, thumbWidth, thumbHeight);
    return 'file://' + (result as string);
  }

  getFormattedDuration(milliSecond: number): string {
    if (milliSecond == null) {
      console.error(TAG, 'getFormattedDuration, input is null!');
      return '00:00';
    }
    if (milliSecond <= 0) {
      console.error(TAG, 'getFormattedDuration, input is negative number!');
      return '00:00';
    }
    if (milliSecond < this.MILLISECONDS_PER_SECOND) {
      return '00:01';
    }
    let seconds = Math.floor(milliSecond / this.MILLISECONDS_PER_SECOND);
    let hourTime: number = Math.floor(seconds / this.SECONDS_PER_HOUR);
    let minuteTime: number = Math.floor(Math.floor(seconds / this.SECONDS_PER_MINUTE) % this.SECONDS_PER_MINUTE);
    let secondTime: number = Math.floor(seconds % this.SECONDS_PER_MINUTE);
    if (hourTime > 0) {
      return `${hourTime}:${this.checkTime(minuteTime)}:${this.checkTime(secondTime)}`;
    } else {
      return `${this.checkTime(minuteTime)}:${this.checkTime(secondTime)}`;
    }
  }

  checkTime(time: number): string {
    if (time < 0) {
      console.error(TAG, 'checkTime, input is negative number!');
      return '00';
    }
    let formatTime: string = time.toString();
    if (time < 10) {
      let zeroString = '0';
      formatTime = zeroString.concat(formatTime);
    }
    return formatTime;
  }

  build() {
    Column() {
      if (this.item.photoType == photoAccessHelper.PhotoType.IMAGE) {
        Image(this.item.uri)
          .width(vpChangeLpx(150))
          .height(vpChangeLpx(130))
          .borderRadius(vpChangeLpx(18))
          .autoResize(true);
      } else {
        Column() {
          Stack({ alignContent: Alignment.BottomStart }) {
            Image(this.album)
              .width(vpChangeLpx(150))
              .height(vpChangeLpx(130))
              .borderRadius(vpChangeLpx(18))
              .autoResize(true);

            Text(this.getFormattedDuration(Number(this.item.duration)))
              .fontSize(fpChangeLpx(18))
              .fontFamily('HarmonyOS Sans')
              .fontColor($r('app.color.default_white'));
          };
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center);
      }
    };
  }
}