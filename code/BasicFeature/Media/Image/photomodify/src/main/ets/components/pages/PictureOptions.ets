/*
 * Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import router from '@ohos.router';
import image from '@ohos.multimedia.image';
import { logger } from '../util/Logger';
import { copyPixelMap } from '../util/CopyObj';
import { pictureJsDatas, pictureNdkDatas } from '../model/AdjustModels';
import { CropTasks, TaskData, Tasks } from '../model/AdjustData';
import PixelMapQueue from '../feature/PixelMapQueue';
import { FontColorData, MaterialData } from '../model/MaterialData';
import { BusinessError } from '@ohos.base';
import { DecodingPicture, EncodingPicture } from '../util/PictureUtil';
import { NDKPictureDecoding, NDKPictureEncoding } from '../util/PictureUtil';

const TAG: string = '[Sample_Picture]';

@Component
export struct PictureOptions {
  @State pixelMap: PixelMap | undefined | null = undefined;
  @State isPixelMapChange: boolean = false;
  @State adjustMarkJudg: boolean = false;
  @State currentTask: number = Tasks.ADJUST;
  @State currentCropTask: number = CropTasks.NONE;
  @State tempPixelMap: image.PixelMap | undefined | null = undefined;
  @State cancelOkText: Resource | null = null;
  @State brightnessValue: number = 0;
  @State outSetValueOne: number = 0;
  @State originBM: PixelMap | null = null;
  @State cropIndex: number = 0;
  @State canClick: boolean = true;
  @State loading: boolean = false;
  @State isCancelQuit: boolean = false;
  // 选择资源素材index
  @State resourceIndex: number = 0;
  @State isTextMaterial: boolean = true;
  selectedResource: Resource | undefined = $r('app.color.material_font_color_one');
  scroller: Scroller = new Scroller();
  brightnessOriginBM: PixelMap | null | undefined = null;
  @State resolution: string = '';
  @State inputValue: string = '';
  // 分辨率的坐标
  @State dpiX: number = 0;
  @State dpiY: number = 0;
  // 分辨率
  @State dpi: string = '';
  // 图片父容器大小
  containerArea: Area | null = null;
  isBrightChanging: boolean = false;
  // fileName
  @State jpegFileName: string = 'HdrVivid.jpg';
  @State heifFileName: string = 'HEIFISOMultiChannelBaseColor0512V12.heic';
  @State packingFileName: string = '';
  private pixelMapQueue: PixelMapQueue = new PixelMapQueue();
  pushState1: number = 0; // source
  pushState2: number = 1; // obj
  outState1: number = 0; // buffer
  outState2: number = 1; // file
  pictureStatus1: number = 0; // jpeg
  pictureStatus2: number = 1; // heic
  auxiliaryType: image.AuxiliaryPictureType = image.AuxiliaryPictureType.GAINMAP;
  @State showPicture: string = '';

  /**
   * 刷新图层显示
   */
  flushPage(): void {
    this.tempPixelMap = this.pixelMap;
    this.pixelMap = null;
    this.pixelMap = this.tempPixelMap;
  }

  async onEditCancel(): Promise<void> {
    if (this.currentTask === Tasks.DECODEJS || this.currentTask === Tasks.ENCODEJS) {
      this.currentTask = Tasks.ADJUST;
      this.cropIndex = 0;
    }
    if (this.currentTask === Tasks.DECODENDK || this.currentTask === Tasks.ENCODENDK) {
      this.currentTask = Tasks.MARK;
      this.cropIndex = 0;
    }

    this.isCancelQuit = true;
    this.outSetValueOne = 0;
    if (this.originBM !== null && this.originBM !== undefined) {
      this.pixelMap = await copyPixelMap(this.originBM); // 拷贝
    }
    // 移出一个缓存
    const pm: image.PixelMap | undefined = this.pixelMapQueue.pop();
    this.releasePm(pm);
  }

  /**
   * 选择子菜单
   * @param item
   * @param hasInputText
   */
  async onSelectItem(item: TaskData): Promise<void> {
    if (item.task !== undefined) {
      this.currentTask = item.task;
    }
    if (item.text !== undefined) {
      this.cancelOkText = item.text
    }
    this.originBM = await copyPixelMap(this.pixelMap!) // 拷贝
    // 保存到队列
    this.pixelMapQueue.push(this.originBM);
  }

  /**
   * 多图图片解码
   * @param pictureStatus 图片类型(0:jpeg, 1:heif)
   * @param auxType 解码类型(1:Gain map)
   * @returns
   */
  async decodingPictureJs(pictureStatus: number, auxType: image.AuxiliaryPictureType): Promise<void> {
    logger.info(TAG, `decodingPicture start`);
    logger.debug(TAG, `decodingPicture Type = ${auxType}`);
    if (!pictureStatus) { // jpeg
      this.pixelMap = await DecodingPicture(this.jpegFileName, auxType);
    } else {
      this.pixelMap = await DecodingPicture(this.heifFileName, auxType);
    }
    if (!this.pixelMap) {
      logger.info(TAG, `decodingPicture no pixelMap`);
      return;
    }
    let imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo();
    if (!imageInfo) {
      logger.info(TAG, `decodingPicture no imageInfo`);
      return;
    }
    logger.debug(TAG, `imageInfo = ${JSON.stringify(imageInfo)}`);
    logger.debug(TAG, `imageInfo.isHdr  = ${imageInfo.isHdr}`);
    this.flushPage();
    logger.info(TAG, 'decodingPicture end');
  }

  /**
   * 多图图片编码
   * @param pushStatus 编码入参(0:source, 1:obj)
   * @param jpegFileName 图片类型(jpeg)
   * @param outStatus 编码出参(0:buffer, 1:file)
   * @returns
   */
  async encodingPictureJs(pushStatus: number, outStatus: number): Promise<void> {
    logger.info(TAG, 'encodingPicture start');
    this.pixelMap = await EncodingPicture(pushStatus, this.jpegFileName, outStatus);
    if (!this.pixelMap) {
      logger.info(TAG, `encodingPicture no pixelMap`);
      return;
    }
    let imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo();
    if (!imageInfo) {
      logger.info(TAG, `encodingPicture no imageInfo`);
      return;
    }
    logger.debug(TAG, `imageInfo = ${JSON.stringify(imageInfo)}`);
    logger.debug(TAG, `imageInfo.isHdr  = ${imageInfo.isHdr}`);
    this.flushPage();
    logger.info(TAG, 'encodingPicture end');
  }

  /**
   * Native多图图片解码
   * @param decodingType 解码类型(1:Gain map)
   * @returns
   */
  async decodingPictureNdk(auxType: image.AuxiliaryPictureType, uri: string): Promise<void> {
    logger.info(TAG, `decodingPicture start`);
    logger.debug(TAG, `decodingPicture Type = ${auxType}`);
    this.pixelMap = await NDKPictureDecoding(uri, auxType);
    if (!this.pixelMap) {
      logger.info(TAG, `decodingPicture no pixelMap`);
      return;
    }
    let imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo();
    if (!imageInfo) {
      logger.info(TAG, `decodingImage no imageInfo`);
      return;
    }
    logger.debug(TAG, `imageInfo = ${JSON.stringify(imageInfo)}`);
    logger.debug(TAG, `imageInfo.isHdr  = ${imageInfo.isHdr}`);
    this.flushPage();
    logger.info(TAG, 'decodingImage end');
  }

  /**
   * Native多图图片编码
   * @param encodingType 编码类型(0:AUTO,1:SDR)
   * @returns
   */
  async encodingPictureNdk(fileName: string, encodingObject: string, encodingResult: string): Promise<void> {
    logger.info(TAG, 'encodingPicture start');
    this.pixelMap = await NDKPictureEncoding(fileName, encodingObject, encodingResult);
    if (!this.pixelMap) {
      logger.info(TAG, `decodingPicture no pixelMap`);
      return;
    }
    let imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo();
    if (!imageInfo) {
      logger.info(TAG, `encodingPicture no imageInfo`);
      return;
    }
    logger.debug(TAG, `imageInfo = ${JSON.stringify(imageInfo)}`);
    logger.debug(TAG, `imageInfo.isHdr  = ${imageInfo.isHdr}`);
    this.flushPage();
    logger.info(TAG, 'encodingPicture end');
  }

  /**
   * 底部一级菜单
   */
  @Builder
  getFirstLvMenu() {
    Row() {
      Column() {
        Image($r('app.media.ic_adjust'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.edit_picture_js'))
          .fontColor(Color.White)
          .fontSize($r('app.float.size_16'))
      }
      .id('external')
      .justifyContent(FlexAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('40%')
      .margin({ left: '10%' })
      .backgroundColor(this.adjustMarkJudg ? Color.Black : $r('app.color.edit_image_adjust_selected'))
      .onClick(async () => {
        this.adjustMarkJudg = false;
        this.currentTask = Tasks.ADJUST;
      })

      Column() {
        Image($r('app.media.ic_mark'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.edit_picture_native'))
          .fontColor(Color.White)
          .fontSize($r('app.float.size_16'))
      }
      .id('inner')
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.adjustMarkJudg = true;
        this.currentTask = Tasks.MARK;
      })
      .backgroundColor(this.adjustMarkJudg ? $r('app.color.edit_image_adjust_selected') : Color.Black)
      .height('100%')
      .width('40%')
      .margin({ right: '10%' })
    }
    .height('9%')
    .width('100%')
  }

  releasePm(pm: PixelMap | undefined): void {
    if (!pm) {
      return
    }

    pm.release().catch((err: BusinessError) => {
      logger.error('pm release failed:' + JSON.stringify(err));
    });
  }

  @Builder
  CancelOrOk(text: string | Resource) {
    Row() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Image($r('app.media.ic_cancel'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
          .onClick(async () => {
            await this.onEditCancel();
          })
          .margin({ left: '10%' })
          .id('cancel')

        Text(text)
          .fontColor(Color.White)
          .fontSize($r('app.float.size_18'))// 根据【修改hdr设置】文字长度，设置宽度为120
          .width(this.currentTask === Tasks.HDR ? $r('app.float.size_120') : $r('app.float.size_40'))
          .height($r('app.float.size_30'))

        Image($r('app.media.ic_ok'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
          .margin({ right: '10%' })
          .onClick(() => {
            if (this.currentTask === Tasks.ENCODEJS || this.currentTask === Tasks.DECODEJS) {
              this.currentTask = Tasks.ADJUST;
              this.cropIndex = 0;
            }
            if (this.currentTask === Tasks.ENCODENDK || this.currentTask === Tasks.DECODENDK) {
              this.currentTask = Tasks.MARK;
              this.cropIndex = 0;
            }
            this.outSetValueOne = 0;
          })
          .id('ok')
      }
    }
    .backgroundColor($r('app.color.edit_image_public_background'))
    .height('9%')
    .width('100%')
  }

  @Builder
  getMarkTool() {
    Row() {
      List() {
        ForEach(pictureNdkDatas, (item: TaskData, index) => {
          ListItem() {
            Column() {
              Image(item.image)
                .width($r('app.float.size_30'))
                .height($r('app.float.size_30'))
              Text(item.text)
                .fontColor(Color.White)
                .fontSize($r('app.float.size_15'))
                .margin({ top: $r('app.float.size_5') })
            }
            .id(item.name)
            .justifyContent(FlexAlign.Center)
            .height('100%')
            .width('40%')
            .margin(index === 0 ? { left: '10%' } : { right: '10%' })
            .onClick(async () => {
              await this.onSelectItem(item);
            })

          }
        })
      }
      .listDirection(Axis.Horizontal) // 排列方向
      .width('100%')
      .height('14%')
    }
    .backgroundColor($r('app.color.edit_image_public_background'))
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  getAdjustTool() {
    Row() {
      List() {
        ForEach(pictureJsDatas, (item: TaskData, index) => {
          ListItem() {
            Column() {
              Image(item.image)
                .width($r('app.float.size_30'))
                .height($r('app.float.size_30'))
              Text(item.text)
                .fontColor(Color.White)
                .fontSize($r('app.float.size_15'))
                .margin({ top: $r('app.float.size_5') })
            }
            .id(item.name)
            .justifyContent(FlexAlign.Center)
            .height('100%')
            .width('40%')
            .onClick(async () => {
              if (item.task !== undefined) {
                this.currentTask = item.task;
              }
              if (item.text !== undefined) {
                this.cancelOkText = item.text
              }
              this.originBM = await copyPixelMap(this.pixelMap!) // 拷贝
              // 保存到队列
              this.pixelMapQueue.push(this.originBM);
            })
          }
        })
      }
      .listDirection(Axis.Horizontal) // 排列方向
      .height('14%')
    }
    .backgroundColor($r('app.color.edit_image_public_background'))
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  TextOrStickerScroll(materials: MaterialData[]) {
    Row() {
      Scroll() {
        List({ scroller: this.scroller }) {
          ForEach(materials, (item: MaterialData, index: number) => {
            ListItem() {
              Column() {
                if (item instanceof FontColorData) {
                  Text(item.getResource())
                    .visibility(Visibility.Hidden)
                    .width($r('app.float.size_40'))
                    .height($r('app.float.size_40'))
                } else {
                  Image(item.getResource())
                    .width($r('app.float.size_40'))
                    .height($r('app.float.size_40'))
                }
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius($r('app.float.size_10'))
              .border(this.resourceIndex === index ?
                {
                  width: $r('app.float.size_3'),
                  color: $r('app.color.edit_image_mark_scroll_selected'),
                  radius: $r('app.float.size_10')
                } : { width: $r('app.float.size_0'), color: $r('app.color.edit_image_mark_scroll') })
              .backgroundColor(this.currentTask === Tasks.STICKER ? $r('app.color.edit_image_mark_scroll') : item.getResource())
              .width($r('app.float.size_45'))
              .height($r('app.float.size_45'))
              .onClick(() => {
                this.resourceIndex = index;
                this.selectedResource = item.getResource();
              })
            }
            .height('100%')
            .width('17%')
          })
        }
        .listDirection(Axis.Horizontal) // 排列方向
        .height('14%')
      }
      .padding({ left: $r('app.float.size_30'), right: $r('app.float.size_30') })
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
    }
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.edit_image_public_background'))
    .width('100%')
  }

  @Builder
  getTopBar() {
    Row() {
      Image($r('app.media.ic_public_back'))
        .id('back')
        .fillColor(Color.White)
        .width($r('app.float.size_32'))
        .height($r('app.float.size_32'))
        .onClick(() => {
          router.back()
        })
    }

    .width('100%')
    .padding({ left: $r('app.float.size_14') })
    .margin({ top: $r('app.float.size_20') });
  }

  getResolutionText(): string {
    const tip: string = getContext(this).resourceManager.getStringSync($r('app.string.edit_image_resolution'));
    return tip + this.dpi;
  }

  @Builder
  pictureDecodingToolJs() {
    Row() {
      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.picture_decode_jpeg'))
          .margin({ top: $r('app.float.size_5') })
          .fontSize($r('app.float.size_14'))
          .fontColor(Color.White)
      }
      .id('jpegJs')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.decodingPictureJs(this.pictureStatus1, this.auxiliaryType); // jpeg
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.picture_decode_heif'))
          .margin({ top: $r('app.float.size_5') })
          .fontColor(Color.White)
          .fontSize($r('app.float.size_14'))
      }
      .id('heifJs')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.heifFileName;
        await this.decodingPictureJs(this.pictureStatus2, this.auxiliaryType); // heif
      })
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor($r('app.color.edit_image_public_background'))
    .height('14%')
    .width('100%')
  }

  @Builder
  pictureEncodingToolJs() {
    Row() {
      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.source_encode_buffer'))// 0, 0
          .margin({ top: $r('app.float.size_5') })
          .fontSize($r('app.float.size_14'))
          .fontColor(Color.White)
      }
      .id('sourceToDataJs')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.encodingPictureJs(this.pushState1, this.outState1);
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.source_encode_file'))// 0, 1
          .margin({ top: $r('app.float.size_5') })
          .fontSize($r('app.float.size_14'))
          .fontColor(Color.White)
      }
      .id('sourceToFileJs')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.encodingPictureJs(this.pushState1, this.outState2);
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.picture_encode_buffer'))// 1, 0
          .margin({ top: $r('app.float.size_5') })
          .fontColor(Color.White)
          .fontSize($r('app.float.size_14'))
      }
      .id('pictureToDataJs')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.encodingPictureJs(this.pushState2, this.outState1);
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.picture_encode_file'))// 1, 1
          .margin({ top: $r('app.float.size_5') })
          .fontColor(Color.White)
          .fontSize($r('app.float.size_14'))
      }
      .id('pictureToFileJs')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.encodingPictureJs(this.pushState2, this.outState2);
      })
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor($r('app.color.edit_image_public_background'))
    .height('14%')
    .width('100%')
  }

  @Builder
  pictureDecodingToolNdk() {
    Row() {
      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.picture_decode_jpeg'))
          .margin({ top: $r('app.float.size_5') })
          .fontSize($r('app.float.size_14'))
          .fontColor(Color.White)
      }
      .id('jpegNdk')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.decodingPictureNdk(this.auxiliaryType, this.jpegFileName);
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.picture_decode_heif'))
          .margin({ top: $r('app.float.size_5') })
          .fontColor(Color.White)
          .fontSize($r('app.float.size_14'))
      }
      .id('heifNdk')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.heifFileName;
        await this.decodingPictureNdk(this.auxiliaryType, this.heifFileName);
      })
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor($r('app.color.edit_image_public_background'))
    .height('14%')
    .width('100%')
  }

  @Builder
  pictureEncodingToolNdk() {
    Row() {
      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.source_encode_file'))
          .margin({ top: $r('app.float.size_5') })
          .fontSize($r('app.float.size_14'))
          .fontColor(Color.White)
      }
      .id('sourceToFileNdk')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.encodingPictureNdk(this.jpegFileName, 'imageSource', 'file');
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.source_encode_buffer'))
          .margin({ top: $r('app.float.size_5') })
          .fontColor(Color.White)
          .fontSize($r('app.float.size_14'))
      }
      .id('sourceToDataNdk')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.encodingPictureNdk(this.jpegFileName, 'imageSource', 'data');
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.picture_encode_file'))
          .margin({ top: $r('app.float.size_5') })
          .fontSize($r('app.float.size_14'))
          .fontColor(Color.White)
      }
      .id('pictureToFileNdk')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.encodingPictureNdk(this.jpegFileName, 'picture', 'file');
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.picture_encode_buffer'))
          .margin({ top: $r('app.float.size_5') })
          .fontColor(Color.White)
          .fontSize($r('app.float.size_14'))
      }
      .id('pictureToDataNdk')
      .onClick(async () => {
        this.pixelMap = null;
        this.showPicture = this.jpegFileName;
        await this.encodingPictureNdk(this.jpegFileName, 'picture', 'data');
      })
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor($r('app.color.edit_image_public_background'))
    .height('14%')
    .width('100%')
  }

  build() {
    Column() {
      // 顶部功能区
      this.getTopBar()
      // 中间操作区
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          Row() {
            Text('Source graph：')
              .fontSize(20)
              .margin({ left: 5, right: 80 })
              .fontColor(Color.White)
            Text('Result graph：')
              .fontSize(20)
              .fontColor(Color.White)
          }
          .height(50)
          .width('100%')

          Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row }) {
            Image($rawfile(this.showPicture))
              .width('100%')
              .height(300)
              .objectFit(ImageFit.Contain)
              .margin(5)
            Image(this.pixelMap)
              .width('100%')
              .height(300)
              .objectFit(ImageFit.Contain)
              .margin(5)
          }
        }
      }.layoutWeight(1)
      .onAreaChange((newValue: Area) => {
        this.containerArea = newValue;
      })

      // 底部菜单栏
      Column() {
        if (this.currentTask === Tasks.MARK) {
          this.getMarkTool();
        } else if (this.currentTask === Tasks.ADJUST) {
          this.getAdjustTool();
        } else if (this.currentTask === Tasks.ENCODEJS) {
          this.pictureEncodingToolJs();
        } else if (this.currentTask === Tasks.DECODEJS) {
          this.pictureDecodingToolJs();
        } else if (this.currentTask === Tasks.ENCODENDK) {
          this.pictureEncodingToolNdk();
        } else if (this.currentTask === Tasks.DECODENDK) {
          this.pictureDecodingToolNdk();
        }
        if (this.currentTask === Tasks.MARK || this.currentTask === Tasks.ADJUST) {
          this.getFirstLvMenu();
        } else {
          this.CancelOrOk(this.cancelOkText!);
        }
      }
      .width('100%')
    }
    .backgroundColor(Color.Black)
    .width('100%')
    .height('100%')
  }
}