function! health#config#check() abort
	call health#report_start("Custom config checks")

	" My config depends on a few programs being installed,
	" So here I check that they can be found in $PATH
	"
	" Install commands:
	" npm install --global markdownlint-cli prettier eslint stylelint
	" pip install black
	" dnf install git ripgrep fzf fd-find python-devel nodejs clang ninja-build cmake
	" rustup toolchain add stable
	" rustup toolchain add nightly
	" rustup component add --toolchain stable rust-src rust-analysis
	" rustup component add --toolchain nightly rust-src rust-analysis rust-analyzer-preview
	let execs = ["git", "rg", "fzf", "fd", "cargo", "rustfmt", "rustc", "rust-analyzer", "go", "goimports", "python", "black", "node", "prettier", "eslint", "markdownlint", "stylelint", "clang-format", "clang-tidy", "clangd", "clang", "gcc", "make", "ninja", "cmake"]
	for exec in execs
		if executable(exec)
			call health#report_ok(exec . " found")
		else
			call health#report_error(exec . " not found", "Check your $PATH or install it you dummy")
		endif
	endfor
endfunction
