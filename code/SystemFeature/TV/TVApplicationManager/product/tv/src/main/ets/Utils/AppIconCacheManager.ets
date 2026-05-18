import { DiskCache } from './DiskCache';
import { MemoryCache } from './MemoryCache';
import { image } from '@kit.ImageKit';
import { buffer, util } from '@kit.ArkTS';
import { application } from '@kit.AbilityKit';

const TAG = 'AppIconCacheManager'

// 图标缓存管理器
export class AppIconCacheManager {
  private static instance: AppIconCacheManager;
  private memoryCache = new MemoryCache()
  private diskCache = new DiskCache()

  static getInstance(): AppIconCacheManager {
    if (!AppIconCacheManager.instance) {
      AppIconCacheManager.instance = new AppIconCacheManager();
    }
    return AppIconCacheManager.instance;
  }

  // 获取应用图标
  async getAppIcon(
    bundleName: string,
    moduleName: string,
    abilityName: string,
    iconId: number
  ): Promise<PixelMap | null> {
    const cacheKey = this.generateCacheKey(bundleName, abilityName, iconId);

    // 1. 检查内存缓存
    const cachedIcon = this.getFromMemoryCache(cacheKey);
    if (cachedIcon) {
      console.log('熊0内存getAppIcon from disk cache',bundleName,(new Date().getTime())-(AppStorage.get('time') as number));

      return cachedIcon;
    }

    // 2. 检查磁盘缓存
    const diskIcon = await this.getFromDiskCache(cacheKey);
    if (diskIcon) {
      this.saveToMemoryCache(cacheKey, diskIcon);
      return diskIcon;
    }

    // 3. 从系统加载图标
    const originalIcon = await this.loadSystemIcon(bundleName, moduleName, iconId);
    console.log('熊3系统getAppIcon from disk cache',bundleName,(new Date().getTime())-(AppStorage.get('time') as number));

    if (originalIcon) {
      this.saveToMemoryCache(cacheKey, originalIcon);
      await this.saveToDiskCache(cacheKey, originalIcon);
      return originalIcon;
    }

    // 4. 都不成功
    return null;
  }

  // 从系统加载图标
  private async loadSystemIcon(
    bundleName: string,
    moduleName: string,
    iconId: number
  ): Promise<PixelMap> {
    return new Promise((resolve, reject) => {
      try {
        application.createModuleContext(globalThis.context, bundleName, moduleName).then(async (context) => {
          const icon = context.resourceManager.getDrawableDescriptor(iconId) as DrawableDescriptor
          const pixelMap: image.PixelMap = icon.getPixelMap();
          if (pixelMap) {
            resolve(pixelMap);
          } else {
            reject(new Error());
          }
          resolve(pixelMap)
        }).catch((e: Error) => {
          console.log(TAG, 'createModuleContext error:' + JSON.stringify(e))
          reject(new Error('createModuleContext error'));
        })
      } catch (error) {
        console.error(TAG, 'loadSystemIcon error:' + JSON.stringify(error))
        reject(error);
      }
    });
  }

  // 内存缓存管理
  private getFromMemoryCache(key: string): PixelMap | undefined {
    return this.memoryCache.get(key);
  }

  private saveToMemoryCache(key: string, icon: PixelMap) {

    this.memoryCache.set(key, icon)
  }

  // 磁盘缓存管理
  private async getFromDiskCache(key: string): Promise<PixelMap | null> {
    const diskIcon = await this.diskCache.get(key)
    if (diskIcon) {
      const pixelMap = await this.base64ToPixelMap(diskIcon);
      if (pixelMap) {
        return pixelMap
      }
    }
    return null
  }


