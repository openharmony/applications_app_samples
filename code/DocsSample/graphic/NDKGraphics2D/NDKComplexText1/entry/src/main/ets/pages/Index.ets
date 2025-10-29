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
    label: '多语言文本绘制与显示',
    targetPage: 'NdkPage',
    params: 'drawMultilingualText'
  },
  {
    label: '多行文本绘制与显示',
    targetPage: 'NavTreePage',
    params: [
      {
        label: 'BREAK_ALL',
        targetPage: 'NdkPage',
        params: 'drawBreakAllText'
      },
      {
        label: 'BREAK_WORD',
        targetPage: 'NdkPage',
        params: 'drawBreakWordText'
      },
      {
        label: 'BREAK_HYPHEN',
        targetPage: 'NdkPage',
        params: 'drawBreakHyphenText'
      },
      {
        label: 'BREAK_HYPHEN (locale: en-gb)',
        targetPage: 'NdkPage',
        params: 'drawBreakHyphenGBText'
      },
      {
        label: 'BREAK_HYPHEN (locale: en-us)',
        targetPage: 'NdkPage',
        params: 'drawBreakHyphenUSText'
      },
    ]
  },
  {
    label: '多样式文本绘制与显示',
    targetPage: 'NavTreePage',
    params: [
      {
        label: '装饰线',
        targetPage: 'NdkPage',
        params: 'drawDecorationText'
      },
      {
        label: '字体特征',
        targetPage: 'NdkPage',
        params: 'drawFontFeatureText'
      },
      {
        label: '可变字体',
        targetPage: 'NdkPage',
        params: 'drawFontVariationText'
      },
      {
        label: '文本阴影',
        targetPage: 'NdkPage',
        params: 'drawShadowText'
      },
      {
        label: '占位符',
        targetPage: 'NdkPage',
        params: 'drawPlaceholderText'
      },
      {
        label: '自动间距',
        targetPage: 'NdkPage',
        params: 'drawAutoSpaceText'
      },
      {
        label: '渐变色',
        targetPage: 'NdkPage',
        params: 'drawGradientText'
      },
      {
        label: '垂直对齐',
        targetPage: 'NdkPage',
        params: 'drawVerticalAlignmentText'
      },
      {
        label: '上下标',
        targetPage: 'NdkPage',
        params: 'drawBadgeText'
      },
      {
        label: '高对比度',
        targetPage: 'NdkPage',
        params: 'drawHighContrastText'
      },
      {
        label: '行高调整1',
        targetPage: 'NdkPage',
        params: 'drawLineHeightLimitOneText'
      },
      {
        label: '行高调整2',
        targetPage: 'NdkPage',
        params: 'drawLineHeightLimitTwoText'
      },
      {
        label: '行间距调整',
        targetPage: 'NdkPage',
        params: 'drawLineSpacingText'
      }
    ]
  },
  {
    label: '样式的拷贝、绘制与显示',
    targetPage: 'NdkPage',
    params: 'drawStyleCopyText'
  },
  {
    label: '独立塑形',
    targetPage: 'NdkPage',
    params: 'drawIndependentShapingText'
  }
]