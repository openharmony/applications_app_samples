/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { image } from '@kit.ImageKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { resourceManager } from '@kit.LocalizationKit';
import { common } from '@kit.AbilityKit';

let copyData: ArrayBuffer = new ArrayBuffer(0);
// [Start create_picturePackOpts]
let packOpts: image.PackingOption = {
  format: 'image/jpeg',
  quality: 95,
  desiredDynamicRange: image.PackingDynamicRange.AUTO,
  needsPackProperties: true
};
// [End create_picturePackOpts]

// [Start get_filePath]
function getFilePath(context: Context, fileName: string): string {
  const filePath: string = context.cacheDir + '/' + fileName;
  return filePath;
}
// [End get_filePath]

// [Start get_fileFd]
function getFileFd(context: Context, fileName: string): number | undefined {
  const filePath: string = context.cacheDir + '/' + fileName;
  const file: fs.File = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
  const fd: number = file?.fd;
  return fd;
}
// [End get_fileFd]

// [Start get_fileBuffer]
async function getFileBuffer(context: Context, fileName: string): Promise<ArrayBuffer | undefined> {
  try {
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    // 获取资源文件内容，返回Uint8Array。
    const fileData: Uint8Array = await resourceMgr.getRawFileContent(fileName);
    console.info('Successfully get the RawFileContent.');
    // 转为ArrayBuffer并返回。
    const buffer: ArrayBuffer = fileData.buffer.slice(0);
    return buffer;
  } catch (error) {
    console.error(`Failed to get the RawFileContent with error: ${error}.`);
    return undefined;
  }
}
// [End get_fileBuffer]

// [Start get_RawFd]
async function getRawFd(context: Context, fileName: string): Promise<resourceManager.RawFileDescriptor | undefined> {
  try {
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    const rawFileDescriptor: resourceManager.RawFileDescriptor = await resourceMgr.getRawFd(fileName);
    console.info('Successfully get the RawFileDescriptor.');
    return rawFileDescriptor;
  } catch (error) {
    console.error(`Failed to get the RawFileDescriptor with error: ${error}.`);
    return undefined;
  }
}
// [End get_RawFd]

// [Start packToData_pixelMap]
async function packToDataFromPixelMap(pixelMap : image.PixelMap) {
  // [Start create_packer]
  const imagePackerApi = image.createImagePacker();
  // [End create_packer]
  // [Start create_packOpts]
  let packOpts : image.PackingOption = { format: 'image/jpeg', quality: 95 };
  // [End create_packOpts]
  // [Start packOpts_isHdr]
  // 资源本身为hdr且设备支持HDR编码则会编码为hdr内容(需要资源本身为hdr且设备支持HDR编码，支持jpeg格式)。
  packOpts.desiredDynamicRange = image.PackingDynamicRange.AUTO;
  // [End packOpts_isHdr]
  try{
    let data = await imagePackerApi.packToData(pixelMap, packOpts);
    // data 为编码获取到的文件流，写入文件保存即可得到一张图片。
    // [StartExclude copyData_toShow]
    copyData = new ArrayBuffer(0);
    copyData = data;
    // [EndExclude copyData_toShow]
  } catch (error) {
    console.error('Failed to pack the pixelMap to data. And the error is: ' + error);
  }
}
// [End packToData_pixelMap]

// [Start packToData_imageSource]
async function packToDataFromImageSource(imageSource : image.ImageSource) {
  const imagePackerApi = image.createImagePacker();
  let packOpts : image.PackingOption = { format: 'image/jpeg', quality: 95 };
  try {
    let data = await imagePackerApi.packToData(imageSource, packOpts);
    // data 为编码获取到的文件流，写入文件保存即可得到一张图片。
    // [StartExclude copyData_toShow]
    copyData = new ArrayBuffer(0);
    copyData = data;
    // [EndExclude copyData_toShow]
  } catch (error) {
    console.error('Failed to pack the imageSource to data. And the error is: ' + error);
  }
}
// [End packToData_imageSource]

// [Start packToFile_pixelMap]
async function packToFileFromPixelMap(context : Context, pixelMap : image.PixelMap) {
  const imagePackerApi = image.createImagePacker();
  let packOpts : image.PackingOption = { format: 'image/jpeg', quality: 95 };
  const path : string = context.cacheDir + '/pixel_map.jpg';
  let file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  try {
    await imagePackerApi.packToFile(pixelMap, file.fd, packOpts);
  } catch (error) {
    console.error('Failed to pack the pixelMap to file. And the error is: ' + error);
  }
}
// [End packToFile_pixelMap]

// [Start packToFile_imageSource]
async function packToFileFromImageSource(context : Context, imageSource : image.ImageSource) {
  const imagePackerApi = image.createImagePacker();
  let packOpts : image.PackingOption = { format: 'image/jpeg', quality: 95 };
  const filePath : string = context.cacheDir + '/image_source.jpg';
  let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  try {
    await imagePackerApi.packToFile(imageSource, file.fd, packOpts);
  } catch (error) {
    console.error('Failed to pack the imageSource to file. And the error is: ' + error);
  }
}
// [End packToFile_imageSource]

