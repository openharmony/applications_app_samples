/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
export class RouterModule {
  static builderMap: Map<string, WrappedBuilder<[object]>> = new Map<string, WrappedBuilder<[object]>>();
  static routerMap: Map<string, NavPathStack> = new Map<string, NavPathStack>();

  // 通过名称注册builder
  public static registerBuilder(builderName: string, builder: WrappedBuilder<[object]>): void{
    RouterModule.builderMap.set(builderName, builder);
  }

  // 通过名称获取builder
  public static getBuilder(builderName: string): WrappedBuilder<[object]>{
    let builder = RouterModule.builderMap.get(builderName);
    return builder as WrappedBuilder<[object]>;
  }

  // 通过名称注册router
  public static createRouter(routerName: string, router: NavPathStack): void{
    RouterModule.routerMap.set(routerName, router);
  }

  // 通过名称获取router
  public static getRouter(routerName: string): NavPathStack{
    let router = RouterModule.routerMap.get(routerName);
    return router as NavPathStack;
  }

  // 通过获取页面栈跳转到指定页面
  public static async push(url: string): Promise<void>{
    // 分解url
    // 获取包名、路由名、页面名
    let params = url.split("/");
    const harName = params[0];
    let context = params[params.length - 1].split("-");
    const routerName = context[0];
    const builderName = context[1];
    // 获取路径
    let path = ".";
    for (let i = 1; i < params.length - 1; i++) {
      path += "/" + params[i];
    }
    // 动态引入要跳转的页面
    let ns: ESObject = await import(harName);
    ns.harInit(path);
    RouterModule.getRouter(routerName).pushPathByName(builderName, null);
  }

  // 通过获取页面栈并pop
  public static pop(routerName: string): void {
    // 查找到对应的路由栈进行pop
    RouterModule.getRouter(routerName).pop();
  }

  // 通过获取页面栈并将其清空
  public static clear(routerName: string): void {
    // 查找到对应的路由栈进行pop
    RouterModule.getRouter(routerName).clear();
  }
}
