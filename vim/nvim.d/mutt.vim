" E-mail template for neomutt
"
if system('uname -n') == "TSUEMATSU\n"
    function MuttTemplate(filePath)
        " Check if the argument is a string
        if type(a:filePath) != type("")
          echo "Error: The file path must be specified as a string"
          return
        endif

        " Check if the argument is empty
        if empty(a:filePath)
          echo "Error: No file path specified"
          return
        endif

        " Convert to absolute path
        let absPath = expand('~/mail/template/' . a:filePath)

        " Check if the file exists
        if !filereadable(absPath)
          echo "Error: The specified file does not exist"
          return
        endif

        execute "read" absPath
        0d_
    endfunction

    function MuttTemplateReply(filePath)
        " filePath のバリデーションチェック部分は共通部分なので関数化が必要
        " Check if the argument is a string
        if type(a:filePath) != type("")
          echo "Error: The file path must be specified as a string"
          return
        endif

        " Check if the argument is empty
        if empty(a:filePath)
          echo "Error: No file path specified"
          return
        endif

        " Convert to absolute path
        let absPath = expand('~/mail/template/' . a:filePath)

        " Check if the file exists
        if !filereadable(absPath)
          echo "Error: The specified file does not exist"
          return
        endif

        " [Fix] In-Reply-Toが2つある場合にテンプレートが2回挿入されてしまう
        g/In-Reply-To/execute 'normal! o' | execute 'normal! o' | execute "read" absPath
        0d_
    endfunction

    :command! OpeRequest call MuttTemplate('ope/request.txt')
    :command! OpeReport call MuttTemplateReply('ope/report.txt')
endif


