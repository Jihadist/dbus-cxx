function(dbus_generate)
  include(CMakeParseArguments)

  set(_singleargs XMLFILE XML_OUT_DIR)

  cmake_parse_arguments(dbus_generate "${_options}" "${_singleargs}" "${_multiargs}" "${ARGN}")

  if(NOT dbus_generate_XMLFILE)
    message(SEND_ERROR "Error: dbus_generate called without any targets or source files")
    return()
  endif()

  if(NOT dbus_generate_XML_OUT_DIR)
    set(dbus_generate_XML_OUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
  endif()

  get_filename_component(_abs_file ${dbus_generate_XMLFILE} ABSOLUTE)
  get_filename_component(_abs_dir ${_abs_file} DIRECTORY)

  message(STATUS "_abs_file ${_abs_file}")
  message(STATUS "_abs_dir ${_abs_dir}")

  get_filename_component(_file_full_name ${dbus_generate_XMLFILE} NAME)
  string(FIND "${_file_full_name}" "." _file_last_ext_pos REVERSE)
  string(SUBSTRING "${_file_full_name}" 0 ${_file_last_ext_pos} _basename)

  message(STATUS "_file_full_name ${_file_full_name}")
  message(STATUS "_basename ${_basename}")

  set(_comment "Running xml2cpp compiler on ${_file_full_name}")

  list(APPEND _generated_hdrs "${dbus_generate_XML_OUT_DIR}/${_basename}-proxy.h")
  list(APPEND _generated_hdrs "${dbus_generate_XML_OUT_DIR}/${_basename}-adaptor.h")

  message(STATUS "_generated_hdrs ${_generated_hdrs}")
  add_custom_command(
      OUTPUT ${_generated_hdrs}
      COMMAND dbus-c++::xml2cpp
      ARGS ${_abs_file} --proxy=${dbus_generate_XML_OUT_DIR}/${_basename}-proxy.h --adaptor=${dbus_generate_XML_OUT_DIR}/${_basename}-adaptor.h
      COMMENT ${_comment}
      VERBATIM )

  add_custom_target(_generate_headers${_basename} DEPENDS ${_generated_hdrs})

  set_source_files_properties(${_generated_hdrs} PROPERTIES GENERATED TRUE)

  string(REPLACE "." "_" _libname ${_basename})
  add_library(${_basename}  INTERFACE)
  add_dependencies(${_basename} _generate_headers${_basename})
  add_library(dbus-c++::${_basename} ALIAS ${_basename})

  target_include_directories(${_basename} INTERFACE ${dbus_generate_XML_OUT_DIR})

endfunction() 
