# 画中画 测试用例归档

## 用例表

| 测试功能                               | 预置条件                              | 输入                   | 预期输出      | 是否自动 | 测试结果 |
|------------------------------------|-----------------------------------|----------------------|-----------|------| -------- |
| 拉起应用                               | 设备正常运行                            |                      | 成功拉起应用    | 是    | Pass     |
| 用XComponent方式创建画中画                 | 进入XComponent实现的详情页面               | 点击【StartPip】         | 创建画中画     | 是    | Pass     |
| 改变用XComponent方式创建的画中画尺寸            | 用XComponent实现方式创建了画中画             | 点击【updateSize】       | 改变画中画尺寸大小 | 是    | Pass     |
| 删除用XComponent方式创建的画中画              | 用XComponent实现方式创建了画中画             | 点击【stopPip】          | 关闭画中画     | 是    | Pass     |
| 用typeNode自由节点创建画中画                 | 进入typeNode自由节点实现的详情页面             | 点击【StartPip】         | 创建画中画     | 是    | Pass     |
| 改变typeNode自由节点创建的画中画尺寸             | 用typeNode自由节点实现方式创建了画中画           | 点击【updateSize】       | 改变画中画尺寸大小 | 是    | Pass     |
| 删除typeNode自由节点创建的画中画               | 用typeNode自由节点实现方式创建了画中画           | 点击【stopPip】          | 关闭画中画     | 是    | Pass     |
| 用router导航时通过typeNode创建画中画          | 进入用router导航时通过typeNode实现的详情页面     | 点击【StartPip】         | 创建画中画     | 是    | Pass     |
| 改变用router导航时通过typeNode创建的画中画尺寸     | 用router导航时通过typeNode实现方式创建了画中画    | 点击【updateSize】       | 改变画中画尺寸大小 | 是    | Pass     |
| 删除用router导航时通过typeNode创建的画中画       | 用router导航时通过typeNode实现方式创建了画中画    | 点击【stopPip】          | 关闭画中画     | 是    | Pass     |
| 使用navigation导航时通过typeNode创建画中画     | 进入用navigation导航时通过typeNode实现的详情页面 | 点击【StartPip】         | 创建画中画     | 是    | Pass     |
| 改变用navigation导航时通过typeNode创建的画中画尺寸 | 用navigation导航时通过typeNode实现方式创建了画中画 | 点击【updateSize】       | 改变画中画尺寸大小 | 是    | Pass     |
| 删除用navigation导航时通过typeNode创建的画中画   | 用navigation导航时通过typeNode实现方式创建了画中画 | 点击【stopPip】          | 关闭画中画     | 是    | Pass     |
| 使用单页面ability通过typeNode创建画中画        | 进入使用单页面ability通过typeNode实现的详情页面   | 点击【StartPip】         | 创建画中画     | 是    | Pass     |
| 使用单页面ability调整通过typeNode创建的画中画尺寸   | 使用单页面ability通过typeNode实现方式创建了画中画  | 点击【updateSize】       | 改变画中画尺寸大小 | 是    | Pass     |
| 使用单页面ability删除通过typeNode创建的画中画     | 使用单页面ability通过typeNode实现方式创建了画中画  | 点击【stopPip】          | 关闭画中画     | 是    | Pass     |
| 使用NDK接口创建画中画                       | 进入使用NDK接口实现的详情页面                  | 点击【创建画中画】，再点击【开启画中画】 | 创建画中画     | 是    | Pass     |
| 删除用NDK接口创建的画中画                     | 通过NDK接口实现创建了画中画                   | 点击【关闭画中画】            | 关闭画中画     | 是    | Pass     |
