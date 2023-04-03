# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls

include(FeatureSummary)
set_package_properties(Systemd PROPERTIES
   URL "http://freedesktop.org/wiki/Software/systemd/"
   DESCRIPTION "System and Service Manager")

#find_package(PkgConfig QUIET)
#if (PKG_CONFIG_FOUND)
#  pkg_search_module( PC_SYSTEMD QUIET libsystemd )
#endif()

message(STATUS "PC_SYSTEMD_INCLUDE_DIRS ${PC_SYSTEMD_INCLUDE_DIRS}")
message(STATUS "PC_SYSTEMD_LIBRARY_DIRS ${PC_SYSTEMD_LIBRARY_DIRS}")

# Find the include directories
find_path(SYSTEMD_INCLUDE_DIRS
  NAMES systemd/sd-login.h
  HINTS
    ${PC_SYSTEMD_INCLUDE_DIRS}
  DOC "Path containing the sd-login.h include file"
)


find_library(SYSTEMD_LIBRARIES
    NAMES systemd
    HINTS ${PC_SYSTEMD_LIBRARY_DIRS}
          /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
          /opt/nano/sysroot/lib/arm-linux-gnueabihf
          PATHS
          /opt/nano/sysroot/lib/arm-linux-gnueabihf
    DOC "systemd library path"
)


message(STATUS "SYSTEMD_INCLUDE_DIRS ${SYSTEMD_INCLUDE_DIRS}")
message(STATUS "SYSTEMD_LIBRARIES ${SYSTEMD_LIBRARIES}")

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Systemd
  REQUIRED_VARS DBUS_INCLUDE_DIRS SYSTEMD_INCLUDE_DIRS SYSTEMD_LIBRARIES
  VERSION_VAR PC_POPT_VERSION)

mark_as_advanced(SYSTEMD_INCLUDE_DIRS SYSTEMD_LIBRARIES)

if(SYSTEMD_FOUND AND NOT TARGET systemd)
  add_library(systemd UNKNOWN IMPORTED)
  set_target_properties(systemd PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES "C"
    IMPORTED_LOCATION "${SYSTEMD_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${SYSTEMD_INCLUDE_DIRS}"
  )
endif()
