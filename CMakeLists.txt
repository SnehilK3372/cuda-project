option(ENABLE_AUDIO "Enable Aquila/STK audio support" OFF)

if(ENABLE_AUDIO)
  # Assume Aquila is installed system-wide or at AQUILA_ROOT
  find_path(AQUILA_INCLUDE_DIR aquila/Aquila.h)
  if(AQUILA_INCLUDE_DIR)
    message(STATUS "Found Aquila include: ${AQUILA_INCLUDE_DIR}")
    include_directories(${AQUILA_INCLUDE_DIR})
    add_definitions(-DHAS_AQUILA)
  else()
    message(WARNING "Aquila not found. Install Aquila or set AQUILA_ROOT.")
  endif()

  # STK: you can link against stk library if installed
  find_library(STK_LIB stk)
  if(STK_LIB)
    message(STATUS "Found STK: ${STK_LIB}")
    target_link_libraries(batch_image_pipeline PRIVATE ${STK_LIB})
    add_definitions(-DHAS_STK)
  else()
    message(WARNING "STK not found.")
  endif()
endif()
