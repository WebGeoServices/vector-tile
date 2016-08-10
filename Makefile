CC := $(CC)
CXX := $(CXX)
CXXFLAGS := $(CXXFLAGS) -Iinclude/mapbox/vector_tile -std=c++11
RELEASE_FLAGS := -O3 -DNDEBUG
WARNING_FLAGS := -Wall -Wextra -pedantic -Werror -Wsign-compare -Wfloat-equal -Wfloat-conversion -Wshadow -Wno-unsequenced
DEBUG_FLAGS := -g -O0 -DDEBUG -fno-inline-functions -fno-omit-frame-pointer

export BUILDTYPE ?= Release

ifeq ($(BUILDTYPE),Release)
	FINAL_FLAGS := -g $(WARNING_FLAGS) $(RELEASE_FLAGS)
else
	FINAL_FLAGS := -g $(WARNING_FLAGS) $(DEBUG_FLAGS)
endif

default: test-$(BUILDTYPE)

test-$(BUILDTYPE): tests/unit/* include/mapbox/vector_tile/* Makefile
	$(CXX) $(FINAL_FLAGS) tests/unit/*.cpp -Itests/include $(CXXFLAGS) -o test-$(BUILDTYPE)
	./test-$(BUILDTYPE)

test: test-$(BUILDTYPE)

SOURCES = $(include/mapbox/vector_tile.hpp)
HEADERS = $(wildcard include/mapbox/vector_tile/*.hpp)
COMMON_DOC_FLAGS = --report --output docs $(HEADERS)

clean:
	rm -f test-Release
	rm -f test-Debug

cldoc:
	pip install cldoc --user

docs: cldoc
	cldoc generate $(CXXFLAGS) -- $(COMMON_DOC_FLAGS)