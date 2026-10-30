cmake_minimum_required(VERSION 3.16)

project(TriangulEye VERSION 0.1 LANGUAGES CXX)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build." FORCE)
endif()

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Svg)

qt_standard_project_setup(REQUIRES 6.10)

if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

set(APP_ICON_RESOURCE "")
if(WIN32)
    set(APP_ICON_RESOURCE "${CMAKE_CURRENT_SOURCE_DIR}/appicon.rc")
endif()

qt_add_executable(appTriangulEye
    main.cpp
    clipboardhelper.h
    ${APP_ICON_RESOURCE}
)

qt_add_qml_module(appTriangulEye
    URI TriangulEye
    SOURCES
        controller.h
        controller.cpp
    QML_FILES
        Main.qml
    RESOURCES
        app_icon.ico
        assets/clipboard-solid-full.svg
        assets/lightning.svg
        assets/refresh.svg
        assets/search.svg
        assets/hint.svg
        assets/images/ender_eye.png
        assets/images/nether.png
        assets/images/overworld.png
)

set_target_properties(appTriangulEye PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTriangulEye
    PRIVATE Qt6::Quick Qt6::Svg
)

install(TARGETS appTriangulEye
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
