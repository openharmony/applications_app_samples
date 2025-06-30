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
 *
 **/

import { Constants } from '../../constants/Constants';
import { ArticleSource } from '../../model/collapsemenu/BasicDataSource';
import { TreeNode } from '../../model/collapsemenu/TreeNode';
import { Text, List, ListItem, Column, LazyForEach, Button, Image, Row, ForEach,
         ButtonAttribute, ClickEvent, Component, BuilderParam, Padding, $r,
         BarState, NestedScrollOptions, NestedScrollMode, Color, JSON, Alignment,
         ListItemGroup, Divider, Builder, Margin, Blank, Entry
          } from '@ohos.arkui.component'
import { Provide, State, ObjectLink, Consume } from '@ohos.arkui.stateManagement'
import { ARTICLENODE_DATAS } from '../../model/constantsData'
import { ARTICLE_DATA1 } from '../../model/collapsemenu/MockXrData';
import hilog from '@ohos.hilog'
import { UIContext } from '@ohos.arkui.UIContext'

/**
 * 功能描述：
 * 1. 进入页面，呈现面板列表，点击普通面板，跳转到对应文章的网页。
 * 2. 点击折叠面板，面板展开，再次点击，面板收起。
 *
 * 实现原理：
 * 1. 使用List组件遍历折叠面板数据，如果数据含有children数据，使用ListGroup进行二次遍历渲染。(当前场景只支持嵌套层次为两级，多层级待扩展)
 * 2. 点击ListGroup的header组件以及visibility来控制子列表的显示和隐藏。
 *
 * @param {ArticleNode[]} articleNodes - 折叠面板列表数据
 * @param {(articleNode: ArticleNode)=>void} articleItemBuilder - 列表项视图
 * @param {(articleNode: ArticleNode, isExpand:boolean)=>void} articleHeaderBuilder - 列表头部视图
 */

@Entry
@Component
export struct CollapseMenuSection {
  // 折叠面板列表数据
  articleNodes: TreeNode[] = ARTICLE_DATA1;
  // 懒加载数据
  articleSource: ArticleSource<TreeNode> = new ArticleSource<TreeNode>(this.articleNodes);

  build() {
    Column() {
      Row() {
        Text($r('app.string.custom_return'))
      }
      .margin(3)
      .width('100%')
      .onClick((e: ClickEvent) => {
        this.getUIContext().getRouter().back();
      })
    List({ space: 10 }) {
      LazyForEach(this.articleSource, (item: TreeNode, index: number) => {
        if (item.children?.length) {
          ListItemGroup() {
            ListItem() {
              this.articleHeaderBuilder(item)
            }
            .onClick((e: ClickEvent) => {
              item.expand = !item.expand;
              this.articleSource.updateData(index, item);
            })

            if (item.expand && item.children) {
              this.treeBuilder(item.children as TreeNode[], 1, index)
            }
          }
          .width('100%')
          .borderRadius(12)
          .backgroundColor(Color.White)
          .padding({
            left: 12,
            right: 12,
            bottom: 4,
            top: 4
          } as Padding)
          .align(Alignment.TopStart)

        } else {
          ListItem() {
            this.articleItemBuilder(item);
          }
          .width('100%')
          .borderRadius(12)
          .backgroundColor(Color.White)
          .padding({
            left: 12,
            right: 12,
            bottom: 4,
            top: 4
          } as Padding)
          .align(Alignment.TopStart)
        }
      }, (itemj: TreeNode ,index: number ) => {return itemj.title + itemj.expand + index})
    }
    .width('100%')
    .padding({
      left: 12,
      right: 12,
      bottom: 12
    } as Padding)
    .backgroundColor('#F3F3F3')
  }
}

  @Builder
  articleItemBuilder(articleNode: TreeNode) {
    Column() {
      Row() {
        Text(articleNode.title)
          .fontSize($r('app.integer.collapse_menu_text_font_size'))
          .layoutWeight(1)
          .align(Alignment.Start)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.font_color_dark'))
        Blank()
      }
      .height(48)
      .width('100%')
      .onClick((e: ClickEvent) => {
        if (articleNode.url) {

        }
      })
    }
  }

  @Builder
  articleHeaderBuilder(articleNode: TreeNode) {
    Row() {
      Text(articleNode.title)
        .fontSize($r('app.integer.collapse_menu_text_font_size'))
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor($r('app.color.font_color_dark'))
      Blank()
      Image(articleNode.expand ? $r('app.media.ic_down_arrow') : $r('app.media.ic_right_arrow'))
        .width(articleNode.expand  ? 24 :
        12)
        .height(articleNode.expand  ? 12 :
        24)
        .margin({ right: 6} as Margin)
    }
    .height(56)
    .width('100%')
  }

  @Builder
  treeBuilder(articleNodes: TreeNode[], count: number, parentIndex: number) {
    ForEach(articleNodes, (articleNode: TreeNode, index: number) => {
      this.createBuilder(articleNode, count, parentIndex)
      if (articleNode.expand === true && articleNode?.children?.length) {
        this.treeBuilder(articleNode.children as TreeNode[], count + 1, index)
      }
    })
  }

  @Builder
  createBuilder(articleNode: TreeNode, count: number, parentIndex: number) {
    ArticleItem({
      articleNode: articleNode,
      count,
      articleGroupIndex: parentIndex
    })
  }

}


@Component
struct ArticleItem {
  articleNode: TreeNode = {} as TreeNode;
  count: number = 0;
  @State articleSource: ArticleSource<TreeNode> = {} as ArticleSource<TreeNode>;
  articleGroupIndex: number = -1;
  build() {
    ListItem() {
      Column() {
        Column() {
          if (this.articleNode.type === Constants.COLLAPSE_MENU) {
            Column() {
              this.articleHeaderBuilder({
                expand: this.articleNode.expand,
                type: this.articleNode.type,
                title: this.articleNode.title,
                url: this.articleNode.url,
                children: this.articleNode.children,
              } as TreeNode)
            }
            .onClick((e: ClickEvent) => {

            })
          } else {
            this.articleItemBuilder(this.articleNode);
          }
        }
        .width('100%')
        Divider()
          .height(1)
          .opacity(0.2)
          .color($r('app.color.font_color_dark'))
      }
    }
  }

  @Builder
  articleItemBuilder(articleNode: TreeNode) {
    Column() {
      Row() {
        Text(articleNode.title)
          .fontSize($r('app.integer.collapse_menu_text_font_size'))
          .layoutWeight(1)
          .align(Alignment.Start)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.font_color_dark'))
        Blank()
      }
      .height(48)
      .width('100%')
      .onClick((e: ClickEvent) => {
        if (articleNode.url) {
          this.getUIContext().getRouter().pushUrl({url: 'pages/collapsemenu/Concent'});
        }
      })
    }
  }

  @Builder
  articleHeaderBuilder(articleNode: TreeNode) {
    Row() {
      Text(articleNode.title)
        .fontSize($r('app.integer.collapse_menu_text_font_size'))
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor($r('app.color.font_color_dark'))
      Blank()
      Image(articleNode.expand ? $r('app.media.ic_down_arrow') : $r('app.media.ic_right_arrow'))
        .width(articleNode.expand  ? 24 :
          12)
        .height(articleNode.expand  ? 12 :
          24)
        .margin({ right: 6} as Margin)
    }
    .height(56)
    .width('100%')
  }
}