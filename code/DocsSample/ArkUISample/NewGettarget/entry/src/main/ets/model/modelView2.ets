@ObservedV2
class Info {
  @Trace public name: string = "Tom";
  @Trace public age: number = 24;
}
let info: Info = new Info(); // NAPI接口传入info实例