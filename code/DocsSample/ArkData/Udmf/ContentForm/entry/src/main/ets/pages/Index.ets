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

// [Start components_based_on_uniform_data_structure]
// [StartExclude components_based_on_uniform_data_structure]
// 1. 导入需要的模块
// [EndExclude components_based_on_uniform_data_structure]
import { ContentFormCard, FormType, uniformDataStruct } from '@kit.ArkData';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  @State contentForm: uniformDataStruct.ContentForm = {
    uniformDataType: 'general.content-form',
    title: ''
  };
  @State startToShow: boolean = false;

  aboutToAppear(): void {
    // [StartExclude components_based_on_uniform_data_structure]
    // 2. 初始化数据
    // [EndExclude components_based_on_uniform_data_structure]
    this.initData();
  }

  async initData() {
    let context = this.getUIContext().getHostContext();
    if (!context) {
      return;
    }
    try {
      let appIcon = await context.resourceManager.getMediaContent($r('app.media.startIcon').id);
      let thumbImage = await context.resourceManager.getMediaContent($r('app.media.foreground').id);
      this.contentForm = {
        uniformDataType: 'general.content-form',
        title: 'Content form title',
        thumbData: appIcon,
        description: 'Content form description',
        appIcon: thumbImage,
        appName: 'com.test.demo'
      };
    } catch (err) {
      hilog.error(0xFF00, '[Sample_Udmf]', 'Init data error');
    }
  }

  build() {
    Column() {
      Button('show card').fontSize(30)
        .onClick(() => {
          // [StartExclude components_based_on_uniform_data_structure]
          // 3. 点击后startToShow变为true，页面重新渲染
          // [EndExclude components_based_on_uniform_data_structure]
          this.startToShow = true;
        })
      if (this.startToShow) {
        // [StartExclude components_based_on_uniform_data_structure]
        // 4. 使用内容卡片，传入对应的参数
        // [EndExclude components_based_on_uniform_data_structure]
        ContentFormCard({
          contentFormData: this.contentForm,
          formType: FormType.TYPE_SMALL,
          formWidth: 220,
          formHeight: 100,
          handleOnClick: () => {
            hilog.info(0xFF00, '[Sample_Udmf]', 'Clicked card');
          }
        })
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
// [End components_based_on_uniform_data_structure]