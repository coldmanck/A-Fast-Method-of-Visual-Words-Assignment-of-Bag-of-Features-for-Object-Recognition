# Install script for directory: C:/Users/denjo/Downloads/flann-1.8.4-src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/flann")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE PROGRAM FILES
    "C:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/redist/x86/Microsoft.VC110.CRT/msvcp110.dll"
    "C:/Program Files (x86)/Microsoft Visual Studio 11.0/VC/redist/x86/Microsoft.VC110.CRT/msvcr110.dll"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("C:/Users/denjo/Downloads/flann-1.8.4-src/build/cmake/cmake_install.cmake")
  include("C:/Users/denjo/Downloads/flann-1.8.4-src/build/src/cmake_install.cmake")
  include("C:/Users/denjo/Downloads/flann-1.8.4-src/build/examples/cmake_install.cmake")
  include("C:/Users/denjo/Downloads/flann-1.8.4-src/build/test/cmake_install.cmake")
  include("C:/Users/denjo/Downloads/flann-1.8.4-src/build/doc/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

file(WRITE "C:/Users/denjo/Downloads/flann-1.8.4-src/build/${CMAKE_INSTALL_MANIFEST}" "")
foreach(file ${CMAKE_INSTALL_MANIFEST_FILES})
  file(APPEND "C:/Users/denjo/Downloads/flann-1.8.4-src/build/${CMAKE_INSTALL_MANIFEST}" "${file}\n")
endforeach()
