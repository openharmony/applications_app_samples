# 页面加载效果实现案例测试用例

## 用例表

| 测试功能         | 预置条件                      | 输入            | 预期输出                                                | 是否自动 | 测试结果 |
|--------------|---------------------------|---------------|-----------------------------------------------------|------|------|
| 快速滑动，背景条自动左右滑动  | 	启动应用 | 	快速滑动tab页	 | 背景条自动左右滑动 | 否    | Pass |
| 滑动距离不足一半，背景条自动回弹       | 	启动应用                 | 	左右滑动距离不足单个页签一半        | 背景条自动回弹到当前页签                                          | 否    | Pass |
| 滑动距离超过一半，背景条自动滑动至下一页签       | 	启动应用                 | 	滑动距离超过页签一半        | 背景条进入下一页签                                          | 否    | Pass |
| 点击页签，背景条跳转至对应页签       | 	启动应用                 | 	点击相应页签         | 背景条跳转至对应页签                                        | 否    | Pass |