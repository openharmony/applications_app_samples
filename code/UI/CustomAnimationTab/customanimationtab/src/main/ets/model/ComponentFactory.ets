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
import { TabInfo } from './TabInfo';

/**
 * 组件工厂，可以注册TabInfo对象并使用
 *
 */
export class ComponentFactory {

  // tabInfo对象集合
  private tabsInfo: Map<string, TabInfo>;
  // 注册标题集合
  private keys: string[] = [];

  /**
   * 构造器
   */
  public constructor() {
    this.tabsInfo = new Map();
  }

  /**
   * 设置tab项内容
   * @param name - tab项标题
   * @param content - tab项内容
   */
  public set(name: string, tabInfo: TabInfo) {
    this.tabsInfo.set(name, tabInfo);
  }

  /**
   * 获取tab项内容
   * @param name - tab项标题
   * @returns: tab项内容
   */
  public getContent(name: string): WrappedBuilder<[ESObject]> | undefined {
    return this.tabsInfo.get(name)?.contentBuilder;
  }

  /**
   * 获取tabBar
   * @param name - tab项标题
   * @returns: tabBar
   */
  public getBar(name: string): WrappedBuilder<[TabBarItemInterface]> | undefined {
    return this.tabsInfo.get(name)?.barBuilder;
  }

  /**
   * 获取输入参数
   * @param name - tab项标题
   * @returns: 输入参数
   */
  public getParams(name: string): ESObject {
    return this.tabsInfo.get(name)?.params;
  }

  /**
   * 删除tab项
   * @param name - tab项标题
   */
  public delete(name: string) {
    this.keys = [];
    this.tabsInfo.delete(name);
  }

  /**
   * 获取注册标题集合
   * @returns: 包含所有注册标题的数组
   */
  public toArray(): string[] {
    if (this.keys.length > 0) {
      return this.keys;
    }
    let array: string[] = [];
    let keys: IterableIterator<string> = this.tabsInfo.keys()
    for (let keysElement of keys) {
      array.push(keysElement);
    }
    return array;
  }
}