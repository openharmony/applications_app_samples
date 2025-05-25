
import { AnimateToTest } from './AnimateTo.test';
import { AnimationTest } from './Animation.test';
import { CohesionTest } from './Cohesion.test';
import { KeyFrameAnimateToTest } from './KeyFrameAnimateTo.test';
import { PageTransitionTest } from './PageTransition.test';
import { ComponentTransitionTest } from './ComponentTransition.test';
import { ShareTransitionTest } from './ShareTransition.test';
import { MotionPathTest } from './MotionPath.test';
import { ParticleTest } from './Particle.test';
import { AnimatorTest } from './Animator.test';
import { AnimateToImmediatelyTest } from './AnimateToImmediately.test';
import { RotationTest } from './Rotation.test';

export default function testsuite() {
  AnimateToTest();
  AnimationTest();
  CohesionTest();
  KeyFrameAnimateToTest();
  PageTransitionTest();
  ComponentTransitionTest();
  ShareTransitionTest();
  MotionPathTest();
  ParticleTest();
  AnimatorTest();
  AnimateToImmediatelyTest();
  RotationTest();
}