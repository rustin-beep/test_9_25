cmake_minimum_required(VERSION 3.15)

project(hello_c C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# 编译选项：add_compile_options 只影响在其之后创建的目标，必须放在 add_executable 之前
if(MSVC)
    # /utf-8: 源码与执行字符集统一为 UTF-8（跨机器不乱码）；/W4: 高等级警告
    add_compile_options(/utf-8 /W4)
else()
    add_compile_options(-Wall -Wextra)
endif()

add_executable(app main.c)

# 固定输出到 build/bin/：无论用 Visual Studio 生成器还是 Ninja、无论 Debug/Release，
# 可执行文件永远是 build/bin/app.exe，这样 .vscode 里的运行/调试配置不用改。
set_target_properties(app PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY                "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_BINARY_DIR}/bin"
)
