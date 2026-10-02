cmake_minimum_required(VERSION 3.13)
project(catenaNoleggiDvd)

set(CMAKE_C_STANDARD 11)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
find_package(MySQL REQUIRED)

add_executable(catenaNoleggi
        main.c
        controller/login.c
        model/db.c
        utils/db.c
        utils/dotenv.c
        utils/io.c
        utils/validation.c
        view/login.c
        controller/impiegato.c
        controller/impiegato.h
        view/Impiegato.c
        view/Impiegato.h
        controller/manager.c
        controller/manager.h
        view/manager.c
        view/manager.h)

include_directories(/usr/include/mariadb)
target_link_libraries(catenaNoleggi -L/usr/lib/x86_64-linux-gnu/ -lmariadb)

if(MSVC)
    add_compile_options(PRIVATE /W4 /WX)
else()
    add_compile_options(PRIVATE -Wall -Wextra -Wpedantic -Werror)
endif()
