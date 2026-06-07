/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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
import { common } from '@kit.AbilityKit';
import { ImageInterfaceCalled } from '../tools/CodecUtility';
import { UIComponentsBuilder } from '../tools/components';
import { XMPUtility } from '../tools/XMPUtility';
import { Router } from '@ohos.arkui.UIContext';

const router = new Router();
const uiComponents = new UIComponentsBuilder();
let fileName: string = 'jpeg_xmp.jpg';

@Entry
@Component
struct EditXMP {
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State imageSource: image.ImageSource | undefined = undefined;
  @State xmpMetadata: image.XMPMetadata | undefined = undefined;
  @State imageInterfaceCalled: ImageInterfaceCalled = new ImageInterfaceCalled();
  @State xmpUtility: XMPUtility = new XMPUtility();
  @State info: string = '';
  @State visible: Visibility = Visibility.Hidden;
  @State logText: string = '';

  async prepareImageSource(): Promise<image.ImageSource | undefined> {
    await uiComponents.pushSourceToBox(this.context, fileName);
    this.imageSource?.release();
    this.imageSource = this.imageInterfaceCalled.createImageSourceByFilePath(this.context, fileName);
    return this.imageSource;
  }

  async ensureXmpMetadata(): Promise<image.XMPMetadata | undefined> {
    if (this.xmpMetadata != undefined) {
      // 注册自定义命名空间。
      this.xmpUtility.registerBookNamespace(this.xmpMetadata);
      return this.xmpMetadata;
    }
    let source = await this.prepareImageSource();
    if (source == undefined) {
      this.info = 'Failed to create ImageSource.';
      this.visible = Visibility.Visible;
      return undefined;
    }
    this.xmpMetadata = await this.xmpUtility.readXMPMetadataFromImage(source);
    if (this.xmpMetadata == undefined) {
      this.xmpMetadata = await this.xmpUtility.createXMPMetadata();
    }

    // 注册自定义命名空间。
    this.xmpUtility.registerBookNamespace(this.xmpMetadata);
    return this.xmpMetadata;
  }

  releaseActual() {
    this.imageSource?.release();
    this.imageSource = undefined;
    this.xmpMetadata = undefined;
  }

  appendLog(line: string) {
    if (!this.logText) {
      this.logText = line;
      return;
    }
    this.logText = `${this.logText}\n${line}`;
  }

  clearLogs() {
    this.logText = '';
  }

  formatPathValue(path: string, value: string): string {
    return `XMP路径: ${path} | value: ${value}`;
  }

  async executeAction(action: () => Promise<string>) {
    this.clearLogs();
    try {
      let line = await action();
      this.appendLog(line);
    } catch (error) {
      this.appendLog(`执行失败: ${error}`);
    }
  }

  build() {
    Column() {
      Text('EditXMP 示例页')
        .fontSize(22)
        .fontWeight(600)
        .margin({ top: 12, bottom: 8 })

      Scroll() {
        Column() {
          Button('创建XMPMetadata').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              this.xmpMetadata = await this.xmpUtility.createXMPMetadata();
              return '接口: new image.XMPMetadata()\n结果: Succeeded in creating XMPMetadata.';
            });
          })
            .width('65%')
            .margin(10)