  private async saveToDiskCache(key: string, icon: image.PixelMap) {
    try {
      const base64Icon = await this.pixelMapToBase64(icon);
      await this.diskCache.set(key, base64Icon);
      console.log('熊 saveToDiskCache 成功:', key, 'Base64 长度:', base64Icon.length, '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));
    } catch (error) {
      console.error(TAG, 'saveToDiskCache error ', JSON.stringify(error));
    }
  }


  private async pixelMapToBase64(pixelMap: PixelMap): Promise<string> {
    try {
      const width = pixelMap.getImageInfoSync().size.width;
      const height = pixelMap.getImageInfoSync().size.height;
      console.log('熊 pixelMapToBase64 原始尺寸:', width, 'x', height, '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));

      let sourcePixelMap = pixelMap;

      if (width > 288 || height > 288) {
        const scale = Math.min(288 / width, 288 / height);
        const scaledWidth = Math.floor(width * scale);
        const scaledHeight = Math.floor(height * scale);
        console.log('熊 pixelMapToBase64 缩放比例:', scale, '目标尺寸:', scaledWidth, 'x', scaledHeight, '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));

        try {
          const packOpts: image.PackingOption = {
            format: 'image/png',
            quality: 100,
          };

          const imagePacker: image.ImagePacker = image.createImagePacker();
          const packedData = await imagePacker.packing(pixelMap, packOpts);
          console.log('熊 pixelMapToBase64 PNG 中间转换完成，数据大小:', packedData.byteLength, '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));

          const tempImageSource = image.createImageSource(packedData);
          const decodeOpts: image.DecodingOptions = {
            desiredSize: {
              width: scaledWidth,
              height: scaledHeight
            }
          };
          sourcePixelMap = await tempImageSource.createPixelMap(decodeOpts);
          console.log('熊 pixelMapToBase64 缩放后尺寸:', sourcePixelMap.getImageInfoSync().size.width, 'x', sourcePixelMap.getImageInfoSync().size.height, '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));
        } catch (scaleError) {
          console.error('熊 pixelMapToBase64 缩放失败，使用原图:', JSON.stringify(scaleError), '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));
          sourcePixelMap = pixelMap;
        }
      }

      const imagePacker: image.ImagePacker = image.createImagePacker();

      const estimatedSize = sourcePixelMap.getPixelBytesNumber();
      console.log('熊 pixelMapToBase64 预估大小:', estimatedSize, 'bytes', '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));

      let compressQuality = 100;
      
      console.log('熊 pixelMapToBase64 压缩质量设置:', compressQuality, '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));

      const packOpts: image.PackingOption = {
        format: 'image/webp',
        quality: compressQuality,
      };

      let data: ArrayBuffer;
      try {
        data = await imagePacker.packing(sourcePixelMap, packOpts);
        console.log('熊 pixelMapToBase64 WebP 压缩成功，耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));
      } catch (webpError) {
        console.log('熊 pixelMapToBase64 WebP 失败，切换到 PNG:', JSON.stringify(webpError), '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));
        packOpts.format = 'image/png';
        data = await imagePacker.packing(sourcePixelMap, packOpts);
      }

      const buf: buffer.Buffer = buffer.from(data);
      const base64 = `data:image/${packOpts.format === 'image/webp' ? 'webp' : 'png'};base64,${buf.toString('base64', 0,
        buf.length)}`;
      console.log('熊 pixelMapToBase64 最终 Base64 长度:', base64.length, '格式:', packOpts.format, '耗时:', (new Date().getTime()) - (AppStorage.get('time') as number));

      return base64;
    } catch (error) {
      console.error(`pixelMapToBase64 err`, JSON.stringify(error));
      return '';
    }
  }
  private async base64ToPixelMap(base64Str: string): Promise<PixelMap | null> {
    try {
      const commaIndex = base64Str.indexOf(',');
      const pureBase64 = commaIndex === -1 ? base64Str : base64Str.substring(commaIndex + 1);

      // Base64 解码为 ArrayBuffer
      const base64Helper = new util.Base64Helper();
      const uint8Array: Uint8Array = base64Helper.decodeSync(pureBase64);
      const arrayBuffer: ArrayBuffer = uint8Array.buffer as ArrayBuffer;
      console.log('熊base64ToPixelMap',arrayBuffer.byteLength,(new Date().getTime())-(AppStorage.get('time') as number))

      // 创建 PixelMap
      const imageSource: image.ImageSource = image.createImageSource(arrayBuffer);
      const pixelMap: image.PixelMap = await imageSource.createPixelMap();
      return pixelMap;
    } catch (err) {
      console.log(TAG, 'base64ToPixelMap err', JSON.stringify(err))
      return null;
    }
  }

  // 生成缓存键
  private generateCacheKey(bundleName: string, abilityName: string, iconId: number): string {
    return `${bundleName}#${abilityName}#${iconId}`;
  }
}
