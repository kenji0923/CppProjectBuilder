#----------------------------------------------------------------------------
# Setup the project
#----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

cmake_policy(SET CMP0054 NEW)

set(project_name SH_PROJECT)
project(${project_name})

set (CMAKE_CXX_STANDARD 11)

set (LIB_TYPE STATIC)
# set (LIB_TYPE SHARED)

# Set a default build type if none was specified
set(default_build_type "Release")
   
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
    STRING "Choose the type of build." FORCE)
    # Set the possible values of build type for cmake-gui
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

#----------------------------------------------------------------------------
# include modules in /cmakemodules
#----------------------------------------------------------------------------
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules")

#----------------------------------------------------------------------------
# Load other packages
#----------------------------------------------------------------------------
# # OpenMP
# find_package(OpenMP)

# ROOT
if (WIN32)
  if (NOT EXISTS $ENV{ROOTSYS})
    message(STATUS "ROOTSYS or direcotry pointed by ROOTSYS was not found. Please specify a correct environmental variable ROOTSYS.")
  endif()
  if (CMAKE_BUILD_TYPE MATCHES Debug)
    set (MULTI_DIR "Debug")
  else()
    set (MULTI_DIR "Release")
  endif()
  if (NOT EXISTS $ENV{ROOTSYS}/${MULTI_DIR})
    message(STATUS "ROOT with muilt builds is not found. Build in ROOTSYS will be used.")
    set (MULTI_DIR "")
  endif()
  find_package(ROOT PATHS $ENV{ROOTSYS}/${MULTI_DIR} NO_DEFAULT_PATH REQUIRED Core RIO Net Hist Graf Graf3d Gpad Tree Rint Postscript Matrix Physics MathCore Thread)
  message(STATUS "ROOT in ${ROOT_LIBRARY_DIR} will be used")
else()
  find_package(ROOT REQUIRED Core RIO Net Hist Graf Graf3d Gpad Tree Rint Postscript Matrix Physics MathCore MathMore Thread)
endif()
function(LinkROOT)
  target_include_directories(${project_name} PUBLIC ${ROOT_INCLUDE_DIRS})
  target_link_libraries(${project_name} PRIVATE ${ROOT_LIBRARIES})
endfunction(LinkROOT)

# # GSL
# if (WIN32)
#   find_package(GSLWIN32)
# else()
#   find_package(GSL)
# endif()
# function(LinkGSL)
#   target_include_directories(${project_name} PUBLIC ${GSL_INCLUDE_DIRS})
#   target_link_libraries(${project_name} PRIVATE ${GSL_LIBRARIES})
# endfunction(LinkGSL)

# Doxygen
find_package(Doxygen)
if (DOXYGEN_FOUND)
endif()

#----------------------------------------------------------------------------
# Disbale annoying warning
#----------------------------------------------------------------------------
add_definitions(-D_CRT_SECURE_NO_WARNINGS)
if (WIN32) 
  # Same with the build of ROOT
  string(REPLACE "/MDd" "/MD" CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
endif()


#----------------------------------------------------------------------------
# Setup global include directory for this project and add to build libraries
#----------------------------------------------------------------------------
# include_directories(${PROJECT_SOURCE_DIR}/include)
add_library(globals ${LIB_TYPE} ${PROJECT_SOURCE_DIR}/include/globals.cc ${PROJECT_SOURCE_DIR}/include/globals.hh)
target_link_libraries(globals PRIVATE ${ROOT_LIBRARIES})
target_include_directories(globals PRIVATE ${ROOT_INCLUDE_DIRS})
target_include_directories(globals PUBLIC
  ${PROJECT_SOURCE_DIR}/include
)

#----------------------------------------------------------------------------
# Libraries to be linked
#----------------------------------------------------------------------------
set(external_projs ${external_projs}
  # json11
)
foreach(proj_name IN LISTS external_projs)
  set(LIBRARY_DIRECTORIES ${LIBRARY_DIRECTORIES} ${PROJECT_SOURCE_DIR}/Libraries/${proj_name})
endforeach()


#----------------------------------------------------------------------------
# add subdirecry 
#----------------------------------------------------------------------------
add_subdirectory(${PROJECT_SOURCE_DIR}/Programs)
foreach(LIBDIR IN LISTS LIBRARY_DIRECTORIES)
  add_subdirectory(${LIBDIR})
endforeach()

#----------------------------------------------------------------------------
# add Doxygen documentation
#----------------------------------------------------------------------------
add_subdirectory(${PROJECT_SOURCE_DIR}/Document)
