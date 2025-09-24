'use static';
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
import { TreeNode } from './collapsemenu/TreeNode';
export const STYLE_CONFIGURATION: Record<string, number> = {
  'TAB_BAR_HEIGHT': 48, // 页签高度
  'ICON_SIZE': 16, // 图标尺寸
  'TAB_BAR_CONTENT_GUTTER': 6, // 页签内元素间距
  'TAB_BAR_ITEM_GUTTER': 6, // 页签间距
  'SEPARATOR_STROKE_WIDTH': 2, // 分割线宽度
  'CONTENT_GUTTER_M': 12, // 元素间距
  'CONTENT_GUTTER_S': 8, // 元素间距
  'GRID_HEIGHT': 170, // 快捷方式高度
  'GRID_MARGIN': 48, // 快捷方式外边距
  'TAB_SHEET_PADDING': 6, // 页签内边距
  'IMAGE_SIZE': 56, // 图片尺寸
  'IMAGE_RADIUS': 32, // 图片圆角
  'TEXT_HEIGHT': 12, // 文本高度
  'TEXT_WIDTH': 48, // 文本宽度
  'SEARCH_HEIGHT': 28, // 工具栏搜索框高度
  'BIG_ICON_SIZE': 30, // 添加和删除按钮的尺寸
  'BIG_ICON_PADDING': 7, // 添加和删除按钮的padding值
  'IMAGE_MARGIN':12 // 当添加到第六个标签删除按钮的margin值
}

export const  ARTICLENODE_DATAS: TreeNode[] = [
  {
    expand: true,
    type: 2,
    title: '第一章：基础入门',
    url: 'video1',
    children: [
      {
        expand: true,
        type: 2,
        title: '1.1 介绍',
        url: 'video1-1',
        children: []
      },
      {
        expand: true,
        type: 2,
        title: '1.2 安装环境',
        url: 'video1-2',
        children: []
      }
    ]
  },
  {
    expand: false,
    type: 1,
    title: '第二章：进阶技巧',
    url: 'video2',
    children: [
      {
        expand: false,
        type: 2,
        title: '2.1 性能优化',
        url: 'video2-1',
        children: []
      }
    ]
  }
];

