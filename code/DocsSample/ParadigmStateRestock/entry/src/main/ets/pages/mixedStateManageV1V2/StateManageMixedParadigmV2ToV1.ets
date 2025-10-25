// [Start state_manage_mixed_paradigm_v2_to_v1]
import { UIUtils } from '@kit.ArkUI';

@Observed
class ObservedClass {
}

@Entry
@ComponentV2
struct CompV2 {
  @Local observedClass: ObservedClass = UIUtils.enableV2Compatibility(new ObservedClass());

  build() {
    Column() {
      CompV1({ observedClass: this.observedClass })
    }
  }
}

@Component
struct CompV1 {
  @ObjectLink observedClass: ObservedClass;

  build() {
  }
}
// [End state_manage_mixed_paradigm_v2_to_v1]