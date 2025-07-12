| 测试功能              | 预置条件 | 输入         | 预期输出                                              |是否自动|测试结果|
|-------------------|------|------------|---------------------------------------------------|--------------------------------|--------------------------------|
| 拉起应用              | 	设备正常运行 | 		         | 成功拉起应用                          |是|Pass|
| Sendable共享模块能力测试  | 执行用例 | 执行无需输入     | SendableModuleTest Succeed    |是|Pass|
| 同步任务能力测试          | 执行用例 | 执行无需输入 | syncTaskTest Succeed     |是|Pass|
| CPU密集型任务能力测试      | 执行用例 | 执行无需输入 | imagePreprocessing success    |是|Pass|
| IO密集型任务能力测试       | 执行用例 | 	执行无需输入     | IoTaskTest Succeed  |是|Pass|
| 单步IO任务能力测试        | 执行用例 | 	执行无需输入      | SingleIoTest Succeed  |是|Pass|
| 异步任务能力测试          | 执行用例 | 执行无需输入       | AsyncConcurrencyTest Succeed |是|Pass|