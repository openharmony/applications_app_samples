/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * 通用常量
 */
export default class Constants {
  // 扩展后标题继续下拉阈值
  public static readonly CONTINUE_PULL_THRESHOLD: number = 90;
  // 图标下拉的最大距离
  public static readonly MENU_DOWN_Y_MAX_VALUE: number = 20;
  // 标题下拉的最大距离
  public static readonly TITLE_DOWN_Y_MAX_VALUE: number = 30;
  // 标题缩放的最大值
  public static readonly TITLE_SCALE_MAX_VALUE: number = 1.2;
  // 标题缩放的默认值
  public static readonly TITLE_SCALE_DEFAULT_VALUE: number = 1;
  // 设置笔记图片宽高比
  public static readonly ANIMATE_DURATION_DRAG: number = 120;
  // 设置笔记图片宽高比
  public static readonly ANIMATE_DURATION_BACK: number = 300;
  // 设置搜索框与各笔记布局间隔
  public static readonly SEARCH_MEMO_SPACE: number = 12;
  // 初始坐标位置
  public static readonly INIT_COORDINATE: number = 0;
  // 设置下拉时时的平移效果的距离
  public static readonly TRANSLATE_Y: number = -50;
  // 设置最大text组件显示行数
  public static readonly MAX_TEXT_LINES: number = 1;
  // 设置各笔记布局间隔
  public static readonly MEMO_COL_SPACE: number = 5;
  // 设置笔记图片宽高比
  public static readonly MEMO_IMAGE_ASPECT_RATIO: number = 1;
  // 标题常规高度
  public static readonly NORMAL_TITLE_HEIGHT: number = 80;
  // 标题扩展高度
  public static readonly EXPAND_TITLE_HEIGHT: number = 100;
  // 100%
  public static readonly ONE_HUNDRED_PERCENT: string = '100%';
  // 标题padding
  public static readonly TITLE_LAYOUT_PADDING: number = 25;
  // 标题内容
  public static readonly MEMO_TITLE: string = 'All notes';
  // 子标题内容
  public static readonly MEMO_SUB_TITLE: string = '8 notes';
  // 标题字体大小
  public static readonly TITLE_FONT_SIZE: number = 25;
  // 子标题字体大小
  public static readonly SUB_TITLE_FONT_SIZE: number = 16;
  // 标题背景色
  public static readonly BACKGROUND_COLOR: string = '0xeaf0ef';
  // 动效时长
  public static readonly ANIMATION_DURATION: number = 120;
}