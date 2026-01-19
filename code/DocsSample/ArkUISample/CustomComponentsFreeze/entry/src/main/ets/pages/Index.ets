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
// [Start arkts_custom_components_freeze_Page_Index]
import { Router } from '../model/routerModle';

@Entry
@Component
struct Index {
  @State lists: Router [] = [
    { name: 'Page 1 Page 2 Jump', path: 'View/Page1' },
    { name: 'Page 2 Go back to the previous page', path: 'View/PageTwo' },
    { name: 'TabContent creation', path: 'View/TabContentTest' },
    { name: 'Freeze custom components cached in LazyForEach', path: 'View/LazyforEachTest' },
    { name: 'NavigationContentMsStack will be set to inactive state', path: 'View/MyNavigationTestStack' },
    { name: 'Mixed scenario of component reuse, if, and component freezing', path: 'View/ComponentReuse' },
    { name: 'LazyForEach、 Mixed scenario of component reuse and component freezing', path: 'View/ComponentReuse1' },
    { name: 'LazyForEach、if、 Mixed scenario of component reuse and component freezing', path: 'View/ComponentReuse2' },
    { name: 'Mixing Navigation and TabContent', path: 'View/ComponentMixing' },
    { name: 'Page and LazyForEach', path: 'View/ComponentMixing1' },
    { name: 'Constraints', path: 'View/Constraints' },
    { name: 'Freeze and Reuse', path: 'View/FreezeReuse' }
  ];

  build() {
    Column() {
      ForEach(this.lists, (item: Router, index: number) => {
        Button(item.name)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: item.path });
          })
      })
    }
  }
}
// [End arkts_custom_components_freeze_Page_Index]