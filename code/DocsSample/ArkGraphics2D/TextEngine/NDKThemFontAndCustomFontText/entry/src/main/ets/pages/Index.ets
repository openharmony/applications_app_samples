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
import text from '@ohos.graphics.text';

export interface NavNode {
  label: string
  targetPage: string
  params: string | NavNode[]
}

@Entry
@Component
struct Index {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      Row() {
        Column({ space: 17 }) {
          ForEach(navTree, (node: NavNode) => {
            Button(node.label)
              .width('70%')
              .onClick(() => {
                this.pageStack.pushPathByName(node.targetPage, node.params);
              })
          })
        }
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}


const navTree: NavNode[] = [
  {
    label: '使用主题字体',
    targetPage: 'NdkPage',
    params: 'drawText'
  },
  {
    label: '自定义字体的注册和使用',
    targetPage: 'NdkPage',
    params: 'drawCustomFontText'
  },
  {
    label: '系统字体的信息获取和使用',
    targetPage: 'NavTreePage',
    params: [
      {
        label: '获取系统字体信息',
        targetPage: 'NdkPage',
        params: 'printSysFontMetrics'
      },
      {
        label: '使用或切换系统字体',
        targetPage: 'NdkPage',
        params: 'printSysFontMetrics'
      },
      {
        label: '禁用系统字体',
        targetPage: 'NdkPage',
        params: 'drawDisableSysFontText'
      },
    ]
  },
];