          Button('从图片读取XMPMetadata').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              let source = await this.prepareImageSource();
              if (source == undefined) {
                return '结果: Failed to create ImageSource.';
              }
              this.xmpMetadata = await this.xmpUtility.readXMPMetadataFromImage(source);
              return `接口: imageSource.readImageMetadataByType([image.MetadataType.XMP_METADATA])\n${
                this.xmpMetadata == undefined ? '结果: No XMP metadata in image.' : '结果: Succeeded in reading XMP metadata from image.'
              }`;
            });
          })
            .width('65%')
            .margin(10)

          Button('接口串联示例(set/get/remove/write)').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              let source = await this.prepareImageSource();
              if (source == undefined) {
                return '结果: Failed to create ImageSource.';
              }
              this.xmpMetadata = await this.xmpUtility.readXMPMetadataFromImage(source);
              if (this.xmpMetadata == undefined) {
                this.xmpMetadata = await this.xmpUtility.createXMPMetadata();
              }

              const path = `${image.XMP_BASIC.prefix}:title`;
              await this.xmpUtility.operateXMPMetadata(this.xmpMetadata);
              let tagAfterOperate: image.XMPTag | null = await this.xmpMetadata.getTag(path);

              await this.xmpUtility.writeXMPMetadataToImage(source, this.xmpMetadata);

              return `接口链路: readImageMetadataByType -> operateXMPMetadata -> writeImageMetadata\n${
                this.formatPathValue(path, tagAfterOperate?.value ?? 'undefined(removed)')
              }\n结果: Succeeded in running API chain flow.`;
            });
          })
            .width('65%')
            .margin(10)

          Button('基本属性路径示例').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              let metadata = await this.ensureXmpMetadata();
              if (metadata == undefined) {
                return '结果: Failed to create XMPMetadata.';
              }
              await this.xmpUtility.setAndGetBasicTag(metadata);
              const path = `${image.XMP_BASIC.prefix}:title`;
              let tag: image.XMPTag | null = await metadata.getTag(path);
              return `接口: setValue/getTag\n${this.formatPathValue(path, tag?.value ?? 'undefined')}\n结果: Succeeded in setting and getting basic tag.`;
            });
          })
            .width('65%')
            .margin(10)

          Button('数组索引示例').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              let metadata = await this.ensureXmpMetadata();
              if (metadata == undefined) {
                return '结果: Failed to create XMPMetadata.';
              }
              await this.xmpUtility.createArrayAndAddElements(metadata);
              await this.xmpUtility.getArrayElements(metadata);
              let secondTag: image.XMPTag | null = await metadata.getTag('book:fruits[2]');
              let lastTag: image.XMPTag | null = await metadata.getTag('book:fruits[last()]');
              return `接口: setValue/getTag(数组索引)\n${
                this.formatPathValue('book:fruits[2]', secondTag?.value ?? 'undefined')
              }\n${this.formatPathValue('book:fruits[last()]', lastTag?.value ?? 'undefined')}\n结果: Succeeded in operating array index path.`;
            });
          })
            .width('65%')
            .margin(10)

          Button('结构体成员示例').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              let metadata = await this.ensureXmpMetadata();
              if (metadata == undefined) {
                return '结果: Failed to create XMPMetadata.';
              }
              await this.xmpUtility.createStructAndOperateMembers(metadata);
              let childTag: image.XMPTag | null = await metadata.getTag('book:parentNode/book:child1');
              return `接口: setValue/getTag(结构体成员)\n${
                this.formatPathValue('book:parentNode/book:child1', childTag?.value ?? 'undefined')
              }\n结果: Succeeded in operating structure member path.`;
            });
          })
            .width('65%')
            .margin(10)

          Button('限定符示例').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              let metadata = await this.ensureXmpMetadata();
              if (metadata == undefined) {
                return '结果: Failed to create XMPMetadata.';
              }
              await this.xmpUtility.setAndGetQualifierValue(metadata);
              let qualifierTag: image.XMPTag | null = await metadata.getTag('book:bookTitle/?book:lastUpdated');
              return `接口: setValue/getTag(限定符)\n${
                this.formatPathValue('book:bookTitle/?book:lastUpdated', qualifierTag?.value ?? 'undefined')
              }\n结果: Succeeded in operating qualifier path.`;
            });
          })
            .width('65%')
            .margin(10)

          Button('多语言限定符示例').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              let metadata = await this.ensureXmpMetadata();
              if (metadata == undefined) {
                return '结果: Failed to create XMPMetadata.';
              }
              await this.xmpUtility.setLanguageQualifier(metadata);
              let lang1Tag: image.XMPTag | null = await metadata.getTag(`${image.DUBLIN_CORE.prefix}:title[1]/?xml:lang`);
              let lang2Tag: image.XMPTag | null = await metadata.getTag(`${image.DUBLIN_CORE.prefix}:title[2]/?xml:lang`);
              return `接口: setValue/getTag(多语言限定符)\n${
                this.formatPathValue(`${image.DUBLIN_CORE.prefix}:title[1]/?xml:lang`, lang1Tag?.value ?? 'undefined')
              }\n${this.formatPathValue(`${image.DUBLIN_CORE.prefix}:title[2]/?xml:lang`, lang2Tag?.value ?? 'undefined')}\n结果: Succeeded in setting language qualifier.`;
            });
          })
            .width('65%')
            .margin(10)

          Button('命名空间遍历示例').onClick(async () => {
            await this.executeAction(async (): Promise<string> => {
              let metadata = await this.ensureXmpMetadata();
              if (metadata == undefined) {
                return '结果: Failed to create XMPMetadata.';
              }
              await this.xmpUtility.enumerateNamespaceTags(metadata);
              return `接口: enumerateTags(rootPath='${image.DUBLIN_CORE.prefix}')\n结果: Succeeded in enumerating namespace tags.`;
            });
          })
            .width('65%')
            .margin(10)

          Button('资源释放').onClick(() => {
            this.releaseActual();
            this.appendLog('结果: 资源已释放。');
          })
            .width('65%')
            .margin(10)

          Button('back')
            .width('65%')
            .margin(10)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Index' });
            })
        }
        .width('100%')
        .padding({ bottom: 10 })
        .margin(10)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('58%')

      Column() {
        Text('执行日志')
          .fontSize(18)
          .margin({ top: 8, bottom: 8 })

        Scroll() {
          Column() {
            Text(this.logText ? this.logText : '暂无日志，请点击上方示例按钮。')
              .width('96%')
              .padding(8)
              .margin({ bottom: 6 })
              .border({ width: 1, color: Color.Blue })
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
      }
      .width('95%')
      .height('38%')
      .border({ width: 1, color: Color.Red })
      .padding(6)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}
