# cfluxdo HarmonyOS

这是 Linux.do 第三方客户端 cfluxdo 的 HarmonyOS 工程。应用使用独立包名 `com.conheaven.cfluxdo`，图标来自上游 `assets/logo.svg`。四个入口各有独立的 ArkWeb 实例，共享同一站点的登录 Cookie：

| 入口 | 页面 |
| --- | --- |
| 首页 | `https://linux.do/` |
| 最新 | `https://linux.do/latest` |
| 通知 | `https://linux.do/my/notifications` |
| 我的 | `https://linux.do/my/activity` |

通知和个人页需要登录，未登录时由站点跳转至登录页。网页里的浏览、发帖和其他站内操作沿用 Linux.do 的交互。Flutter 上游的原生页面、ECH 节点优选和离线功能尚未移植，不能将当前版本称为完整等价客户端。

## 构建与签名

先将 `build-profile.example.json5` 复制为 `build-profile.json5`，再在 DevEco Studio 中打开本目录。首次安装到真机时，进入 `File > Project Structure > Project > Signing Configs`，为 `com.conheaven.cfluxdo` 自动生成 HarmonyOS 调试签名。`build-profile.json5` 含本机签名路径和密码，已被 `.gitignore` 排除。不要使用 HarmonyX 的旧 profile，它绑定另一个包名。

```sh
JAVA_HOME=/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home \
PATH=/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home/bin:$PATH \
DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk \
/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw assembleApp --no-daemon
```

签名完成后，`entry/build/default/outputs/default/entry-default-signed.hap` 可以通过 HDC 安装。未配置签名时只会生成未签名产物，不能直接安装到手机。

## 上游与许可证

上游：[1molchuan/fluxdo](https://github.com/1molchuan/fluxdo)，GPL-3.0。本工程是独立 HarmonyOS 移植，继续遵循 GPL-3.0。
