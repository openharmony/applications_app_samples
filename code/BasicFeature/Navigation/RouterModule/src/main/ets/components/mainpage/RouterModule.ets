export class RouterModule {
  static builder_map: Map<string, WarppedBuider<[object]>> = new Map<string, WarppedBuider<[object]>>()
  static router_map: Map<string, NavPathStack> = new Map<string, NavPathStack>()

  //通过名称注册builder
  public static registerBuilder(name: string, builder: WarppedBuider<[object]>): void{
    RouterModule.builder_map.set(name, builder)
  }

  //通过名称获取builder
  public static getBuilder(name: string): WarppedBuider<[object]>{
    let builder = RouterModule.builder_map.get(name)
    if(!builder){
      console.info("未获取到builder" + name)
    }
    return builder as WarppedBuider<[object]>
  }

  //通过名称注册router
  public static createRouter(name: string, router: NavPathStack): void{
    RouterModule.router_map.set(name, router)
  }

  //通过名称获取router
  public static getRouter(name: string): NavPathStack{
    let router = RouterModule.router_map.get(name)
    if(!router){
      console.info("未获取到router" + name)
    }
    return router as NavPathStack
  }

  //通过获取页面栈跳转到指定页面
  public static push(url:string): void{
    //分解url
    let params = url.split("-")
    const path = params[0]
    const router_name = params[1]
    const name = params[2]

    //动态引入要跳转的页面
    //由于暂不支持import(变量)，这里要将所有需要的页面都写一遍
    switch (path){
      case "harA/src/main/ets/components/mainpage/HarA":
        import("harA/src/main/ets/components/mainpage/HarA")
        break
      case "harB/src/main/ets/components/mainpage/HarB":
        import("harB/src/main/ets/components/mainpage/HarB")
        break
    }
    // 查找到对应的路由栈进行跳转
    RouterModule.getBuilder(router_name).pushPathByName(name, null)
  }

  //通过获取页面栈并pop
  public static pop(router_name:string): void {
    // 查找到对应的路由栈进行pop
    RouterModule.getRouter(router_name).pop()
  }

  // 通过获取页面栈并将其清空
  public static clear(router_name:string): void {
    // 查找到对应的路由栈进行pop
    RouterModule.getRouter(router_name).clear()
  }
}
