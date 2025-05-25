
import { TransformTest } from './Transform.test';
import { OpacityTest } from './Opacity.test';
import { ClipTest } from './Clip.test';
import { ImageEffectTest } from './ImageEffect.test';
import { BackgroundTest } from './Background.test';
import { ForegroundBlurStyleTest } from './ForegroundBlurStyle.test';
import { ForegroundColorTest } from './ForegroundColor.test';
import { ClickEffectTest } from './ClickEffect.test';
import { UseEffectTest } from './UseEffect.test';
import { OutLineTest } from './OutLine.test';
import { RenderFitTest } from './RenderFit.test';
import { MotionBlurTest } from './MotionBlur.test';
import { LinearGradientTest } from './LinearGradient.test';
import { ForegroundEffectTest } from './ForegroundEffect.test';
import { VisualEffectTest } from './VisualEffect.test'


export default function testsuite() {
  TransformTest();
  OpacityTest();
  ClipTest();
  ImageEffectTest();
  BackgroundTest();
  ForegroundBlurStyleTest();
  ForegroundColorTest();
  ClickEffectTest();
  UseEffectTest();
  RenderFitTest();
  OutLineTest();
  MotionBlurTest();
  LinearGradientTest();
  ForegroundEffectTest();
  VisualEffectTest();
}