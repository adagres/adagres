all:
	make -C adagres

pp:
	make -C adagres pp
	make -C adagres_codegen pp
	make -C examples/sum pp
