# C 项目模板（CMake + MSVC，点击三角即可运行）

## 目录结构

```
test_9_25/
├── main.c               # 源代码
├── CMakeLists.txt       # CMake 构建配置（无任何第三方库）
├── scripts/
│   └── build.bat        # 一键构建脚本（自动探测 Visual Studio）
└── .vscode/
    ├── tasks.json       # 构建任务（build / run / build Release）
    ├── launch.json      # 调试配置（右上角三角按钮使用）
    └── settings.json
```

## 如何运行

1. 用 VS Code 打开本文件夹（`文件 → 打开文件夹`）。
2. 直接点击**右上角的三角运行按钮**（或按 `F5`）。
   → 自动完成：CMake 配置 → MSVC 编译 → 在终端运行/调试。
3. 只想编译并运行、不进调试器：`终端 → 运行任务 → run`。

生成的可执行文件固定在 `build/bin/app.exe`。

## 为什么能“跨机不依赖环境”

- `scripts/build.bat` 通过 `vswhere` **自动探测最新安装的 Visual Studio**（VS2019/2022/2026 都能找到），
  不硬编码任何安装路径或版本号。
- 优先使用 **VS 自带的 CMake**，生成器与编译器版本永远匹配；没装独立 CMake 也能构建。
- 使用 CMake 默认的 Visual Studio 生成器，不需要手动运行 `vcvarsall.bat` 配置环境变量。
- 源码统一按 UTF-8 编译（`/utf-8`），中文注释和输出在任何语言的 Windows 上都不会乱码。

换一台机器只需要：安装 Visual Studio（勾选 **“使用 C++ 的桌面开发”** 工作负载）+ VS Code，克隆下来点三角即可。

## 环境要求

- Windows + Visual Studio（含 C++ 工作负载；本机为 VS 2026）
- VS Code 建议 **安装 “C/C++” 扩展（ms-vscode.cpptools）**，三角按钮的运行/调试才可用；
  不装扩展也可以用 `终端 → 运行任务` 完成编译和运行。
- 非全新机器常见坑：如果从未打开过 VS，首次构建稍慢（CMake 需要定位组件），属正常现象。

## 常用操作

| 想做的事 | 操作 |
|---|---|
| 编译 + 调试 | 点右上角三角 / F5 |
| 只编译运行 | 终端 → 运行任务 → `run` |
| Release 编译 | 终端 → 运行任务 → `build (Release)` |
| 命令行构建 | `scripts\build.bat release run` |

## 添加新源文件

编辑 `CMakeLists.txt`，例如：

```cmake
add_executable(app main.c utils.c)
```

或添加头文件目录：

```cmake
target_include_directories(app PRIVATE include)
```