// [Start packToData_picture]
async function packing(picture: image.Picture, packOpts: image.PackingOption) {
  // [Start create_picturePacker]
  const imagePackerApi = image.createImagePacker();
  // [End create_picturePacker]
  try {
    let data = await imagePackerApi.packing(picture, packOpts);
    // [StartExclude copyData_toShow]
    copyData = data;
    // [EndExclude copyData_toShow]
    console.info('Succeeded in packing the image.');
  } catch (error) {
    console.error('Failed to pack the picture to data. And the error is: ' + error);
  }
}
// [End packToData_picture]

// [Start packToFile_picture]
async function packToFile(picture: image.Picture, packOpts: image.PackingOption, context: Context) {
  const path : string = context.cacheDir + '/picture.jpg';
  let file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  const imagePackerApi = image.createImagePacker();
  try {
    await imagePackerApi.packToFile(picture, file.fd, packOpts);
  } catch (error) {
    console.error('Failed to pack the picture to file. And the error is: ' + error);
  }
}
// [End packToFile_picture]

export class ImageInterfaceCalled {
  createImageSourceByFilePath(context: common.UIAbilityContext, fileName: string): image.ImageSource | undefined {
    if(context){
      let filePath = getFilePath(context, fileName);
      // [Start createImageSource_filePath]
      // path为已获得的沙箱路径。
      const imageSource : image.ImageSource = image.createImageSource(filePath);
      // [End createImageSource_filePath]
      return imageSource;
    } else {
      return undefined;
    }
  }

  createImageSourceByFd(context: common.UIAbilityContext, fileName: string): image.ImageSource | undefined {
    if (context) {
      const fd = getFileFd(context, fileName);
      // [Start createImageSource_fd]
      // fd为已获得的文件描述符。
      const imageSource: image.ImageSource = image.createImageSource(fd);
      // [End createImageSource_fd]
      return imageSource;
    } else {
      return undefined;
    }
  }

  async createImageSourceByBuffer(context: common.UIAbilityContext, fileName: string)
    : Promise<image.ImageSource | undefined> {
    if (context) {
      let buffer = await getFileBuffer(context, fileName);
      // [Start createImageSource_buffer]
      const imageSource: image.ImageSource = image.createImageSource(buffer);
      // [End createImageSource_buffer]
      return imageSource;
    } else {
      return undefined;
    }
  }

  async createImageSourceByRawFd(context: common.UIAbilityContext, fileName: string)
    : Promise<image.ImageSource | undefined> {
    if (context) {
      let rawFileDescriptor = await getRawFd(context, fileName);
      // [Start createImageSource_rawFd]
      const imageSource: image.ImageSource = image.createImageSource(rawFileDescriptor);
      // [End createImageSource_rawFd]
      return imageSource;
    } else {
      return undefined;
    }
  }

  // [Start create_pixelMap]
  async createPixelMap(imageSource: image.ImageSource | undefined): Promise<image.PixelMap | undefined> {
    if (!imageSource) {
      console.error('imageSource is undefined.');
      return undefined;
    }
    // 配置解码选项参数。
    let decodingOptions: image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
      //设置为AUTO会根据图片资源格式和设备支持情况进行解码，如果图片资源为HDR资源且设备支持HDR解码则会解码为HDR的pixelMap。
      desiredDynamicRange: image.DecodingDynamicRange.HDR,
    };

