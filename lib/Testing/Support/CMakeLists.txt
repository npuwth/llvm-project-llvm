add_llvm_library(LLVMTestingSupport
  Annotations.cpp
  Error.cpp
  SupportHelpers.cpp

  BUILDTREE_ONLY

  ADDITIONAL_HEADER_DIRS
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Testing/Support

  LINK_COMPONENTS
  Support
  )

target_link_libraries(LLVMTestingSupport PRIVATE llvm_gtest)

# This is to avoid the error in gtest-death-test-internal.h
# (150,16): error: 'Create' overrides a member function but
# is not marked 'override' [-Werror,-Wsuggest-override]
# during self-compile on Windows.

if (HOST_WINNT AND "${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" )
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-suggest-override")
endif()
