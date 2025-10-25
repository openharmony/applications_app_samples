// [Start state_manage_mixed_paradigm_v1_to_v2]
import { UIUtils } from '@kit.ArkUI';

@Observed
class ObservedClass {
}

@Entry
@Component
struct CompV1 {
  @State observedClass: ObservedClass = new ObservedClass();

  build() {
    Column() {
      CompV2({ observedClass: UIUtils.enableV2Compatibility(this.observedClass) })
    }
  }
}

@ComponentV2
struct CompV2 {
  @Param observedClass: ObservedClass = new ObservedClass();

  build() {
  }
}
// [End state_manage_mixed_paradigm_v1_to_v2]