# Check to see if we want to use the bundled libcppgenerate or not
if( TOOLS_BUNDLED_CPPGENERATE )
    add_subdirectory( libcppgenerate )
else()
    pkg_check_modules( cppgenerate REQUIRED cppgenerate-static )
endif( TOOLS_BUNDLED_CPPGENERATE )

if( TOOLS_BUNDLED_POPT )
    include(FetchContent)
    FetchContent_Declare(
      libpopt
      GIT_REPOSITORY https://github.com/rpm-software-management/popt.git
      GIT_TAG        61d84fdc2f0c6f30b81594a102427f5d44d54af2 # cmake
    )

    FetchContent_MakeAvailable(libpopt)
else()
    find_package(POPT REQUIRED)
endif( TOOLS_BUNDLED_POPT )

find_package(EXPAT REQUIRED)

add_executable( dbus-cxx-xml2cpp 
    generate_adapter.cpp
    generate_proxy.cpp
    parsed_object.cpp
    xml2cpp.cpp
    xml_parser.cpp
    arg.cpp
    method.cpp
    signal.cpp 
    code-generator.cpp 
)
target_link_libraries( dbus-cxx-xml2cpp dbus-cxx cppgenerate_static popt EXPAT::EXPAT rt )
install( TARGETS dbus-cxx-xml2cpp DESTINATION bin )

install( TARGETS dbus-cxx-xml2cpp
    COMPONENT dbus-cxx
    EXPORT dbus-cxxTargets
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}" )

add_executable( dbus-cxx-introspect
    introspect.cpp )
target_link_libraries( dbus-cxx-introspect dbus-cxx popt rt )

install( TARGETS dbus-cxx-introspect
    COMPONENT dbus-cxx
    EXPORT dbus-cxxTargets
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}" )

INSTALL( FILES "${CMAKE_CURRENT_SOURCE_DIR}/../cmake-modules/DBusGenerate.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/dbus-cxx"
    COMPONENT dbus-cxx)
