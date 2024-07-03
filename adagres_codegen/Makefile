POSTGRES_BINDIR := $(shell pg_config --bindir)
POSTGRES_INCLUDEDIR := $(shell pg_config --includedir-server)

all: generated/adagres-codegen.ads generated/adagres-constants.ads

generated/adagres-codegen.ads generated/adagres-constants.ads: $(wildcard src/*.ads src/*.adb src/*.c) ../adagres/sig/adagres-ffi.ads
	POSTGRES_BINDIR=${POSTGRES_BINDIR} POSTGRES_INCLUDEDIR=${POSTGRES_INCLUDEDIR} alr run

pp:
	POSTGRES_BINDIR=${POSTGRES_BINDIR} POSTGRES_INCLUDEDIR=${POSTGRES_INCLUDEDIR} alr exec  -- gnatpp -P adagres_codegen --no-subprojects -M100