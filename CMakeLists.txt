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

# 自动收集本目录下所有 .c 源文件：新增源文件直接丢进目录即可，无需修改本文件。
# CONFIGURE_DEPENDS 让 CMake 在每次构建时检查目录变化，自动重新生成构建系统。
file(GLOB SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.c")

add_executable(app ${SOURCES})

# 固定输出到 build/bin/：无论用 Visual Studio 生成器还是 Ninja、无论 Debug/Release，
# 可执行文件永远是 build/bin/app.exe，这样 .vscode 里的运行/调试配置不用改。
set_target_properties(app PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY                "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_BINARY_DIR}/bin"
)
