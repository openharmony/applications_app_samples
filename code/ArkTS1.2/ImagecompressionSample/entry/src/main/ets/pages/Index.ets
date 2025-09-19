'use static';
/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement';
import { Entry, Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, Row, TextAlign,
  SafeAreaEdge, Visibility, List, ListItem, ForEach, TextOverflow, Image, HorizontalAlign, Progress, ProgressType, Flex,
  FlexAlign, FlexDirection, SafeAreaType, Stack, Radio, Slider, SliderStyle, ButtonType,
  Scroll, Scroller, BarState, $r, Builder, Blank, Color, ImageFit, TextInput, InputType, Placement, ItemAlign, Divider,
  JSON, DialogAlignment, Resource, JSON, ResourceStr, ImageCompleteEvent, ImageOnCompleteCallback, Margin, $rawfile }
  from '@ohos.arkui.component';
import { State, Link, MutableState, stateOf, observableProxy,  Watch } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import zlib from '@ohos.zlib';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import resourceManager from '@ohos.resourceManager';
import { BusinessError } from '@ohos.base';
import { PromptAction, UIContext } from '@ohos.arkui.UIContext';
import fileUri from '@ohos.file.fileuri';

enum PhotoFormat {
  Jpeg,
  Heif
}

const TAG = 'IMAGE_COMPRESSION';
const FONT_WEIGHT: number = 500;
const BYTE_CONVERSION: number = 1024; // 字节转换
const IMAGE_QUALITY_ZERO: number = 0; // 图片质量0
const IMAGE_QUALITY_HUNDRED: number = 100; // 图片质量100
const LAYOUT_WEIGHT: number = 1;
const SLIDER_ZERO_POINT_ZERO_ONE: number = 0.01;
const SLIDER_ZERO_POINT_FIVE: number = 0.50;
const SLIDER_ZERO: number = 0;
const SLIDER_ONE: number = 1;
const SLIDER_THIRTY: number = 30;
const SLIDER_ONE_HUNDRED: number = 100;

@Entry
@Component
export struct ImageCompressionComponent {
  @State beforeCompressFmt: string = ''; // 压缩前图片格式
  @State afterCompressFmt: string = ''; // 压缩后图片格式
  @State strMaxCompressedImageSize: string = '80'; // 指定图片压缩目标大小
  @State afterCompressionSize: string = '0'; // 压缩后的图片大小,单位kb
  @State isAutoMode: boolean = true; // 是否自动压缩模式
  @State isQualityPriority: boolean = true; // 是否质量优先
  @State imageQualityVal: number = 100; // 图片质量
  @State autoModeQuality: number = 0; // 自动模式保存图片的质量
  @State imageScaleVal: number = 100; // 图片缩放尺寸
  @State reduceScaleVal: number = 0.40; // 自动压缩如果需要压缩尺寸，在循环压缩尺寸过程中设置每次缩小的尺寸倍数
  @State minBisectUnit: number = 10; // packing最小二分单位
  @State minQuality: number = 100; // 最低图片质量
  @State afterCompressImgSize: string = ''; // 压缩后图片宽高
  private scrollerForLiftUp: Scroller = new Scroller();
  private maxCompressedImageSize: number = 0; // 指定图片压缩目标大小，单位kb
  private beforeFormat: PhotoFormat = PhotoFormat.Jpeg; // 压缩前图片格式
  private afterFormat: PhotoFormat = PhotoFormat.Jpeg; // 压缩后图片格式
  private sourceUri: string = ''; // 输入图片地址
  private outputPath: string = ''; // 输出图片文件夹
  private outputPureUri: string = ''; // 输出图片地址（不带后缀）
  private photoMime: string = ''; // 输出图片的mime
  private outputFullUri: string = ''; // 输出图片完整地址
  @State outputShowUri: string = ''; // 输出图片完整地址用于显示图片

