test :
	tsc -f spec/*_spec.lua

benchmark :
	tsc spec/*_benchmark.lua

all : test
