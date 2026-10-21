# daqing/parse-version

一个很小的 MoonBit 库，用于从 MoonBit 清单文件（`moon.mod`）中读取 `version` 字段。

## 安装

```bash
moon add daqing/parse-version
```

然后在你的 `moon.pkg` 中添加依赖：

```moonbit nocheck
///|
import {
  "daqing/parse-version",
}
```

## 用法

### 从 `moon.mod` 读取版本号

```moonbit nocheck
///|
fn main {
  let version = @parse-version.Version::parse("moon.mod")
  println(version) // 例如 "0.1.0"
}
```

`Version::parse` 接收一个路径，读取文件并返回其中第一行 `version` 的值。

### 处理版本号缺失

如果清单里没有 `version` 字段，`Version::parse` 会抛出 `VersionError::VersionNotFound`，并携带被读取的路径：

```moonbit nocheck
///|
fn read_version(path : String) -> String {
  @parse-version.Version::parse(path) catch {
    @parse-version.VersionNotFound(path) =>
      "unknown (\{path} has no version field)"
  }
}
```

## 解析规则

- 跳过空行和以 `//` 开头的行。
- 键和值之间可以有任意空白：`version="1.2.3"` 和 `version = "1.2.3"` 都能解析。
- 值必须是带引号的字符串；右引号之后的内容会被忽略，因此行尾注释没有问题。
- 以第一处匹配为准。
- 并非完整的 TOML 解析器，因此嵌套在其他表中的 `version` 行也会被读到。

## API

```moonbit
pub struct Version {}

pub suberror VersionError {
  VersionNotFound(String)
}

pub fn Version::parse(path : String) -> String raise
```

- `Version::parse(path)` 返回版本号字符串，或抛出 `VersionNotFound(path)`。
- `VersionError` 是 sub-error，可以自由地在自己的错误类型中捕获和重新抛出。

## 开发

```bash
moon test          # 运行测试
moon info && moon fmt
```

## 许可证

Apache-2.0
