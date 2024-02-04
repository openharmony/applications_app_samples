/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

export class RouterModule {
  // 用于存储自定义builder函数
  static builderMap: Map<string, WrappedBuilder<[Object]>> = new Map<string, WrappedBuilder<[Object]>>();
  // 用于存储页面栈信息
  static routerMap: Map<string, NavPathStack> = new Map<string, NavPathStack>();

  public static registerBuilder(builderName: string, builder: WrappedBuilder<[Object]>): void {
    RouterModule.builderMap.set(builderName, builder);
  }

  public static getBuilder(builderName: string): WrappedBuilder<[Object]> {
    let builder = RouterModule.builderMap.get(builderName);
    return builder as WrappedBuilder<[Object]>;
  }

  public static registRouter(routerName: string, router: NavPathStack) {
    RouterModule.routerMap.set(routerName, router);
  }

  public static getRouter(routerName: string) {
    return RouterModule.routerMap.get(routerName);
  }

  public static push(routerName: string, pageName: string) {
    (RouterModule.getRouter(routerName) as NavPathStack).pushPathByName(pageName, null);
  }
}