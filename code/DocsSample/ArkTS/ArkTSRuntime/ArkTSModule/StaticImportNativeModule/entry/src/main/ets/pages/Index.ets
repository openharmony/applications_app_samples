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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import { CommonButton } from '../util/CommonButton';
import resource from '../util/resource';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
            hilog.info(DOMAIN, 'testTag', 'Test NAPI 2 + 3 = %{public}d', testNapi.add(2, 3));
          })
        CommonButton({
          buttonName: 'default_import',
          buttonUrl: 'pages/DirectImport/DefaultImport/test'
        });
        CommonButton({
          buttonName: 'named_import',
          buttonUrl: 'pages/DirectImport/NamedImport/test'
        });
        CommonButton({
          buttonName: 'namespace_import',
          buttonUrl: 'pages/DirectImport/NamespaceImport/test'
        });
        CommonButton({
          buttonName: 'direct_import',
          buttonUrl: 'pages/DynamicImport/DirectImport/test'
        });
        CommonButton({
          buttonName: 'indirect_import',
          buttonUrl: 'pages/DynamicImport/IndirectImport/test2'
        });
        CommonButton({
          buttonName: 'export_named_and_import',
          buttonUrl: 'pages/IndirectImport/ExportNamedAndImport/test2'
        });
        CommonButton({
          buttonName: 'export_namespace_and_import',
          buttonUrl: 'pages/IndirectImport/ExportNamespaceAndImport/test2'
        });
      }
      .width('100%')
    }
    .height('100%')
  }
}
