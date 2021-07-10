function! health#config#check() abort
	call health#report_start("Custom config checks")

	" My config depends on a few programs being installed,
	" So here I check that they can be found in $PATH
	let execs = ["rg", "fzf", "fd", "git", "rustc", "go", "node", "clang-format", "clang-tidy", "clangd", "clang"]
	for exec in execs
		if executable(exec)
			call health#report_ok(exec . " found")
		else
			call health#report_error(exec . " not found", "Check your $PATH or install it you dummy")
		endif
	endfor
endfunction