    try {
      // 生成 pixelMap 并返回
      const pixelMap = await imageSource.createPixelMap(decodingOptions);
      if (pixelMap) {
        console.info('Create PixelMap successfully.');
        // 判断pixelMap是否为hdr内容。
        let imageInfo = await pixelMap.getImageInfo();
        console.info(`Create PixelMap successfully with imageInfo.isHdr: ${imageInfo.isHdr}.`);
        return pixelMap;
      } else {
        console.info('Create PixelMap failed.');
        return undefined;
      }
    } catch (error) {
      console.error(`Failed to create PixelMap: ${error}.`);
      return undefined;
    }
  }
  // [End create_pixelMap]

  // [Start create_picture]
  async createPicture(imageSource : image.ImageSource | undefined, isReturnAux: Boolean)
    : Promise<image.PixelMap | undefined | image.Picture> {
    // 配置解码选项参数。
    let options: image.DecodingOptionsForPicture = {
      desiredAuxiliaryPictures: [image.AuxiliaryPictureType.GAINMAP] // GAINMAP为需要解码的辅助图类型。
    };
    let returnPixelMap: image.PixelMap | undefined = undefined;
    // 创建picture。
    try {
      let picture = await imageSource?.createPicture(options);
      if (picture) {
        // 返回解码后获取到的辅助图
        if (isReturnAux) {
          // type为解码参数中包含的辅助图类型
          let type: image.AuxiliaryPictureType = image.AuxiliaryPictureType.GAINMAP;
          let auxPicture: image.AuxiliaryPicture | null = picture.getAuxiliaryPicture(type);
          // 获取辅助图信息。
          if (auxPicture != null) {
            let auxInfo: image.AuxiliaryPictureInfo = auxPicture.getAuxiliaryPictureInfo();
            console.info('GetAuxiliaryPictureInfo type: ' + auxInfo.auxiliaryPictureType +
              ' height: ' + auxInfo.size.height + ' width: ' + auxInfo.size.width +
              ' rowStride: ' + auxInfo.rowStride + ' pixelFormat: ' + auxInfo.pixelFormat +
              ' colorSpace: ' + auxInfo.colorSpace);
            // 将辅助图数据读到ArrayBuffer。
            try {
              let pixelsBuffer = await auxPicture.readPixelsToBuffer();
              let opts: image.InitializationOptions = { size: auxInfo.size };
              try {
                returnPixelMap = image.createPixelMapSync(pixelsBuffer, opts) as image.PixelMap;
                console.info(`Create PixelMap with buffer successfully.`);
              } catch (error) {
                console.error(`Create PixelMap failed with ${error}.`);
              }
            } catch (error) {
              console.error(`Read pixels to buffer failed, error.code: ${error.code},
                error.message: ${error.message}`);
            }
            auxPicture.release();
          }
          return returnPixelMap;
        } else {
          return picture; // 返回解码后获取到的picture
        }
      }
      return returnPixelMap;
    } catch (error) {
      console.error(`Create picture failed: ${error}.`);
    }
    return returnPixelMap;
  }
  // [End create_picture]

  // [Start allocator_called]
  async CreatePixelMapUsingAllocator(context: Context, type: image.AllocatorType): Promise<image.PixelMap> {
    const resourceMgr = context.resourceManager;
    const rawFile = await resourceMgr.getRawFileContent('99_132.jpg'); // 测试图片为99*132的jpg图。
    let imageSource: image.ImageSource = image.createImageSource(rawFile.buffer as ArrayBuffer);
    let options: image.DecodingOptions = {};
    let pixelmap = await imageSource.createPixelMapUsingAllocator(options, type);
    if (pixelmap != undefined) {
      let info = await pixelmap.getImageInfo();
      // 用DMA_ALLOC内存申请出的pixelmap的stride与SHARE_MEMORY内存申请出的pixelmap的stride不同。
      console.info('stride = ' + info.stride);
    }
    return pixelmap;
  }
  // [End allocator_called]

  // [Start release_pictureDecoder]
  async release(picture: image.Picture) {
    picture?.release();
  }
  // [End release_pictureDecoder]

  async showPixelMapFromData(imageInfo: image.ImageInfo, pixelMap?: image.PixelMap,
    imageSource?: image.ImageSource, picture?: image.Picture): Promise<image.PixelMap | undefined> {
    if (pixelMap) {
      await packToDataFromPixelMap(pixelMap);
    } else if (imageSource) {
      await packToDataFromImageSource(imageSource);
    } else if (picture) {
      packing(picture, packOpts);
    }
    let packedSource: image.ImageSource | undefined = undefined;
    // 将编码获取到的文件流data进行解码，用于显示编码后解码的pixelMap
    if (copyData && imageInfo) {
      let ops: image.SourceOptions = {
        sourceDensity: 95,
      }
      packedSource = image.createImageSource(copyData, ops);
      let decodingOpts: image.InitializationOptions = {
        editable: true,
        pixelFormat: image.PixelMapFormat.RGBA_8888,
        size: { height: imageInfo.size.height, width: imageInfo.size.width }
      }
      return await packedSource.createPixelMap(decodingOpts);
    }
    return undefined;
  }

  async showPixelMapFromFile(context: Context, pixelMap?: image.PixelMap, imageSource?: image.ImageSource,
    picture?: image.Picture) {
    let filePath: string = '';
    if (pixelMap) {
      await packToFileFromPixelMap(context, pixelMap);
      filePath = context.cacheDir + '/pixel_map.jpg';
    } else if (imageSource) {
      await packToFileFromImageSource(context, imageSource);
      filePath = context.cacheDir + '/image_source.jpg';
    } else if (picture) {
      packToFile(picture, packOpts, context)
      filePath = context.cacheDir + '/picture.jpg';
    }
    let packedImageSource: image.ImageSource | undefined = undefined;
    // 将编码获取到的文件file进行解码，用于显示编码后解码的pixelMap
    if (filePath) {
      packedImageSource = image.createImageSource(filePath);
      return await packedImageSource.createPixelMap();
    }
    return undefined;
  }
}