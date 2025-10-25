// [Start state_mixed_scene_built_type_v2_v1_recommend]
import { UIUtils } from '@kit.ArkUI';

@Entry
@ComponentV2
struct ArrayCompV2 {
  @Local arr: Array<number> = UIUtils.enableV2Compatibility(UIUtils.makeV1Observed([1, 2, 3]));

  build() {
    Column() {
      Text(`V2 ${this.arr[0]}`).fontSize(20).onClick(() => {
        // 点击触发V2变化，且同步给V1 @ObjectLink
        this.arr[0]++;
      })
      ArrayCompV1({ arr: this.arr })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct ArrayCompV1 {
  @ObjectLink arr: Array<number>;

  build() {
    Column() {
      Text(`V1 ${this.arr[0]}`).fontSize(20).onClick(() => {
        // 点击触发V1变化，且双向同步回给V2
        this.arr[0]++;
      })
    }
  }
}
// [End state_mixed_scene_built_type_v2_v1_recommend]
@Component
export struct StateMixedSceneBuiltTypeV2V1Recommend {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      ArrayCompV2()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_built_type_v2_v1_recommend'))
  }
}