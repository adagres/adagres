POSTGRES_BINDIR := $(shell pg_config --bindir)
POSTGRES_INCLUDEDIR := $(shell pg_config --includedir-server)

all:
	make -C ../../adagres all
	POSTGRES_INCLUDEDIR=${POSTGRES_INCLUDEDIR} POSTGRES_BINDIR=${POSTGRES_BINDIR} alr build

pp:
	POSTGRES_INCLUDEDIR=${POSTGRES_INCLUDEDIR} POSTGRES_BINDIR=${POSTGRES_BINDIR} POSTGRES_BINDIR=(pg_config --bindir) alr exec  -- gnatpp -P sum --no-subprojects -M100