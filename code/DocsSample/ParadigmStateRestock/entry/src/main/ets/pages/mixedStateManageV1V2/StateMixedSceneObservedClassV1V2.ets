// [Start state_mixed_scene_observed_class_v1_v2]
import { UIUtils } from '@kit.ArkUI';

@Observed
class ObservedClass {
  @Track name: string = 'a';
  count: number = 0;
}

@Entry
@Component
struct CompV1 {
  @State observedClass: ObservedClass = new ObservedClass();

  build() {
    Column() {
      Text(`name: ${this.observedClass.name}`).onClick(() => {
        // 触发刷新
        this.observedClass.name += 'a';
      })
      // 使用非@Track的变量在V1中会崩溃
      // Text(`count: ${this.observedClass.count}`)

      CompV2({ observedClass: UIUtils.enableV2Compatibility(this.observedClass) })
    }
  }
}

@ComponentV2
struct CompV2 {
  @Param observedClass: ObservedClass = new ObservedClass();

  build() {
    // 使用非@Track的变量在V2中不会崩溃，但不会响应更新
    Text(`count: ${this.observedClass.count}`).onClick(() => {
      // 不触发刷新
      this.observedClass.count++;
    })
  }
}
// [End state_mixed_scene_observed_class_v1_v2]
@Component
export struct StateMixedSceneObservedClassV1V2 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      CompV1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_observed_class_v1_v2'))
  }
}