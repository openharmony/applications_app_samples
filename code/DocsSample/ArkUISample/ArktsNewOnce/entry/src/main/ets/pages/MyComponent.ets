// [Start once_init_sync_noMore]
@ComponentV2
struct ChildComponent {
  @Param @Once onceParam: string = '';

  build() {
    Column() {
      Text(`onceParam: ${this.onceParam}`)
    }
  }
}

@Entry
// [Start once_param_componentV2_pair]
// [Start once_param_order_irrelevant]
@ComponentV2
struct MyComponent {
  // [StartExclude once_init_sync_noMore]
  // [StartExclude once_param_order_irrelevant]
  @Param @Once onceParam: string = 'onceParam'; // 正确用法
  // [EndExclide once_param_order_irrelevant]
  // [StartExclude once_param_componentV2_pair]
  @Param @Once param1: number = 0;
  @Once @Param param2: number = 0;
  // [StartExclude once_param_order_irrelevant]
  // [EndExclide once_init_sync_noMore]
  @Local message: string = 'Hello World';

  build() {
    Column() {
      Text(`Parent message: ${this.message}`)
      Button('change message')
        .onClick(() => {
          this.message = 'Hello Tomorrow';
        })
      ChildComponent({ onceParam: this.message })
    }
  }
  // [EndExclide once_param_componentV2_pair]
  // [EndExclide once_param_order_irrelevant]
}
//[End once_param_componentV2_pair]
// [End once_param_order_irrelevant]
// [End once_init_sync_noMore]