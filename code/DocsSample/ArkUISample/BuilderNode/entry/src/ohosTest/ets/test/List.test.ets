import ArkWebPageTest from './ArkWebPage.test';
import BuilderProxyNode01Test from './BuilderProxyNode01.test';
import BuilderProxyNode02Test from './BuilderProxyNode02.test';
import EnvironmentCallbackPageTest from './EnvironmentCallbackPage.test';
import FrameNodeTest from './FrameNode.test';
import inheritFreezeTest from './InheritFreezeOptionsPage.test';
import isDisposedPageTest from './IsDisposedPage.test';
import LocalStoragePageTest from './LocalStoragePage.test';
import postTouchEventTest from './PostTouchEvent.test';
import RenderNodeTest from './RenderNode.test';
import ReusablePage01Test from './ReusablePage01.test';
import ReusablePage02Test from './ReusablePage02.test';
import routerPageTest from './RouterPage.test';
import WrappedBuilderTest from './WrappedBuilder.test';

export default function testsuite() {
  FrameNodeTest();
  RenderNodeTest();
  WrappedBuilderTest();
  postTouchEventTest();
  BuilderProxyNode01Test();
  BuilderProxyNode02Test();
  ReusablePage01Test();
  ReusablePage02Test();
  EnvironmentCallbackPageTest();
  routerPageTest();
  LocalStoragePageTest();
  isDisposedPageTest();
  inheritFreezeTest();
  ArkWebPageTest();
}