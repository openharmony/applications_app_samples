/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start PickerMediaLibrary_full]
import { common } from '@kit.AbilityKit';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import MediaLibraryPickerUtils, { PhotoItem } from '../common/utils/MediaLibraryPickerUtils';

@Entry
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext;
  @State selectedUris: Array<string> = [];
  @State processedItems: Array<PhotoItem> = [];
  @State showProcessedItems: boolean = false;
  // 新增状态变量
  @State selectedUriForRead: string = '';
  @State fileReadStatus: string = '';
  @State fileReadLength: number = 0;
  @State mediaResourceStatus: string = '';
  @State mediaResourceDataLength: number = 0;

  /**
   * 调用PhotoViewPicker.select接口拉起图库界面
   */
  private async pickPhotos(): Promise<void> {
    try {
      // 创建图库选择器实例
      // [Start PickerMediaLibrary_createPicker]
      const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
      // [End PickerMediaLibrary_createPicker]
      
      // 创建图片-视频类型文件选择选项实例
      // [Start PickerMediaLibrary_createOptions]
      const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      // [End PickerMediaLibrary_createOptions]
      
      // 配置可选的媒体文件类型和媒体文件的最大数目
      // [Start PickerMediaLibrary_configOptions]
      photoSelectOptions.maxSelectNumber = 5;
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
      photoSelectOptions.isPhotoTakingSupported = true;
      // [End PickerMediaLibrary_configOptions]
      
      console.log('调用PhotoViewPicker.select接口，拉起图库界面');
      
      // 调用PhotoViewPicker.select接口拉起图库界面进行文件选择
      // [Start PickerMediaLibrary_select]
      const result = await photoViewPicker.select(photoSelectOptions);
            
      // 文件选择成功后，返回PhotoSelectResult结果集
      console.log('选择成功，返回结果: ' + JSON.stringify(result));
      console.log('选择的文件数量: ' + result.photoUris.length);
      
      // 更新选中的URI列表
      this.selectedUris = result.photoUris;
      // 设置默认选中第一个URI用于读取操作
      if (this.selectedUris.length > 0) {
        this.selectedUriForRead = this.selectedUris[0];
      }
      
      // 调用工具类处理结果
      this.processedItems = MediaLibraryPickerUtils.handleSelectResult(this.selectedUris);
      console.log('处理后的结果数量: ' + this.processedItems.length);
      // [End PickerMediaLibrary_select]

      // 显示处理结果
      this.showProcessedItems = true;
      // 重置操作状态
      this.fileReadStatus = '';
      this.fileReadLength = 0;
      this.mediaResourceStatus = '';
      this.mediaResourceDataLength = 0;
    } catch (error) {
      console.error('调用PhotoViewPicker.select失败: ' + JSON.stringify(error));
    }
  }

  /**
   * 通过URI打开并读取文件数据
   */
  private readFileDataByUri(): void {
    // 指定URI读取文件数据
    if (!this.selectedUriForRead) {
      this.fileReadStatus = '请先选择一个文件';
      return;
    }

    try {
      this.fileReadStatus = '正在读取文件...';
      const result = MediaLibraryPickerUtils.openAndReadFileData(this.selectedUriForRead);
      if (result) {
        this.fileReadStatus = '文件读取成功';
        this.fileReadLength = result.length;
        console.info('读取到的数据长度: ' + result.length);
      } else {
        this.fileReadStatus = '文件读取失败';
        this.fileReadLength = 0;
      }
    } catch (error) {
      this.fileReadStatus = '文件读取异常';
      this.fileReadLength = 0;
      console.error('读取文件失败: ' + JSON.stringify(error));
    }
  }

  /**
   * 通过URI获取媒体资源
   */
  private async getMediaResourceByUri(): Promise<void> {
    // 指定URI获取图片或视频资源
    if (!this.selectedUriForRead) {
      this.mediaResourceStatus = '请先选择一个文件';
      return;
    }

    try {
      this.mediaResourceStatus = '正在获取媒体资源...';
      
      await MediaLibraryPickerUtils.getMediaResourceByUri(
        this.selectedUriForRead, 
        this.context, 
        (data: ArrayBuffer) => {
          this.mediaResourceStatus = '媒体资源获取成功';
          this.mediaResourceDataLength = data.byteLength;
          console.info('获取到的媒体资源长度: ' + data.byteLength);
        }
      );
    } catch (error) {
      this.mediaResourceStatus = '媒体资源获取异常';
      this.mediaResourceDataLength = 0;
      console.error('获取媒体资源失败: ' + JSON.stringify(error));
    }
  }

  /**
   * 重置选择
   */
  private resetSelection(): void {
    this.selectedUris = [];
    this.processedItems = [];
    this.showProcessedItems = false;
    this.selectedUriForRead = '';
    this.fileReadStatus = '';
    this.fileReadLength = 0;
    this.mediaResourceStatus = '';
    this.mediaResourceDataLength = 0;
  }

  build() {
    Column() {
      Text($r('app.string.picker_media_library_title'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 });

      Button($r('app.string.picker_media_library_open_picker'))
        .onClick(() => this.pickPhotos())
        .backgroundColor('#007DFF')
        .fontColor('#FFFFFF')
        .width('80%')
        .height(50)
        .margin({ bottom: 20 });

      Button($r('app.string.picker_media_library_reset_selection'))
        .onClick(() => this.resetSelection())
        .backgroundColor('#F0F0F0')
        .fontColor('#333333')
        .width('80%')
        .height(50)
        .margin({ bottom: 20 });

      // 新增按钮：通过URI读取文件数据
      if (this.selectedUriForRead) {
        Button('通过URI读取文件数据')
          .onClick(() => this.readFileDataByUri())
          .backgroundColor('#28A745')
          .fontColor('#FFFFFF')
          .width('80%')
          .height(50)
          .margin({ bottom: 10 });

        // 显示文件读取状态
        if (this.fileReadStatus) {
          Text(this.fileReadStatus)
            .fontSize(14)
            .fontColor(this.fileReadStatus.includes('成功') ? Color.Green : Color.Red)
            .margin({ bottom: 5 });
          if (this.fileReadLength > 0) {
            Text(`读取到的数据长度: ${this.fileReadLength} 字节`)
              .fontSize(14)
              .margin({ bottom: 10 });
          }
        }

        // 新增按钮：通过URI获取媒体资源
        Button('通过URI获取媒体资源')
          .onClick(() => this.getMediaResourceByUri())
          .backgroundColor('#FFC107')
          .fontColor('#333333')
          .width('80%')
          .height(50)
          .margin({ bottom: 10 });

        // 显示媒体资源获取状态
        if (this.mediaResourceStatus) {
          Text(this.mediaResourceStatus)
            .fontSize(14)
            .fontColor(this.mediaResourceStatus.includes('成功') ? Color.Green : Color.Red)
            .margin({ bottom: 5 });
          if (this.mediaResourceDataLength > 0) {
            Text(`获取到的媒体资源长度: ${this.mediaResourceDataLength} 字节`)
              .fontSize(14)
              .margin({ bottom: 20 });
          }
        }

        // 显示当前选中的URI
        Text(`当前操作的文件URI: ${this.selectedUriForRead}`)
          .fontSize(12)
          .padding(8)
          .backgroundColor(0xF0F0F0)
          .borderRadius(5)
          .width('95%')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .margin({ bottom: 20 });
      }

      if (this.selectedUris.length > 0) {
        Text(`${$r('app.string.picker_media_library_selected_items')} ${this.selectedUris.length}`)
          .fontSize(16)
          .margin({ bottom: 10 });

        List() {
          ForEach(this.selectedUris, (uri: string, index: number) => {
            ListItem() {
              Column() {
                // 显示图片
                Image(uri)
                  .height(150)
                  .width('100%')
                  .objectFit(ImageFit.Cover)
                  .borderRadius(5)
                  .margin({ bottom: 5 });
                // 显示URI
                // 优化长文本拼接，拆分到多行
                Text(`${$r('app.string.picker_media_library_item')}
                  ${index + 1}
                  ${$r('app.string.picker_media_library_colon')}
                  ${uri}`)
                  .fontSize(14)
                  .padding(5)
                  .backgroundColor(0xF0F0F0)
                  .borderRadius(5)
                  .width('100%')
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1);
              }
              .padding(10)
              .backgroundColor(0xF0F0F0)
              .borderRadius(5)
              .margin({ bottom: 10 });
            }
          })
        }
        .height(300)
        .width('100%')
        .scrollBar(BarState.Auto);
      }

      if (this.showProcessedItems) {
        Text($r('app.string.picker_media_library_processed_result'))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 10 });
        
        if (this.processedItems.length > 0) {
          List() {
            ForEach(this.processedItems, (item: PhotoItem, index: number) => {
              ListItem() {
                Column() {
                  Text(`${$r('app.string.picker_media_library_processed_item')} ${index + 1}`)
                    .fontSize(16)
                    .margin({ bottom: 5 });
                  Text(`${$r('app.string.picker_media_library_uri')} ${item.uri}`)
                    .fontSize(14)
                    .margin({ bottom: 3 });
                  Text(`${$r('app.string.picker_media_library_mime_type')} ${item.mimeType}`)
                    .fontSize(14);
                }
                .padding(10)
                .backgroundColor(0xE6F2FF)
              .borderRadius(5)
              .margin({ bottom: 5 });
              }
            })
          }
          .height(200)
          .width('100%')
          .scrollBar(BarState.Auto);
        } else {
          Text($r('app.string.picker_media_library_no_result'))
            .fontSize(14)
            .margin({ bottom: 10 });
        }
      }
    }
    .padding(20)
    .width('100%')
    .height('100%');
  }
}
// [End PickerMediaLibrary_full]