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
    { name: $r('app.string.arkts_custom_components_freeze1'), path: 'View/Page1' },
    { name: $r('app.string.arkts_custom_components_freeze2'), path: 'View/PageTwo' },
    { name: $r('app.string.arkts_custom_components_freeze3'), path: 'View/TabContentTest' },
    { name: $r('app.string.arkts_custom_components_freeze4'), path: 'View/LazyforEachTest' },
    { name: $r('app.string.arkts_custom_components_freeze5'), path: 'View/MyNavigationTestStack' },
    { name: $r('app.string.arkts_custom_components_freeze6'), path: 'View/ComponentReuse' },
    { name: $r('app.string.arkts_custom_components_freeze7'), path: 'View/ComponentReuse1' },
    { name: $r('app.string.arkts_custom_components_freeze8'), path: 'View/ComponentReuse2' },
    { name: $r('app.string.arkts_custom_components_freeze9'), path: 'View/ComponentMixing' },
    { name: $r('app.string.arkts_custom_components_freeze10'), path: 'View/ComponentMixing1' },
    { name: $r('app.string.arkts_custom_components_freeze11'), path: 'View/Constraints' }
  ]

  build() {
    Column() {
      ForEach(this.lists, (item: Router, index: number) => {
        Button(item.name)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: item.path })
          })
      })
    }
  }
}
// [End arkts_custom_components_freeze_Page_Index]