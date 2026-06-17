/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { image } from '@kit.ImageKit';
import { Decode } from '../common/Decode';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import Logger from '../common/Logger';
import { readAndEditEXIF } from '../common/EditingEXIF';
import { encodeToStreamByPixelMap } from '../common/Encode';
import { DisplayInfo } from '../utils/DisplayInfoUtil';

const DEFAULT_IMAGE_WIDTH = 700; // 图像的默认宽度
const DEFAULT_IMAGE_HEIGHT = 700; // 图像的默认高度
const MAX_RGB_VALUE = 255; // RGB格式的最大值
const MIN_RGB_VALUE = 0; // RGB格式的最小值
const MAX_OPACITY = 255; // RGBA8888格式的透明度的的最大值

// [Start pixelmap_clone]
/**
 * 复制（深拷贝）PixelMap并改变像素格式。
 *
 * @param pixelMap - 被复制的原PixelMap。
 * @param desiredPixelFormat - 新PixelMap的像素格式。如果不指定，则仍使用原PixelMap的像素格式。
 * @returns 新PixelMap的Promise。
 */
async function clonePixelMap(pixelMap: PixelMap, desiredPixelFormat?: image.PixelMapFormat): Promise<PixelMap> {
  // 获取原PixelMap的图片信息。
  const imageInfo = pixelMap.getImageInfoSync();
  // 读取原PixelMap的像素数据，并按照原PixelMap的像素格式写入缓冲区。
  const buffer = new ArrayBuffer(pixelMap.getPixelBytesNumber());
  await pixelMap.readPixelsToBuffer(buffer);

  // 根据原PixelMap的图片信息，生成初始化选项。
  const options: image.InitializationOptions = {
    // 数据源的像素格式：必须匹配原PixelMap的像素格式，否则新PixelMap的图像会出现异常。
    srcPixelFormat: imageInfo.pixelFormat,
    // 新PixelMap的像素格式。
    pixelFormat: desiredPixelFormat || imageInfo.pixelFormat,
    // 新PixelMap的透明度类型。
    alphaType: imageInfo.alphaType,
    // 新PixelMap的尺寸：必须匹配原PixelMap的尺寸，不支持传入其他尺寸以进行缩放。
    size: imageInfo.size
  };

  // 根据像素数据和初始化选项，创建新PixelMap。
  return await image.createPixelMap(buffer, options);
}
// [End pixelmap_clone]

// [Start pixelmap_concatenation]
/**
 * 将两张宽度相同的PixelMap纵向拼接成一张长图。
 *
 * @param pixelMap1 - 第一张PixelMap。
 * @param pixelMap2 - 第二张PixelMap。宽度必须与第一张相同，高度可以不同。
 * @returns 拼接后的新PixelMap的Promise。
 */
async function concatPixelMap(pixelMap1: PixelMap, pixelMap2: PixelMap): Promise<PixelMap> {
  // 将pixelMap1的像素数据读取至area1.pixels中。
  const imageInfo1 = pixelMap1.getImageInfoSync();
  const area1: image.PositionArea = {
    pixels: new ArrayBuffer(pixelMap1.getPixelBytesNumber()),
    offset: 0,
    stride: pixelMap1.getBytesNumberPerRow(),
    region: {
      size: imageInfo1.size,
      x: 0,
      y: 0
    }
  };
  await pixelMap1.readPixels(area1);

  // 将pixelMap2的像素数据读取至area2.pixels中。
  const imageInfo2 = pixelMap2.getImageInfoSync();
  const area2: image.PositionArea = {
    pixels: new ArrayBuffer(pixelMap2.getPixelBytesNumber()),
    offset: 0,
    stride: pixelMap2.getBytesNumberPerRow(),
    region: {
      size: imageInfo2.size,
      x: 0,
      y: 0
    }
  };
  await pixelMap2.readPixels(area2);

  // 创建一个新的空白PixelMap，其宽度与pixelMap1和pixelMap2相等，高度为pixelMap1和pixelMap2相加。
  const options: image.InitializationOptions = {
    srcPixelFormat: imageInfo1.pixelFormat,
    pixelFormat: imageInfo1.pixelFormat,
    size: {
      width: imageInfo1.size.width,
      height: imageInfo1.size.height + imageInfo2.size.height
    }
  };
  const newPixelMap = image.createPixelMapSync(options);

  // 将之前获取的pixelMap1和pixelMap2的像素数据按顺序写入新PixelMap。
  await newPixelMap.writePixels(area1);
  area2.region.y = imageInfo1.size.height; // pixelMap2像素的写入位置应该从pixelMap1末行像素的下一行开始。
  await newPixelMap.writePixels(area2);

  return newPixelMap;
}
// [End pixelmap_concatenation]


