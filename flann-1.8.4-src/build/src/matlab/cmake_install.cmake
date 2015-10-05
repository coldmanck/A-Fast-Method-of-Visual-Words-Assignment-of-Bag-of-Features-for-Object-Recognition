# Install script for directory: C:/Users/denjo/Downloads/flann-1.8.4-src/src/matlab

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/flann/matlab" TYPE FILE FILES
    "C:/Users/denjo/Downloads/flann-1.8.4-src/build/src/matlab/nearest_neighbors.mexw64"
    "C:/Users/denjo/Downloads/flann-1.8.4-src/src/matlab/flann_build_index.m"
    "C:/Users/denjo/Downloads/flann-1.8.4-src/src/matlab/flann_free_index.m"
    "C:/Users/denjo/Downloads/flann-1.8.4-src/src/matlab/flann_load_index.m"
    "C:/Users/denjo/Downloads/flann-1.8.4-src/src/matlab/flann_save_index.m"
    "C:/Users/denjo/Downloads/flann-1.8.4-src/src/matlab/flann_search.m"
    "C:/Users/denjo/Downloads/flann-1.8.4-src/src/matlab/flann_set_distance_type.m"
    "C:/Users/denjo/Downloads/flann-1.8.4-src/src/matlab/test_flann.m"
    )
endif()

