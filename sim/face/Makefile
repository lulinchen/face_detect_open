
ver:
	verdi -sv  simDefines.v +incdir+../../src+ +incdir+../../model+ -top tb -syntaxerrormax 1000   -f face_tb.f -ssf ./ecb.fsdb #-sswr verdi.rc   #-
ku:
	verdi -sv  simDefines.v +incdir+../../src+ +incdir+../../model+ -top tb -syntaxerrormax 1000   -f face_tb.f.xilinx.ku.bhvsram -ssf ./ecb.fsdb #-sswr verdi.rc   #-
gold:
	verdi -sv  simDefines.v +incdir+../../src+ +incdir+../../model+ -top tb -syntaxerrormax 1000   -f face_tb.f -ssf ./ecb_gold.fsdb #-sswr verdi.rc   #-
run:
	./simv -l run.log
	grep "error" -c run_o.log
runv:
	./simv -l run.log
clean:
	rm -rf ./csrc
	rm -rf ./simv
	rm -rf ./simv.*
	rm -rf ./vcs*
	rm -rf ./.vcs*
	rm -rf ./*.h
	rm -rf ./core*
	rm -rf ./*.vpd
	rm -rf ./save.*
	rm -rf ./*.fsdb
