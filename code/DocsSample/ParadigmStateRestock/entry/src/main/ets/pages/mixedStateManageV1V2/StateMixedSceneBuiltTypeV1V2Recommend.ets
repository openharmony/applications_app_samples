// [Start state_mixed_scene_built_type_v1_v2_recommend]
import { UIUtils } from '@kit.ArkUI';

@Entry
@Component
struct ArrayCompV1 {
  @State arr: Array<number> = UIUtils.makeV1Observed([1, 2, 3]);

  build() {
    Column() {
      Text(`V1 ${this.arr[0]}`).onClick(() => {
        // 点击触发ArrayCompV1和ArrayCompV2变化
        this.arr[0]++;
      })
      // 传递给V2时，发现当前代理是makeV1Observed包装的，且使能V2观察能力
      // 在ArrayCompV2中Param不会再次包装代理，避免双重代理的问题
      ArrayCompV2({ arr: UIUtils.enableV2Compatibility(this.arr) })
    }
    .height('100%')
    .width('100%')
  }
}

@ComponentV2
struct ArrayCompV2 {
  @Param arr: Array<number> = [1, 2, 3];

  build() {
    Column() {
      Text(`V2 ${this.arr[0]}`).onClick(() => {
        // 点击触发ArrayCompV1和ArrayCompV2变化
        this.arr[0]++;
      })
    }
  }
}
// [End state_mixed_scene_built_type_v1_v2_recommend]
@Component
export struct StateMixedSceneBuiltTypeV1V2Recommend {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      ArrayCompV1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_built_type_v1_v2_recommend'))
  }
}