IF(CMAKE_SYSTEM MATCHES "SunOS-4.*")
   SET(CMAKE_SHARED_LIBRARY_C_FLAGS "-PIC") 
   SET(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared -Wl,-r") 
   SET(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "-Wl,-R")
   SET(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP ":")  
ENDIF(CMAKE_SYSTEM MATCHES "SunOS-4.*")

IF(CMAKE_COMPILER_IS_GNUCXX)
  IF(CMAKE_COMPILER_IS_GNUCC)
    SET(CMAKE_CXX_CREATE_SHARED_LIBRARY
        "<CMAKE_C_COMPILER> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS>  <CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
  ELSE(CMAKE_COMPILER_IS_GNUCC)
    # Take default rule from CMakeDefaultMakeRuleVariables.cmake.
  ENDIF(CMAKE_COMPILER_IS_GNUCC)
ENDIF(CMAKE_COMPILER_IS_GNUCXX)
INCLUDE(Platform/UnixPaths)

# Add the compiler's implicit link directories.
IF("${CMAKE_C_COMPILER_ID} ${CMAKE_CXX_COMPILER_ID}" MATCHES SunPro)
  LIST(APPEND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
    /opt/SUNWspro/lib /opt/SUNWspro/prod/lib /usr/ccs/lib)
ENDIF("${CMAKE_C_COMPILER_ID} ${CMAKE_CXX_COMPILER_ID}" MATCHES SunPro)

# Initialize C link type selection flags.  These flags are used when
# building a shared library, shared module, or executable that links
# to other libraries to select whether to use the static or shared
# versions of the libraries.
IF(CMAKE_COMPILER_IS_GNUCC)
  FOREACH(type SHARED_LIBRARY SHARED_MODULE EXE)
    SET(CMAKE_${type}_LINK_STATIC_C_FLAGS "-Wl,-Bstatic")
    SET(CMAKE_${type}_LINK_DYNAMIC_C_FLAGS "-Wl,-Bdynamic")
  ENDFOREACH(type)
ENDIF(CMAKE_COMPILER_IS_GNUCC)
IF(CMAKE_COMPILER_IS_GNUCXX)
  FOREACH(type SHARED_LIBRARY SHARED_MODULE EXE)
    SET(CMAKE_${type}_LINK_STATIC_CXX_FLAGS "-Wl,-Bstatic")
    SET(CMAKE_${type}_LINK_DYNAMIC_CXX_FLAGS "-Wl,-Bdynamic")
  ENDFOREACH(type)
ENDIF(CMAKE_COMPILER_IS_GNUCXX)

# The Sun linker needs to find transitive shared library dependencies
# in the -L path.
SET(CMAKE_LINK_DEPENDENT_LIBRARY_DIRS 1)

# Shared libraries with no builtin soname may not be linked safely by
# specifying the file path.
SET(CMAKE_PLATFORM_USES_PATH_WHEN_NO_SONAME 1)