  aboutToAppear(): void {
    const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let filesDir = context.filesDir;
    this.sourceUri = filesDir + '/source.jpg'; // 输入图片地址
    this.outputPath = filesDir + '/output'; // 输出图片文件夹
    this.outputPureUri = this.outputPath + '/result'; // 输出图片地址（不带后缀）

    // 图片拷贝到沙箱
    let uint8Array: Uint8Array = context.resourceManager.getRawFileContentSync('source.jpg');
    let bf: ArrayBuffer = uint8Array.buffer as ArrayBuffer;
    const fsOpen = fs.openSync(this.sourceUri, fs.OpenMode.READ_WRITE | fs.OpenMode.READ_ONLY |
    fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
    fs.writeSync(fsOpen.fd, bf);
    fs.closeSync(fsOpen);

    // 图片格式
    this.beforeFormat = PhotoFormat.Jpeg;
    this.beforeCompressFmt = this.getPhotoShowFormat(this.beforeFormat);
    this.afterFormat = this.beforeFormat;
  }

  /**
   * 自动压缩
   */
  autoCompression() {
    const res = fs.accessSync(this.outputPath);
    if (res) {
      fs.rmdirSync(this.outputPath);
    }
    try {
      fs.mkdirSync(this.outputPath);
    } catch (e: Error) {
      hilog.error(0x0000, 'testTag', '创建目录失败' + JSON.stringify(e));
    }

    this.setPhotoProperty();

    const file = fs.openSync(this.sourceUri, fs.OpenMode.READ_ONLY);
    let buffer: ArrayBuffer = new ArrayBuffer(fs.statSync(file.fd).size);
    // 读取图片到buffer
    fs.readSync(file.fd, buffer);
    fs.closeSync(file);
    // 通过缓冲区创建图片源实例
    const imageSource: image.ImageSource = image.createImageSource(buffer as ArrayBuffer);
    // 设置解码参数DecodingOptions，解码获取PixelMap图片对象。
    const decodingOptions: image.DecodingOptions = {
      editable: true,
    } as image.DecodingOptions;
    // 创建pixelMap
    (imageSource.createPixelMapUsingAllocator(decodingOptions, image.AllocatorType.AUTO) as
    Promise<image.PixelMap>).then((originalPixelMap: image.PixelMap) => {
      // 压缩图片
      this.compressedImage(originalPixelMap, this.maxCompressedImageSize, buffer).then(() => {
        let promptAction: PromptAction = this.getUIContext().getPromptAction();
        promptAction.showToast({
          message: '压缩完成',
          duration: 2000
        });
      })
    }).catch((err: Error) => {
      hilog.error(0x0000, 'testTag', `Failed to create PixelMap, message: ${err}.`);
    });
  }

  async packingPicture(sourcePixelMap: image.PixelMap, imageQuality: int,
    packingFormat: string): Promise<ArrayBuffer> {
    let pictureObj: image.Picture = image.createPicture(sourcePixelMap);
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    let packOpts: image.PackingOption = {
      format: 'image/' + packingFormat,
      quality: imageQuality,
    } as image.PackingOption;
    const data: ArrayBuffer =
      await imagePackerApi.packing(pictureObj as image.Picture, packOpts as image.PackingOption);
    return data;
  }

  /**
   * 手动压缩
   */
  manualCompression() {
    const res = fs.accessSync(this.outputPath);
    if (res) {
      fs.rmdirSync(this.outputPath);
    }
    try {
      fs.mkdirSync(this.outputPath);
    } catch (e: Error) {
      hilog.error(0x0000, 'testTag', '创建目录失败' + JSON.stringify(e));
    }

    this.setPhotoProperty();

    const file = fs.openSync(this.sourceUri, fs.OpenMode.READ_ONLY);
    let buffer: ArrayBuffer = new ArrayBuffer(fs.statSync(file.fd).size) as ArrayBuffer;
    fs.readSync(file.fd, buffer);
    fs.closeSync(file);
    const decodingOptions: image.DecodingOptions = { editable: true } as image.DecodingOptions;
    const imageSource: image.ImageSource = image.createImageSource(buffer as ArrayBuffer);

    (imageSource.createPixelMapUsingAllocator(decodingOptions, image.AllocatorType.AUTO) as
    Promise<image.PixelMap>).then(async (originalPixelMap: image.PixelMap) => {
      // 使用scale对图片进行缩放。入参分别为图片宽高的缩放倍数
      await originalPixelMap.scale((this.imageScaleVal / 100.0) as float, (this.imageScaleVal / 100.0) as float);
      let compressedImageData: ArrayBuffer =
        await this.packingPicture(originalPixelMap, (this.imageQualityVal * 1) as int, this.photoMime);
      let imageSource = image.createImageSource(compressedImageData);
      let opts: image.DecodingOptions = { editable: true };
      // showPixelMap用于显示压缩后的图片
      let showPixelMap: image.PixelMap = await imageSource.createPixelMapUsingAllocator(opts as image.DecodingOptions,
        image.AllocatorType.AUTO);
      let imageInfo: image.ImageInfo = showPixelMap.getImageInfoSync();
      this.afterCompressImgSize = String(imageInfo.size.width) + '*' + String(imageInfo.size.height);
      this.afterCompressionSize = ((compressedImageData.byteLength / BYTE_CONVERSION) as Number).toFixed(1);

      let packOpts: image.PackingOption =
        { format: 'image/' + this.photoMime, quality: (this.imageQualityVal * 1) as int } as image.PackingOption;
      let fileImg = fs.openSync(this.outputFullUri, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
      const imagePackerApi: image.ImagePacker = image.createImagePacker();
      await imagePackerApi.packToFile(showPixelMap, fileImg.fd as int, packOpts as image.PackingOption)
      this.outputShowUri = this.outputFullUri;

      let promptAction: PromptAction = this.getUIContext().getPromptAction();
      promptAction.showToast({
        message: '压缩完成',
        duration: 2000
      });
    })
  }

  /**
   * 图片压缩
   * @param sourcePixelMap：原始待压缩图片的PixelMap对象
   * @param maxCompressedImageSize：指定图片的压缩目标大小，单位kb
   */
  async compressedImage(sourcePixelMap: image.PixelMap, maxCompressedImageSize: number,
    buffer: ArrayBuffer): Promise<void> {
    // 判断是优先压缩质量还是优先压缩尺寸
    if (this.isQualityPriority) {
      this.qualityPriorityCompress(sourcePixelMap, maxCompressedImageSize);
    } else {
      this.scalePriorityCompress(sourcePixelMap, maxCompressedImageSize, this.minQuality);
    }
  }

  /**
   * 优先压缩图片质量
   * @param sourcePixelMap 原始待压缩图片的PixelMap
   * @param maxCompressedImageSize 指定图片的压缩目标大小
   */
  async qualityPriorityCompress(sourcePixelMap: image.PixelMap, maxCompressedImageSize: number) {
    let compressedImageData: ArrayBuffer =
      await this.packing(sourcePixelMap, 0, this.photoMime);
    // 先判断图片质量参数设置最低0能否满足目标大小。如果能满足目标大小，则直接使用packing二分图片质量。如果不满足，则质量参数固定为0，进行scale尺寸压缩
    if (compressedImageData.byteLength <= maxCompressedImageSize * BYTE_CONVERSION) {
      // 满足目标大小，直接使用packing二分
      this.packingImage(sourcePixelMap, compressedImageData, maxCompressedImageSize * BYTE_CONVERSION);
    } else {
      // 不满足目标大小，质量参数设置为0，再进行scale尺寸压缩
      this.scalePriorityCompress(sourcePixelMap, maxCompressedImageSize, IMAGE_QUALITY_ZERO);
    }
  }

  /**
   * 优先压缩图片尺寸
   * @param sourcePixelMap 原始待压缩图片的PixelMap
   * @param maxCompressedImageSize 指定图片的压缩目标大小
   * @param quality
   */
  async scalePriorityCompress(sourcePixelMap: image.PixelMap, maxCompressedImageSize: number, quality: number) {
    this.setPhotoProperty();
    let compressedImageData: ArrayBuffer =
      await this.packing(sourcePixelMap, (quality * 1) as int, this.photoMime);
    // 如果调整过最低图片质量，先计算最低图片质量是否满足要求。如果设定的最低图片质量已经满足目标大小，则直接返回
    if (quality !== IMAGE_QUALITY_HUNDRED &&
      (compressedImageData.byteLength <= maxCompressedImageSize * BYTE_CONVERSION)) {
      // 保存最终压缩的图片质量，用于保存到图库时使用
      this.autoModeQuality = quality;
      let imageSource = image.createImageSource(compressedImageData as ArrayBuffer);
      let opts: image.DecodingOptions = { editable: true };
      let showPixelMap: image.PixelMap = await imageSource.createPixelMapUsingAllocator(opts,
        image.AllocatorType.AUTO);
      let imageInfo: image.ImageInfo = showPixelMap.getImageInfoSync();
      this.afterCompressImgSize = String(imageInfo.size.width) + '*' + String(imageInfo.size.height);
      this.afterCompressionSize = ((compressedImageData.byteLength / BYTE_CONVERSION) as Number).toFixed(1);

      let packOpts: image.PackingOption =
        { format: 'image/' + this.photoMime, quality: (quality * 1) as int } as image.PackingOption;
      let fileImg = fs.openSync(this.outputFullUri, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
      const imagePackerApi: image.ImagePacker = image.createImagePacker();
      await imagePackerApi.packToFile(showPixelMap, fileImg.fd as int, packOpts as image.PackingOption)
      this.outputShowUri = this.outputFullUri;
    } else {
      // scale压缩图片尺寸。采用while循环每次递减reduceScaleVal，最终查找到最接近指定图片压缩目标大小的缩放倍数的图片压缩数据。
      let imageScale: number = 1; // 定义图片宽高的缩放倍数，1表示原比例。
      const REDUCE_SCALE: number = this.reduceScaleVal;
      const AFTER_COMPRESS_FMT = this.photoMime;
      // 判断压缩后的图片大小是否大于指定图片的压缩目标大小，如果大于，继续降低缩放倍数压缩。
      while (compressedImageData.byteLength > maxCompressedImageSize * BYTE_CONVERSION) {
        if (imageScale > 0) {
          // 性能知识点: 由于scale会直接修改图片PixelMap数据，所以不适用二分查找scale缩放倍数。这里采用循环递减reduceScaleVal倍缩放图片，
          // 来查找确定最适合的缩放倍数。如果对图片压缩质量要求不高，建议调高每次递减的缩放倍数，减少循环，提升scale压缩性能。
          imageScale = (imageScale - REDUCE_SCALE) as number; // 每次缩放倍数减
          // 使用scale对图片尺寸进行缩放
          await sourcePixelMap.scale((imageScale / 1.0) as float, (imageScale / 1.0) as float);
          // packing压缩
          compressedImageData = await this.packing(sourcePixelMap, (quality * 1) as int, AFTER_COMPRESS_FMT);
        } else {
          // imageScale缩放倍数小于等于0时，没有意义，结束压缩。
          break;
        }

        this.autoModeQuality = quality;
        let imageSource = image.createImageSource(compressedImageData);
        let opts: image.DecodingOptions = { editable: true };
        let showPixelMap = await imageSource.createPixelMapUsingAllocator(opts, image.AllocatorType.AUTO);
        let imageInfo: image.ImageInfo = showPixelMap.getImageInfoSync();
        this.afterCompressImgSize = String(imageInfo.size.width) + '*' + String(imageInfo.size.height);
        this.afterCompressionSize = ((compressedImageData.byteLength / BYTE_CONVERSION) as Number).toFixed(1);

        let packOpts: image.PackingOption =
          { format: 'image/' + this.photoMime, quality: (quality * 1) as int } as image.PackingOption;
        let fileImg = fs.openSync(this.outputFullUri, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        const imagePackerApi: image.ImagePacker = image.createImagePacker();
        await imagePackerApi.packToFile(showPixelMap, fileImg.fd as int, packOpts as image.PackingOption)
        this.outputShowUri = this.outputFullUri;
      }
    }
  }

  /**
   * packing二分方式循环压缩
   * @param sourcePixelMap 原始待压缩图片的PixelMap
   * @param compressedImageData 图片压缩的ArrayBuffer
   * @param maxCompressedImageByte 压缩目标图像字节长度
   */
  async packingImage(sourcePixelMap: image.PixelMap, compressedImageData: ArrayBuffer,
    maxCompressedImageByte: number) {
    let imageQuality: number = 0;
    const DICHOTOMY_ACCURACY = this.minBisectUnit;
    // 图片质量参数范围为0-100，这里以minBisectUnit为最小二分单位创建用于packing二分图片质量参数的数组。
    const packingArray: number[] = [];
    // 性能知识点: 如果对图片压缩质量要求不高，建议调高minBisectUnit（对应‘packing最小二分单位’），减少循环，提升packing压缩性能。
    for (let i = 0; i <= 100; i += DICHOTOMY_ACCURACY) {
      packingArray.push(i);
    }
    let left = 0; // 定义二分搜索范围的左边界
    let right = packingArray.length - 1; // 定义二分搜索范围的右边界
    const AFTER_COMPRESS_FMT = this.photoMime;
  // 二分压缩图片
    while (left <= right) {
      const mid = Math.floor((left + right) / 2).toInt(); // 定义二分搜索范围的中间位置
      imageQuality = packingArray[mid]; // 获取二分中间位置的图片质量值
      // 根据传入的图片质量参数进行packing压缩，返回压缩后的图片文件流数据。
      compressedImageData = await this.packing(sourcePixelMap, (imageQuality * 1) as int, AFTER_COMPRESS_FMT);
      // 判断查找一个尽可能接近但不超过压缩目标的压缩大小
      if (compressedImageData.byteLength <= maxCompressedImageByte) {
        // 二分目标值在右半边，继续在更高的图片质量参数（即mid + 1）中搜索
        left = ((mid + 1) * 1) as int;
        // 判断mid是否已经二分到最后，如果二分完了，退出
        if (mid === packingArray.length - 1) {
          break;
        }
        // 获取下一次二分的图片质量参数（mid+1）压缩的图片文件流数据
        compressedImageData =
          await this.packing(sourcePixelMap, (packingArray[mid + 1] * 1) as int, AFTER_COMPRESS_FMT);
        // 判断用下一次图片质量参数（mid+1）压缩的图片大小是否大于指定图片的压缩目标大小。如果大于，说明当前图片质量参数（mid）压缩出来的
        // 图片大小最接近指定图片的压缩目标大小。传入当前图片质量参数mid，得到最终目标图片压缩数据。
        if (compressedImageData.byteLength > maxCompressedImageByte) {
          compressedImageData =
            await this.packing(sourcePixelMap, (packingArray[mid] * 1) as int, AFTER_COMPRESS_FMT);
          break;
        }
      } else {
        // 目标值不在当前范围的右半部分，将搜索范围的右边界向左移动，以缩小搜索范围并继续在下一次迭代中查找左半部分。
        right = Double.toInt(mid - 1);
      }
    }
    // 保存最终压缩的图片质量，用于保存到图库时使用
    this.autoModeQuality = imageQuality;
    let imageSource = image.createImageSource(compressedImageData);
    let opts: image.DecodingOptions = { editable: true };
    let showPixelMap = await imageSource.createPixelMapUsingAllocator(opts, image.AllocatorType.AUTO);
    let imageInfo: image.ImageInfo = showPixelMap.getImageInfoSync();
    this.afterCompressImgSize = String(imageInfo.size.width) + '*' + String(imageInfo.size.height);
    this.afterCompressionSize = ((compressedImageData.byteLength / BYTE_CONVERSION) as Number).toFixed(1);

    let packOpts: image.PackingOption =
      { format: 'image/' + this.photoMime, quality: (imageQuality * 1) as int } as image.PackingOption;
    let fileImg = fs.openSync(this.outputFullUri, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    await imagePackerApi.packToFile(showPixelMap, fileImg.fd as int, packOpts as image.PackingOption);
    this.outputShowUri = this.outputFullUri;
  }

  /**
   * 设置图片格式、路径等
   * @returns void
   */
  setPhotoProperty(): void {
    this.afterCompressFmt = this.getPhotoShowFormat(this.afterFormat);
    this.outputFullUri = this.outputPureUri + '.' + this.getPhotoExtension(this.afterFormat);
    this.photoMime = this.getPhotoMime(this.afterFormat);
  }

  /**
   * 获取文件后缀
   * @param format 图片格式枚举值
   * @returns 文件后缀
   */
  getPhotoExtension(format: PhotoFormat): string {
    let result: string = '';
    switch (format) {
      case PhotoFormat.Jpeg:
        result = 'jpg';
        break;

      case PhotoFormat.Heif:
        result = 'heic';
        break;

      default:
        break;
    }
    return result;
  }


  /**
   * 获取文件显示的格式
   * @param format 图片格式枚举值
   * @returns 文件显示的格式
   */
  getPhotoShowFormat(format: PhotoFormat): string {
    let result: string = '';
    switch (format) {
      case PhotoFormat.Jpeg:
        result = 'jpg';
        break;

      case PhotoFormat.Heif:
        result = 'heif';
        break;

      default:
        break;
    }
    return result;
  }


  /**
   * 获取文件mime
   * @param format 图片格式枚举值
   * @returns 文件mime
   */
  getPhotoMime(format: PhotoFormat): string {
    let result: string = '';
    switch (format) {
      case PhotoFormat.Jpeg:
        result = 'jpeg';
        break;

      case PhotoFormat.Heif:
        result = 'heif';
        break;

      default:
        break;
    }
    return result;
  }

  /**
   * packing压缩
   * @param sourcePixelMap 原始待压缩图片的PixelMap
   * @param imageQuality 图片质量参数
   * @param packingFormat 目标格式。当前只支持'image/jpeg' 和 'image/heif'
   * @returns data 返回压缩后的图片数据
   */
  async packing(sourcePixelMap: image.PixelMap, imageQuality: int, packingFormat: string):
    Promise<ArrayBuffer> {
    let pictureObj: image.Picture = image.createPicture(sourcePixelMap);
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    let packOpts: image.PackingOption = {
      format: 'image/' + packingFormat,
      quality: imageQuality,
    } as image.PackingOption;
    const data: ArrayBuffer =
      await imagePackerApi.packing(pictureObj as image.Picture, packOpts as image.PackingOption);
    return data;
  }

  /**
   * 显示压缩前和压缩后图片
   */
  @
  Builder
  displayImage() {
    Row() {
      Text('压缩前：')
        .fontWeight(FONT_WEIGHT)
        .fontSize(16)
      Text('97')
        .fontWeight(FONT_WEIGHT)
        .fontSize(20)
        .fontColor('#ff0e9eff')
      Text(' kb  格式：')
        .fontSize(16)
      Text(this.beforeCompressFmt).fontSize(16)
    }
    .width('100%')
    .padding(5)

    Column() {
      Image($rawfile('source.jpg'))
        .objectFit(ImageFit.Contain)
      Text('1000*750')
        .fontSize(13)
        .opacity(0.8)
        .margin(5)
    }
    .width('70%')
    .height(150)
    .backgroundColor(Color.White)
    .margin({ bottom: 10 } as Margin)
    .borderRadius(5)

    Row() {
      Text('压缩后：')
        .fontWeight(FONT_WEIGHT)
        .fontSize(16)
      Text(this.afterCompressionSize)
        .fontWeight(FONT_WEIGHT)
        .fontSize(20)
        .fontColor('#ff0e9eff')
      Text(' kb  格式：')
        .fontSize(16)
      Text(this.afterCompressFmt)
        .fontSize(16)
      Blank()
    }
    .width('100%')
    .padding(5)
    .margin({ top: 5, bottom: 5 } as Margin)

    Column() {
      if (this.outputShowUri !== '') {
        Image(fileUri.getUriFromPath(this.outputShowUri))
          .objectFit(ImageFit.Contain)
        Text(this.afterCompressImgSize)
          .fontSize(13)
          .opacity(0.8)
          .margin(10)
      }
    }
    .width('70%')
    .height(150)
    .backgroundColor(Color.White)
    .padding(5)
    .margin({ bottom: 20 } as Margin)
    .borderRadius(5)
  }

  /**
   * 压缩模式
   */
  @Builder
  compressMode() {
    Row() {
      Text('压缩模式：')
        .fontWeight(FONT_WEIGHT)
        .fontSize(16)
      Radio({ value: 'autoMode', group: 'compressMode' })
        .width(20)
        .height(20)
        .checked(true)
        .id('autoMode')
        .onChange((isChecked: boolean): void => {
          if (isChecked) {
            this.isAutoMode = true;
          }
        })
      Text('自动模式')
        .fontSize(14)
      Radio({ value: 'manualMode', group: 'compressMode' })
        .width(20)
        .height(20)
        .checked(false)
        .id('manualMode')
        .onChange((isChecked: boolean): void => {
          if (isChecked) {
            this.isAutoMode = false;
          }
        })
      Text('手动模式')
        .fontSize(14)
      Blank()
    }
    .width('90%')
    .height(48)
    .padding(10)
    .margin(10)
    .borderRadius(10)
    .backgroundColor(Color.White)
  }

  /**
   * 压缩相关设置
   */
  @Builder
  compressSettingItems() {
    Scroll() {
      Column() {
        Column() {
          Row() {
            Text('图片压缩目标大小：')
              .fontWeight(FONT_WEIGHT)
              .fontSize(15)
            TextInput({
              text: this.strMaxCompressedImageSize
            })
              .id('textInput')
              .width(100)
              .height(36)
              .fontSize(15)
              .enabled(this.isAutoMode)
              .type(InputType.NUMBER_DECIMAL)
              .onChange((value: string): void => {
                this.strMaxCompressedImageSize = value;
                this.maxCompressedImageSize = Number(value);
              })
            Text('KB')
              .fontSize(15)
              .opacity(0.8)
            Blank()
          }
          .width('100%')
          .height(48)

          Row() {
            Text('scale每次缩小倍数：')
              .fontWeight(FONT_WEIGHT)
              .fontSize(15)
            Slider({
              value: this.reduceScaleVal,
              min: SLIDER_ZERO_POINT_ZERO_ONE,
              max: SLIDER_ZERO_POINT_FIVE,
              style: SliderStyle.OutSet,
              step: SLIDER_ZERO_POINT_ZERO_ONE
            })
              .id('scaleSlider')
              .enabled(this.isAutoMode)
              .width(100)
              .onChange((value: number): void => {
                this.reduceScaleVal = Number(Math.round(value * 100) / 100);
              })
            Text(String(this.reduceScaleVal))
              .fontSize(15)
              .opacity(0.8)
            Blank()
          }
          .width('100%')
          .height(48)

          Row() {
            Text('压缩偏好：')
              .fontWeight(FONT_WEIGHT)
              .fontSize(15)
            Radio({ value: 'qualityPriority', group: 'compressPriority' })
              .width(20)
              .height(20)
              .enabled(this.isAutoMode)
              .checked(true)
              .id('qualityPriority')
              .onChange((isChecked: boolean): void => {
                if (isChecked) {
                  this.isQualityPriority = true;
                }
              })
            Text('优先压缩质量')
              .fontSize(13)
            Radio({ value: 'scalePriority', group: 'compressPriority' })
              .width(20)
              .height(20)
              .enabled(this.isAutoMode)
              .checked(false)
              .id('scalePriority')
              .onChange((isChecked: boolean): void => {
                if (isChecked) {
                  this.isQualityPriority = false;
                }
              })
            Text('优先压缩尺寸')
              .fontSize(13)
            Blank()
          }
          .width('100%')
          .height(48)

          Row() {
            Text('packing最小二分单位：')
              .fontWeight(FONT_WEIGHT)
              .fontSize(15)
            Slider({
              value: this.minBisectUnit,
              min: SLIDER_ONE,
              max: SLIDER_THIRTY,
              style: SliderStyle.OutSet
            })
              .id('packingSlider')
              .width(100)
              .enabled(this.isAutoMode && this.isQualityPriority)
              .onChange((value: number): void => {
                this.minBisectUnit = value;
              })
            Text(String(this.minBisectUnit))
              .fontSize(15)
              .opacity(0.8)
            Blank()
          }
          .height(48)
          .width('100%')
          .opacity(this.isQualityPriority ? 1 : 0.5)

          Row() {
            Text('最低图片质量：')
              .fontWeight(FONT_WEIGHT)
              .fontSize(15)
            Slider({
              value: this.minQuality,
              min: SLIDER_ZERO,
              max: SLIDER_ONE_HUNDRED,
              style: SliderStyle.OutSet
            })
              .id('minQualitySlider')
              .width(100)
              .enabled(this.isAutoMode && !this.isQualityPriority)
              .onChange((value: number): void => {
                this.minQuality = value;
              })
            Text(String(this.minQuality))
              .fontSize(15)
              .opacity(0.8)
            Blank()
          }
          .width('100%')
          .height(48)
          .opacity(!this.isQualityPriority ? 1 : 0.5)
        }
        .width('100%')
        .height(256)
        .borderRadius(10)
        .backgroundColor(Color.White)
        .opacity(this.isAutoMode ? 1 : 0.5)
        .padding(10)

        Row() {
        }.width('100%').height(10)

        Column() {
          Row() {
            Text('图片质量：')
              .width(80)
              .fontWeight(FONT_WEIGHT)
              .fontSize(15)
            Slider({
              value: this.imageQualityVal,
              min: SLIDER_ZERO,
              max: SLIDER_ONE_HUNDRED,
              style: SliderStyle.OutSet
            })
              .enabled(!this.isAutoMode)
              .width(150)
              .id('imageQuality')
              .onChange((value: number): void => {
                this.imageQualityVal = value;
              })
            Text(String(this.imageQualityVal))
              .fontSize(15)
              .opacity(0.8)
            Blank()
          }
          .width('100%')

          Row() {
            Text('图片尺寸：')
              .width(80)
              .fontWeight(FONT_WEIGHT)
              .fontSize(15)
            Slider({
              value: this.imageScaleVal,
              min: SLIDER_ONE,
              max: SLIDER_ONE_HUNDRED,
              style: SliderStyle.OutSet
            })
              .enabled(!this.isAutoMode)
              .width(150)
              .id('imageScale')
              .onChange((value: number): void => {
                this.imageScaleVal = value;
              })
            Text(String(this.imageScaleVal))
              .fontSize(15)
              .opacity(0.8)
            Text(' %')
              .fontSize(15)
              .opacity(0.8)
            Blank()
          }
          .width('100%')
        }
        .opacity(!this.isAutoMode ? 1 : 0.5)
        .width('100%')
        .height(96)
        .borderRadius(10)
        .backgroundColor(Color.White)
        .padding(10)
      }
    }
    .id('setScroll')
    .scrollBar(BarState.Off)
    .height(160)
    .width('90%')
  }

  /**
   * 输出格式
   */
  @Builder
  outputFormatSet() {
    Row() {
      Text('输出格式：')
        .fontWeight(FONT_WEIGHT)
        .fontSize(16)
      Radio({ value: 'sourceFormat', group: 'formatMode' })
        .width(20)
        .height(20)
        .checked(true)
        .id('sourceFormat')
        .onChange((isChecked: boolean): void => {
          if (isChecked) {
            this.afterFormat = this.beforeFormat;
          }
        })

      Text('原格式')
        .fontSize(14)

      Radio({ value: 'jpegFormat', group: 'formatMode' })
        .width(20)
        .height(20)
        .checked(false)
        .id('jpegFormat')
        .onChange((isChecked: boolean): void => {
          if (isChecked) {
            this.afterFormat = PhotoFormat.Jpeg;
          }
        })
      Text('JPG')
        .fontSize(14)

      Radio({ value: 'heifFormat', group: 'formatMode' })
        .width(20)
        .height(20)
        .checked(false)
        .id('heifFormat')
        .onChange((isChecked: boolean): void => {
          if (isChecked) {
            this.afterFormat = PhotoFormat.Heif;
          }
        })
      Text('HEIF')
        .fontSize(14)
    }
    .width('90%')
    .height(48)
    .padding(10)
    .margin(10)
    .borderRadius(10)
    .backgroundColor(Color.White)
  }

  /**
   * 压缩和保存到相册
   */
  @Builder
  compressAndSave() {
    Row() {
      Button('压缩')
        .fontSize(18)
        .borderRadius(12)
        .height(40)
        .onClick((e: ClickEvent) => {
          if (this.isAutoMode) {
            this.autoCompression();
          } else {
            this.manualCompression();
          }
        })
      Blank()

      Button('清除')
        .fontSize(18)
        .borderRadius(12)
        .height(40)
        .onClick((e: ClickEvent) => {
          this.outputShowUri = '';
          this.afterCompressionSize = '0';
          this.afterCompressImgSize = '';
          this.afterCompressFmt = '';
          (fs.access(this.outputPath) as Promise<boolean>).then((res: boolean) => {
            if (res) {
              await fs.rmdir(this.outputPath);
            }
          })
        })
    }.width('60%')
    .padding(5)
  }

  build() {
    Column() {
      Scroll(this.scrollerForLiftUp) {
        Column() {
          // 显示压缩前和压缩后图片
          this.displayImage()
        }
      }
      .scrollBar(BarState.Off)
      .layoutWeight(LAYOUT_WEIGHT)

      // 压缩模式
      this.compressMode()
      // 压缩相关设置
      this.compressSettingItems()
      // 输出格式
      this.outputFormatSet()
      // 压缩
      this.compressAndSave()
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .backgroundColor('#99e3e3e3')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
