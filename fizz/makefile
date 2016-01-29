.SUFFIXES: .erl .beam .yrl

.erl.beam:
	erlc -W $<

.yrl.erl:
	erlc -W $<

ERL = erl -boot start_clean

#MODS = hello  ´ý±àÒëµÄÎÄ¼þ
MODS = fizz

all: compile
#	${ERL} -pa 'E:\erlangProject\hello' -s hello start
	${ERL}  -s fizz start -s init stop

compile : ${MODS:%=%.beam} 

clean:
	rm -rf *.beam erl_crash.dump
