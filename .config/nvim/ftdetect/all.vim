" All in one filetype detection for a bunch of stuff
augroup DetectFileTypes
    autocmd!

    autocmd BufRead,BufNewFile *config/git/config setfiletype gitconfig

    autocmd BufRead,BufNewFile *.graphqlrc setfiletype yaml

    autocmd BufRead,BufNewFile zprofile setfiletype zsh

    autocmd BufRead,BufNewFile .env* setfiletype sh

    autocmd BufRead,BufNewFile Dockerfile-* setfiletype dockerfile
    autocmd BufRead,BufNewFile Dockerfile.* setfiletype dockerfile

    autocmd BufRead,BufNewFile *.babelrc setfiletype json
    autocmd BufRead,BufNewFile .eslintrc setfiletype json
    autocmd BufRead,BufNewFile .prettierrc setfiletype json
    autocmd BufRead,BufNewFile .stylelintrc setfiletype json

    autocmd BufRead,BufNewFile *.png setfiletype image
    autocmd BufRead,BufNewFile *.jpg setfiletype image
    autocmd BufRead,BufNewFile *.jpeg setfiletype image
    autocmd BufRead,BufNewFile *.gif setfiletype image
augroup END
