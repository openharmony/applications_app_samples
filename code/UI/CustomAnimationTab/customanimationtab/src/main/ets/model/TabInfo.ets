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
import { TabBarItemInterface } from './TabBarItemInterface';

/**
 * 构建一个Tab项所需要的信息
 *
 */
export class TabInfo {
  // tab项标题(页签内容)
  public title: string;
  // tab项内容
  public contentBuilder: WrappedBuilder<[ESObject]>;
  // tabBar(页签样式)
  public barBuilder?: WrappedBuilder<[TabBarItemInterface]>;
  // tabBarIndex
  public params?: ESObject;

  /**
   * TabInfo构造器
   * @param title - tab项标题
   * @param contentBuilder - tab项内容
   * @param barBuilder - tabBar
   */
  constructor(title: string, contentBuilder: WrappedBuilder<[ESObject]>,
    barBuilder?: WrappedBuilder<[TabBarItemInterface]>, params?: ESObject) {
    this.title = title;
    this.contentBuilder = contentBuilder;
    this.barBuilder = barBuilder;
    this.params = params;
  }
}