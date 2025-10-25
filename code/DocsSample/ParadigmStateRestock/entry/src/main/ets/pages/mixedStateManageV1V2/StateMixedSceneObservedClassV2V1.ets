// [Start state_mixed_scene_observed_class_v2_v1]
import { UIUtils } from '@kit.ArkUI';

@Observed
class ObservedClass {
  @Track name: string = 'a';
  count: number = 0;
}

@Entry
@ComponentV2
struct CompV1 {
  @Local observedClass: ObservedClass = UIUtils.enableV2Compatibility(new ObservedClass());

  build() {
    Column() {
      Text(`name: ${this.observedClass.name}`).onClick(() => {
        // 触发刷新
        this.observedClass.name += 'a';
      })
      // 使用非@Track的变量在V2中不会崩溃，但不响应更新
      Text(`count: ${this.observedClass.count}`).onClick(() => {
        this.observedClass.count++;
      })

      CompV2({ observedClass: this.observedClass })
    }
  }
}

@Component
struct CompV2 {
  @ObjectLink observedClass: ObservedClass;

  build() {
    Column() {
      Text(`count: ${this.observedClass.name}`).onClick(() => {
        // 触发刷新
        this.observedClass.name += 'a';
      })
      // 使用非@Track的变量在V1中会崩溃
      // Text(`count: ${this.observedClass.count}`)
    }
  }
}
// [End state_mixed_scene_observed_class_v2_v1]
@Component
export struct StateMixedSceneObservedClassV2V1 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      CompV1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_observed_class_v2_v1'))
  }
}