@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @State isImageChange: boolean = false;
  @State pixelMap: image.PixelMap | undefined = undefined;
  @State oldPixelMap: image.PixelMap | undefined = undefined;
  @State imageInfo: image.ImageInfo | undefined = undefined;
  @State changeFlag: boolean = false;
  displayInfo = new DisplayInfo();
  decode = new Decode();

  async aboutToAppear() {
    Logger.info('aboutToAppear Start');
    this.pixelMap = await this.loadPixelMap();
    this.oldPixelMap = await clonePixelMap(this.pixelMap);
    encodeToStreamByPixelMap(this.pixelMap, false);
    await this.updateImageInfo();
    Logger.info('aboutToAppear End');
  }

  private async loadPixelMap(): Promise<image.PixelMap> {
    return new Promise((resolve, reject) => {
      this.decode.decodeByFormat().then((pixelMap) => {
        Logger.info('getPixelMap Succeeded');
        resolve(pixelMap);
      }).catch((err: BusinessError) => {
        Logger.error('Error occurred while decoding: ', String(err));
        reject(err);
      });
    });
  }

  aboutToDisappear(): void {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_release_pixelmap]
      this.pixelMap.release();
      // [End pixelmap_release_pixelmap]
    }
    if (this.oldPixelMap != undefined) {
      this.oldPixelMap.release();
    }
  }

  // 生成 tab 的函数
  @Builder
  tabBuilder(index: number, text: Resource) {
    Column() {
      Text(text)
        .fontSize($r('app.float.size_16'))
        .fontColor(this.currentIndex === index ? $r('app.color.black') : $r('app.color.grey'))
    }.justifyContent(FlexAlign.Center)
  }

  @Builder
  functionButton(icon: Resource, text: Resource, onClick: () => void) {
    Column() {
      Image(icon)
        .width($r('app.float.size_30'))
        .height($r('app.float.size_30'))
      Text(text)
        .fontSize($r('app.float.size_16'))
        .fontColor($r('app.color.grey'))
    }
    .onClick(() => onClick())
  }

  build() {
    Column({ space: 20 }) {
      Row() {
        Text($r('app.string.edit_image'))
          .fontSize(25)
        this.functionButton($r('app.media.ic_reset_image'), $r('app.string.reset_image'), (): void => { this.resetImage(); })
      }.justifyContent(FlexAlign.SpaceAround)
      .height('10%')
      .width('100%')

      Column() {
        // 对于class、object和数组类型,框架仅能观察到@State变量第一层属性的变化。导致图片无法刷新，所以设置changeFlag标识辅助UI刷新
        if (this.changeFlag == true) {
          Image(this.pixelMap)
            .height(this.displayInfo.getHeight(this.imageInfo != undefined ? this.imageInfo.size.height : 0))
            .width(this.displayInfo.getWidth(this.imageInfo != undefined ? this.imageInfo.size.width : 0))
        } else {
          Image(this.pixelMap)
            .height(this.displayInfo.getHeight(this.imageInfo != undefined ? this.imageInfo.size.height : 0))
            .width(this.displayInfo.getWidth(this.imageInfo != undefined ? this.imageInfo.size.width : 0))
        }
      }
      .height(this.displayInfo.getHeight(DEFAULT_IMAGE_HEIGHT))
      .width(this.displayInfo.getWidth(DEFAULT_IMAGE_WIDTH))
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .clip(true)

      Column() {
        Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
          TabContent() {
            Row() {
              this.functionButton($r('app.media.ic_crop'), $r('app.string.crop'),
                (): void => this.cropImage());
              this.functionButton($r('app.media.ic_scale'), $r('app.string.scale'),
                (): void => this.scaleImage());
              this.functionButton($r('app.media.ic_translate'), $r('app.string.translate'),
                (): void => this.translateImage());
            }.justifyContent(FlexAlign.SpaceAround)
            .width('100%')
          }.tabBar(this.tabBuilder(0, $r('app.string.cut')))

          TabContent() {
            Row() {
              this.functionButton($r('app.media.ic_clockwise_rotate'), $r('app.string.clockwise_rotate'),
                (): void => this.rotateImage());
              this.functionButton($r('app.media.ic_vertical_flip'), $r('app.string.vertical_flip'),
                (): void => this.verticalFlipImage());
              this.functionButton($r('app.media.ic_horizontal_flip'), $r('app.string.horizontal_flip'),
                (): void => this.horizontalFlipImage());
            }.justifyContent(FlexAlign.SpaceAround)
            .width('100%')
          }.tabBar(this.tabBuilder(1, $r('app.string.flip')))

          TabContent() {
            Row() {
              this.functionButton($r('app.media.ic_bitmap_operation'), $r('app.string.bitmap_operation'),
                async (): Promise<void> => this.bitmapOperation());
              this.functionButton($r('app.media.ic_bitmap_operation'), $r('app.string.bitmap_operation_all'),
                async (): Promise<void> => this.bitmapOperationAll());
              this.functionButton($r('app.media.ic_change_opacity'), $r('app.string.change_opacity'),
                (): void => this.changeOpacityImage());
            }.justifyContent(FlexAlign.SpaceAround)
            .width('100%')
          }.tabBar(this.tabBuilder(2, $r('app.string.toning')))

          TabContent() {
            Row() {
              this.functionButton($r('app.media.ic_save_image'), $r('app.string.save_image'),
                (): void => {
                  if (this.pixelMap != undefined) {
                    encodeToStreamByPixelMap(this.pixelMap, false);
                  }
                })
              this.functionButton($r('app.media.ic_open_image'), $r('app.string.open_image'),
                async (): Promise<void> => await this.openImage());
              this.functionButton($r('app.media.ic_edit_EXIF'), $r('app.string.edit_EXIF'),
                (): void => {
                  let fileName: string = getContext(this).cacheDir + '/pixel_map.jpg';
                  let fd: number = fs.openSync(fileName, fs.OpenMode.READ_WRITE).fd;
                  readAndEditEXIF(fd);
                })
            }.justifyContent(FlexAlign.SpaceAround)
            .width('100%')
          }.tabBar(this.tabBuilder(3, $r('app.string.file_operation')))

        }
        .height('20%')
        .width('100%')
        .vertical(false)
        .barMode(BarMode.Fixed)
        .scrollable(true)
        .onChange((index: number) => {
          this.currentIndex = index;
        })
      }
    }.height('100%')
    .width('100%')

  }

  private async resetImage() {
    if (this.pixelMap != undefined) {
      this.pixelMap.release();
    }
    this.pixelMap = await clonePixelMap(this.oldPixelMap!);
    this.updateImageInfo();
  }

  private async updateImageInfo() {
    this.changeFlag = !this.changeFlag;
    if (this.pixelMap != undefined) {
      // [Start pixelmap_get_image_info]
      // 获取图片大小。
      await this.pixelMap.getImageInfo().then((info: image.ImageInfo) => {
        this.imageInfo = info;
        Logger.info('Image width: ', info.size.width.toString());
        Logger.info('Image height: ', info.size.height.toString());
      }).catch((err: BusinessError) => {
        Logger.error('Failed to obtain the image pixel map information. The error is: ', String(err));
      });
      // [End pixelmap_get_image_info]
    }
  }

  // 裁剪大小为400×400
  private cropImage() {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_crop_image]
      // x：裁剪起始点横坐标0。
      // y：裁剪起始点纵坐标0。
      // height：裁剪高度400，方向为从上往下（裁剪后的图片高度为400）。
      // width：裁剪宽度400，方向为从左到右（裁剪后的图片宽度为400）。
      this.pixelMap.crop({ x: 0, y: 0, size: { height: 400, width: 400 } }).then(() => {
        // [StartExclude pixelmap_crop_image]
        this.updateImageInfo();
        // [EndExclude pixelmap_crop_image]
      });
      // [End pixelmap_crop_image]
    }
  }

  // 缩放图片大小为原来的1/2
  private scaleImage() {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_scale_image]
      // 宽为原来的0.5倍。
      // 高为原来的0.5倍。
      this.pixelMap.scale(0.5, 0.5).then(() => {
        // [StartExclude pixelmap_scale_image]
        this.updateImageInfo();
        // [EndExclude pixelmap_scale_image]
      });
      // [End pixelmap_scale_image]
    }
  }

  // 向右下移动图片
  private translateImage() {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_translate_image]
      // 向下平移100。
      // 向右平移100。
      this.pixelMap.translate(100, 100).then(() => {
        // [StartExclude pixelmap_translate_image]
        // 平移后图片变为800×800，重新裁剪为700×700。
        if (this.imageInfo!.size.height == 700) {
          this.pixelMap!.crop({ x: 0, y: 0, size: { height: 700, width: 700 } }).then(() => {
            this.updateImageInfo();
          });
        } else { // 如果图片已缩小，则不必重新裁剪。
          this.updateImageInfo();
        }
        // [EndExclude pixelmap_translate_image]
      });
      // [End pixelmap_translate_image]
    }
  }

  // 顺时针旋转图片
  private rotateImage() {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_rotate_image]
      // 顺时针旋转90°。
      this.pixelMap.rotate(90).then(() => {
        // [StartExclude pixelmap_rotate_image]
        this.updateImageInfo();
        // [EndExclude pixelmap_rotate_image]
      });
      // [End pixelmap_rotate_image]
    }
  }

  // 垂直翻转图片
  private verticalFlipImage() {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_vertical_flip_image]
      // 垂直翻转。
      this.pixelMap.flip(false, true).then(() => {
        // [StartExclude pixelmap_vertical_flip_image]
        this.updateImageInfo();
        // [EndExclude pixelmap_vertical_flip_image]
      });
      // [End pixelmap_vertical_flip_image]
    }
  }

  // 水平翻转图片
  private horizontalFlipImage() {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_horizontal_flip_image]
      // 水平翻转。
      this.pixelMap.flip(true, false).then(() => {
        // [StartExclude pixelmap_horizontal_flip_image]
        this.updateImageInfo();
        // [EndExclude pixelmap_horizontal_flip_image]
      });
      // [End pixelmap_horizontal_flip_image]
    }
  }

  // 将图像中所有像素的透明度改为0.5
  private changeOpacityImage() {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_change_opacity_image]
      // 将所有像素的透明度改为0.5。
      this.pixelMap.opacity(0.5).then(() => {
        // [StartExclude pixelmap_change_opacity_image]
        this.updateImageInfo();
        // [EndExclude pixelmap_change_opacity_image]
      });
      // [End pixelmap_change_opacity_image]
    }
  }

  // 位图操作所有像素
  private async bitmapOperationAll() {
    if (this.pixelMap != undefined) {
      // [Start pixelmap_get_pixelmap_info]
      // 获取图像像素的总字节数。
      let pixelBytesNumber: number = this.pixelMap.getPixelBytesNumber();
      Logger.info('Total bytes: ', pixelBytesNumber.toString());
      // 获取图像像素的每行字节数。
      let rowBytes: number = this.pixelMap.getBytesNumberPerRow();
      Logger.info('Row bytes: ', rowBytes.toString());
      // 获取当前图像的像素密度。像素密度是指每英寸图片所拥有的像素数量，像素密度越大，图片越精细。
      let getDensity: number = this.pixelMap.getDensity();
      Logger.info('Density: ', getDensity.toString());
      // [End pixelmap_get_pixelmap_info]

      // [Start pixelmap_bitmap_operation_all]
      // 场景一：读取并修改整张图像数据。
      // 读取整个PixelMap的像素数据，并按照PixelMap的像素格式写入缓冲区。
      const buffer = new ArrayBuffer(pixelBytesNumber);
      await this.pixelMap.readPixelsToBuffer(buffer).then(() => {
        Logger.info('Succeeded in reading image pixel data.');
      }).catch((error: BusinessError) => {
        Logger.error('Failed to read image pixel data. The error is: ' + String(error));
      });
      // [StartExclude pixelmap_bitmap_operation_all]
      const bufferArr: Uint8Array = new Uint8Array(buffer);
      // RGBA_8888格式下，一个像素点由4个字节组成，分别表示Red、Green、Blue、Alpha四个通道的值。
      for (let i = 0; i < bufferArr.length; i++) {
        switch (i % 4) {
          case 0:
            bufferArr[i] = MAX_RGB_VALUE;
            break;
          case 1:
            bufferArr[i] = MAX_RGB_VALUE;
            break;
          case 2:
            bufferArr[i] = MIN_RGB_VALUE;
            break;
          case 3:
            bufferArr[i] = MAX_OPACITY;
            break;
          default:
            break;
        }
      }
      // [EndExclude pixelmap_bitmap_operation_all]
      // 按照PixelMap的像素格式，读取缓冲区内的图像像素数据，并将其写入整个PixelMap。
      this.pixelMap!.writeBufferToPixels(buffer).then(() => {
        Logger.info('Succeeded in writing image pixel data.');
        this.updateImageInfo();
      }).catch((error: BusinessError) => {
        Logger.error('Failed to write image pixel data. The error is: ' + String(error));
      });
      // [End pixelmap_bitmap_operation_all]
    }
  }

  // 位图操作部分像素
  private async bitmapOperation() {
    if (this.pixelMap !== undefined) {
      // [Start pixelmap_bitmap_operation]
      // 场景二：读取并修改指定区域内的图像数据。
      // 读取PixelMap指定区域内的像素数据，并按照RGBA_8888像素格式写入PositionArea.pixels缓冲区，该区域由PositionArea.region指定。
      const regionWidth: number = 200;
      const regionHeight: number = 100;
      const area: image.PositionArea = {
        pixels: new ArrayBuffer(regionWidth * regionHeight * 4), // BGRA_8888格式的每个像素占4字节。
        offset: 0,
        stride: regionWidth * 4, // 指定区域的行跨距。
        region: {
          x: 0,
          y: 0,
          size: { width: regionWidth, height: regionHeight }
        }
      };

      await this.pixelMap.readPixels(area).then(() => {
        Logger.info('Succeeded in reading the image data in the area.');
        // [StartExclude pixelmap_bitmap_operation]
        // 对于读取的图片数据，可以独立使用（创建新的PixelMap），也可以对area.pixels进行所需修改。
        // BGRA_8888格式下，一个像素点由4个字节组成，分别表示Blue、Green、Red、Alpha四个通道的值。
        const pixelsArr = new Uint8Array(area.pixels);
        for (let i = 0; i < pixelsArr.length; i++) {
          switch (i % 4) {
            case 0:
              pixelsArr[i] = MAX_RGB_VALUE;
              break;
            case 1:
              pixelsArr[i] = MAX_RGB_VALUE;
              break;
            case 2:
              pixelsArr[i] = MIN_RGB_VALUE;
              break;
            case 3:
              pixelsArr[i] = MAX_OPACITY;
              break;
            default:
              break;
          }
        }
        // [EndExclude pixelmap_bitmap_operation]
      }).catch((error: BusinessError) => {
        Logger.error('Failed to read the image data in the area. The error is: ' + String(error));
      });
      // 读取PositionArea.pixels缓冲区内的图像像素数据，并按照BGRA_8888像素格式将其写入PixelMap的指定区域，该区域由PositionArea.region指定。
      await this.pixelMap.writePixels(area).then(() => {
        this.updateImageInfo();
        Logger.info('Succeeded to write pixelMap into the specified area.');
      }).catch((error: BusinessError) => {
        Logger.error('Failed to write pixelMap into the specified area. The error is: ' + String(error));
      });
      // [End pixelmap_bitmap_operation]
    }
  }

  private async openImage() {
    const imageSource: image.ImageSource = this.decode.getImageSourceByFilePath('/pixel_map.jpg');
    this.pixelMap = await this.decode.decodeByFormatWithParameter(imageSource);
  }
}