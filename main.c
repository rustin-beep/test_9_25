#include <stdio.h>

#ifdef _WIN32
#include <windows.h>
#endif

int main(void)
{
#ifdef _WIN32
    /* 切换 Windows 控制台到 UTF-8，避免中文乱码；其他平台无需处理 */
    SetConsoleOutputCP(CP_UTF8);
#endif

    printf("Hello, C!  (CMake + MSVC)\n");
    printf("你好，世界！\n\n");

    for (int i = 1; i <= 5; ++i) {
        printf("  循环第 %d 次\n", i);
    }

    printf("\n运行结束。\n");
    return 0;
}
