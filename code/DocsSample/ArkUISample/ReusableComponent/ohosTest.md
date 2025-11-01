| 测试功能                              | 预置条件     | 输入                   | 预期输出      | 测试结果 |
|-----------------------------------| ------------ | ---------------------- |-----------| -------- |
| 首页加载测试                            | 设备正常运行 | 验证基础元素渲染       | 页面加载成功,检查标题和列表组件显示正常  | Pass     |
| ComponentContent不支持传入\@Reusable装饰器装饰的自定义组件页面 | 设备正常运行 | 点击"ComponentContentNotSupportReusable"，点击"hello world" | 页面加载成功,点击"hello",页面闪退，与预期一致    | Pass     |
| 【反例】在子组件的aboutToReuse中，直接修改父组件的状态变量页面 | 设备正常运行 | 点击"ReusableIncorrectSample"，上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致    | Pass     |
| 【正例】在子组件的aboutToReuse中，使用setTimeout，将修改抛出组件复用的作用范围页面 | 设备正常运行 | 点击"ReusableCorrectSample"，上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致    | Pass     |
| \@Reusable不支持跟\@ComponentV2搭配使用页面 | 设备正常运行 | 点击"ReusableForCustomComponents"，点击"hello world" | 页面加载成功,点击"hello world"出现弹窗，与预期结果一致    | Pass     |
| 动态布局更新页面 | 设备正常运行 | 点击"DynamicLayoutUpdate"，点击"hello" | 页面加载成功，点击hello,出现弹框，再点击弹框消失，与预期结果一致    | Pass     |
| 列表滚动配合LazyForEach使用页面 | 设备正常运行 | 点击"ListScrollingWithLazyForEach"，上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致    | Pass     |
| 列表滚动-if使用场景页面 | 设备正常运行 | 点击"ListScrollingWithIfStatements",上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致    | Pass     |
| 列表滚动-Foreach使用场景页面 | 设备正常运行 | 点击"ListScrollingWithForEach"，上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致   | Pass     |
| Grid使用场景页面 | 设备正常运行 | 点击"ReusableForGridUsageScenario"，上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致     | Pass     |
| WaterFlow使用场景页面 | 设备正常运行 | 点击"ReusableForWaterFlowUsageScenario"，上下滑动，点击"back top" | 页面加载成功,上下滑动页面正常显示，无卡顿，点击"back top",返回到顶部，与预期结果一致    | Pass     |
| Swiper使用场景页面 | 设备正常运行 | 点击"ReusableForSwiperUsageScenario"，左右滑动 | 页面加载成功，左右滑动页面正常显示，无卡顿，与预期结果一致    | Pass     |
| 列表滚动-ListItemGroup使用场景页面 | 设备正常运行 | 点击"ReusableForListItemGroupUsageScenario"，上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致    | Pass     |
| 复用组件间存在差异，但类型有限页面 | 设备正常运行 | 点击"ReusableForLimitedVariation"，上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致    | Pass     |
| 复用组件间存在多种差异，但通常具备共同的子组件页面 | 设备正常运行 | 点击"ReusableForComposite"，上下滑动 | 页面加载成功，上下滑动页面正常显示，无卡顿，与预期结果一致    | Pass     |





