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
  static builderMap: Map<string, WarppedBuilder<[object]>> = new Map<string, WarppedBuilder<[object]>>()
  static routerMap: Map<string, NavPathStack> = new Map<string, NavPathStack>()

  // 通过名称注册builder
  public static registerBuilder(builderName: string, builder: WarppedBuilder<[object]>): void{
    RouterModule.builderMap.set(builderName, builder)
  }

  // 通过名称获取builder
  public static getBuilder(builderName: string): WarppedBuilder<[object]>{
    let builder = RouterModule.builderMap.get(builderName)
    if(!builder){
      console.info("未获取到builder" + builderName)
    }
    return builder as WarppedBuilder<[object]>
  }

  // 通过名称注册router
  public static createRouter(routerName: string, router: NavPathStack): void{
    RouterModule.routerMap.set(routerName, router)
  }

  // 通过名称获取router
  public static getRouter(routerName: string): NavPathStack{
    let router = RouterModule.routerMap.get(routerName)
    if(!router){
      console.info("未获取到router" + routerName)
    }
    return router as NavPathStack
  }

  // 通过获取页面栈跳转到指定页面
  public static push(url:string): void{
    // 分解url
    let params = url.split("-")
    const path = params[0]
    const routerName = params[1]
    const pageName = params[2]

    // 动态引入要跳转的页面
    switch (path){
      case "harA/src/main/ets/components/mainpage/HarA":
        import("harA/src/main/ets/components/mainpage/HarA")
        break
      case "harB/src/main/ets/components/mainpage/HarB":
        import("harB/src/main/ets/components/mainpage/HarB")
        break
    }
    // 查找到对应的路由栈进行跳转
    RouterModule.getBuilder(routerName).pushPathByName(pageName, null)
  }

  // 通过获取页面栈并pop
  public static pop(routerName:string): void {
    // 查找到对应的路由栈进行pop
    RouterModule.getRouter(routerName).pop()
  }

  // 通过获取页面栈并将其清空
  public static clear(routerName:string): void {
    // 查找到对应的路由栈进行pop
    RouterModule.getRouter(routerName).clear()
  }
}
