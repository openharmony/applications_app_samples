// [Start state_mixed_scene_js_v1_v2_not_recommend]
@Observed
class ObservedClass {
  name: string = 'Tom';
}

@Entry
@Component
struct CompV1 {
  @State observedClass: ObservedClass = new ObservedClass();

  build() {
    Column() {
      Text(`@State observedClass: ${this.observedClass.name}`)
        .onClick(() => {
          this.observedClass.name += '!'; // 刷新
        })
      // 未调用enableV2Compatibility接口，V1的状态变量在CompV2中无观察能力
      // 在CompV2不可观察name的变化
      CompV2({ observedClass: this.observedClass })
    }
  }
}

@ComponentV2
struct CompV2 {
  @Param observedClass: ObservedClass = new ObservedClass();

  build() {
    Text(`@Param observedClass: ${this.observedClass.name}`)
      .onClick(() => {
        this.observedClass.name += '!'; // 不刷新
      })
  }
}
// [End state_mixed_scene_js_v1_v2_not_recommend]
@Component
export struct StateMixedSceneJsV1V2NotRecommend {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      CompV1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_js_v1_v2_not_recommend'))
  }
}