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

// [Start xmp_import]
// 导入相关模块。
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End xmp_import]

export class XMPUtility {
  async registerBookNamespace(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      const bookNamespace: image.XMPNamespace = { prefix: 'book', uri: 'urn:example:book:1.0' };
      await xmpMetadata.registerXMPNamespace(bookNamespace);
    } catch (error) {
      const code = (error as BusinessError).code;
      const message = (error as BusinessError).message;
      console.warn(`registerXMPNamespace skipped. code is ${code}, message is ${message}`);
    }
  }

  // [Start create_xmp_metadata]
  async createXMPMetadata(): Promise<image.XMPMetadata> {
    let xmpMetadata = new image.XMPMetadata();
    console.info('Succeeded in creating XMPMetadata.');
    return xmpMetadata;
  }
  // [End create_xmp_metadata]

  // [Start read_xmp_metadata_from_image]
  async readXMPMetadataFromImage(imageSource: image.ImageSource): Promise<image.XMPMetadata | undefined> {
    let types: image.MetadataType[] = [image.MetadataType.XMP_METADATA];
    try {
      let metaData: image.ImageMetadata = await imageSource.readImageMetadataByType(types);
      if (metaData != undefined && metaData.xmpMetadata != undefined) {
        // 成功获取XMPMetadata对象。
        let xmpMetadata = metaData.xmpMetadata;
        console.info('Succeeded in reading XMP metadata from image.');
        return xmpMetadata;
      }
      console.info('Failed to read XMP metadata from image.');
      return undefined;
    } catch (error) {
      console.error(`Failed to read XMP metadata. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
      return undefined;
    }
  }
  // [End read_xmp_metadata_from_image]

  // [Start operate_xmp_metadata]
  async operateXMPMetadata(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 设置xmp:title标签的值。
      await xmpMetadata.setValue(`${image.XMP_BASIC.prefix}:title`, image.XMPTagType.STRING, 'My Title');

      // 获取xmp:title路径的标签。
      let tag: image.XMPTag | null = await xmpMetadata.getTag(`${image.XMP_BASIC.prefix}:title`);
      console.info(`${image.XMP_BASIC.prefix}:title: ${tag?.value}`);

      // 删除xmp:title标签。
      await xmpMetadata.removeTag(`${image.XMP_BASIC.prefix}:title`);
    } catch (error) {
      console.error(`Failed to operate XMP tags. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End operate_xmp_metadata]

  // [Start write_xmp_metadata_to_image]
  async writeXMPMetadataToImage(imageSource: image.ImageSource, xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 将修改后的ImageMetadata（包含XMPMetadata）写回图片。
      let metaData: image.ImageMetadata = { xmpMetadata: xmpMetadata } as image.ImageMetadata;
      await imageSource.writeImageMetadata(metaData);
      console.info('Succeeded in writing XMP metadata to image.');
    } catch (error) {
      console.error(`Failed to write XMP metadata. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End write_xmp_metadata_to_image]

  // [Start set_and_get_basic_tag]
  async setAndGetBasicTag(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 设置xmp:title标签的值，类型为字符串，值为'My Title'。
      await xmpMetadata.setValue(`${image.XMP_BASIC.prefix}:title`, image.XMPTagType.STRING, 'My Title');

      // 获取xmp:title路径的标签。
      let tag: image.XMPTag | null = await xmpMetadata.getTag(`${image.XMP_BASIC.prefix}:title`);
      console.info(`${image.XMP_BASIC.prefix}:title: ${tag?.value}`);
    } catch (error) {
      console.error(`Failed to set or get basic tag. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End set_and_get_basic_tag]

  // [Start create_array_and_add_elements]
  async createArrayAndAddElements(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 创建无序数组容器。
      await xmpMetadata.setValue('book:fruits', image.XMPTagType.UNORDERED_ARRAY, undefined);

      // 向数组中添加多个元素，数组索引起始值为1。
      let fruits: string[] = ['apple', 'banana'];
      for (let i = 0; i < fruits.length; i++) {
        await xmpMetadata.setValue(`book:fruits[${i + 1}]`, image.XMPTagType.STRING, fruits[i]);
      }
      console.info('Succeeded in creating array and adding elements.');
    } catch (error) {
      console.error(`Failed to create array or add elements. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End create_array_and_add_elements]

  // [Start get_array_elements]
  async getArrayElements(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 获取第二个元素。
      let tag2: image.XMPTag | null = await xmpMetadata.getTag('book:fruits[2]');
      console.info(`book:fruits[2]: ${tag2?.value}`);

      // 获取最后一个元素。
      let lastTag: image.XMPTag | null = await xmpMetadata.getTag('book:fruits[last()]');
      console.info(`book:fruits[last()]: ${lastTag?.value}`);
    } catch (error) {
      console.error(`Failed to get array elements. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End get_array_elements]

  // [Start create_struct_and_operate_members]
  async createStructAndOperateMembers(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 创建结构体父节点。
      await xmpMetadata.setValue('book:parentNode', image.XMPTagType.STRUCTURE, undefined);

      // 添加结构体成员。
      let members: Record<string, string> = {
        'child1': 'child1 value',
        'child2': 'child2 value'
      };
      for (const entry of Object.entries(members)) {
        await xmpMetadata.setValue(`book:parentNode/book:${entry[0]}`, image.XMPTagType.STRING, entry[1]);
      }

      // 获取结构体成员的值。
      let childTag: image.XMPTag | null = await xmpMetadata.getTag('book:parentNode/book:child1');
      console.info(`book:parentNode/book:child1: ${childTag?.value}`);
    } catch (error) {
      console.error(`Failed to operate structure members. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End create_struct_and_operate_members]

  // [Start set_and_get_qualifier]
  async setAndGetQualifierValue(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 设置主标签 book:bookTitle
      await xmpMetadata.setValue('book:bookTitle', image.XMPTagType.STRING, 'My Book Title');
      // 为主标签添加限定符 book:lastUpdated
      await xmpMetadata.setValue('book:bookTitle/?book:lastUpdated', image.XMPTagType.STRING, '2024-01-15');
      console.info('Succeeded in setting tag and qualifier.');

      // 获取限定符的值
      let qualifierTag: image.XMPTag | null = await xmpMetadata.getTag('book:bookTitle/?book:lastUpdated');
      console.info(`book:bookTitle/?book:lastUpdated: ${qualifierTag?.value}`);
    } catch (error) {
      console.error(`Failed to operate qualifier. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End set_and_get_qualifier]

  // [Start set_language_qualifier]
  async setLanguageQualifier(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 创建语言替代数组容器。
      await xmpMetadata.setValue(`${image.DUBLIN_CORE.prefix}:title`, image.XMPTagType.ALTERNATE_TEXT, undefined);

      // 添加第一个多语言文本元素，并设置其语言限定符。
      await xmpMetadata.setValue(`${image.DUBLIN_CORE.prefix}:title[1]`, image.XMPTagType.STRING, 'Hello');
      await xmpMetadata.setValue(`${image.DUBLIN_CORE.prefix}:title[1]/?xml:lang`, image.XMPTagType.STRING, 'en-US');

      // 添加第二个多语言文本元素及语言限定符。
      await xmpMetadata.setValue(`${image.DUBLIN_CORE.prefix}:title[2]`, image.XMPTagType.STRING, '你好');
      await xmpMetadata.setValue(`${image.DUBLIN_CORE.prefix}:title[2]/?xml:lang`, image.XMPTagType.STRING, 'zh-CN');

      // 获取第一个元素的语言限定符。
      let langTag: image.XMPTag | null = await xmpMetadata.getTag(`${image.DUBLIN_CORE.prefix}:title[1]/?xml:lang`);
      console.info(`dc:title[1]/?xml:lang: ${langTag?.value}`);
    } catch (error) {
      console.error(`Failed to set language qualifier. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End set_language_qualifier]

  // [Start enumerate_namespace_tags]
  async enumerateNamespaceTags(xmpMetadata: image.XMPMetadata): Promise<void> {
    try {
      // 遍历Dublin Core命名空间下的全部字段。
      xmpMetadata.enumerateTags((path: string, tag: image.XMPTag): boolean => {
        console.info(`path: ${path}, name: ${tag.name}, value: ${tag.value}`);
        return true;  // 返回true继续遍历。
      }, `${image.DUBLIN_CORE.prefix}`, { isRecursive: true, onlyQualifier: false });
      console.info('Succeeded in enumerating namespace tags.');
    } catch (error) {
      console.error(`Failed to enumerate namespace tags. code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
  // [End enumerate_namespace_tags]
}
