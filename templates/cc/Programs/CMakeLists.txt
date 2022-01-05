#----------------------------------------------------------------------------
# Setup the project
#----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

set(project_name Promgrams)
project(${project_name})

# Define custom helper function
function(AddExecutable)
  set(PROGRAM_SOURCE_FILE ${PROJECT_SOURCE_DIR}/${project_name}.cc)
  add_executable(${project_name} ${PROGRAM_SOURCE_FILE})
  if (DOXYGEN_FOUND)
    set(EXECUTABLE_FILES ${EXECUTABLE_FILES} ${PROGRAM_SOURCE_FILE} PARENT_SCOPE) 
  endif()
endfunction(AddExecutable)

#----------------------------------------------------------------------------
# Define executables
#----------------------------------------------------------------------------
set(project_name hello)
AddExecutable()
target_link_libraries(${project_name} PRIVATE
  globals
)
LinkROOT(PRIVATE)

set(EXECUTABLE_FILES ${EXECUTABLE_FILES} PARENT_SCOPE)
