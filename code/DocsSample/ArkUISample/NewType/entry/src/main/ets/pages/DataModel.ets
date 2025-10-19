import { Type } from '@kit.ArkUI';
// [Start DataModel]
class Sample {
  data: number = 0;
}
@ObservedV2
class Info {
  @Type(Sample)
  @Trace sample: Sample = new Sample(); // 正确用法
}
// [End DataModel]