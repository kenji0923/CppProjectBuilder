if (ENV{GSLSYS} STREQUAL "")
  message(STATUS "Please set an environment variable GSLSYS to the directory where gsl is installed.")
  message(STATUS "GSL not found.")
  set(GSL_FOUND FALSE)
else()
  if (CMAKE_BUILD_TYPE MATCHES Debug)
    set (MULTI_DIR "Debug")
  else()
    set (MULTI_DIR "Release")
  endif()
  if (EXISTS $ENV{GSLSYS}/bin/${MULTI_DIR} AND EXISTS $ENV{GSLSYS}/lib/${MULTI_DIR})
  else()
    message(STATUS "GSL with muilt builds is not found. Build in GSLSYS will be used.")
    set (MULTI_DIR "")
  endif()
  set(GSL_INCLUDE_DIRS $ENV{GSLSYS}/include)
  set(GSL_LIBRARY_DIR $ENV{GSLSYS}/lib/${MULTI_DIR})
  set(GSL_LIBRARIES -LIBPATH:${GSL_LIBRARY_DIR} gsl.lib gslcblas.lib)
  message(STATUS "GSL was found in ${GSL_LIBRARY_DIR}")
  set(GSL_FOUND TRUE)
endif()
