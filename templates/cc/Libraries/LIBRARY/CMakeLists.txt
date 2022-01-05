#----------------------------------------------------------------------------
# Setup the project
#----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# project NAME
set(project_name SH_LIBRARY)
project(${project_name})

add_library(${project_name} ${LIB_TYPE} ${PROJECT_SOURCE_DIR}/src/${project_name}.cc ${PROJECT_SOURCE_DIR}/include/${project_name}.hh)
target_include_directories(${project_name} PUBLIC
  ${PROJECT_SOURCE_DIR}/include
)
target_link_libraries(${project_name} PRIVATE
)
# LinkROOT(PRIVATE)
