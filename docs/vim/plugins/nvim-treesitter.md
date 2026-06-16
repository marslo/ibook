<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [customize ts](#customize-ts)
- [vim/nvim functions](#vimnvim-functions)
  - [`:TSInstallAll`](#tsinstallall)
  - [`:TSUpdateGroovy`](#tsupdategroovy)
  - [`:TSUpdateAll`](#tsupdateall)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## customize ts

```bash
# -- clone code --
$ git clone https://github.com/marslo/tree-sitter-groovy.git    && cd tree-sitter-groovy
# or original repo:
$ git clone https://github.com/murtaza64/tree-sitter-groovy.git && cd tree-sitter-groovy

# change grammar.js
$ vim grammar.js

# -- build ts --
$ tree-sitter generate
# for nvim-treesitter
$ tree-sitter build -o groovy.so && codesign --force --sign - groovy.so
$ command cp -f groovy.so ~/.local/share/nvim/site/parser/groovy.so
# for tree-sitter-cli
$ tree-sitter build -o ~/.cache/tree-sitter/lib/groovy.dylib && codesign --force --sign - ~/.cache/tree-sitter/lib/groovy.dylib
```

<!--sec data-title="diff for grammar.js" data-id="section0" data-show=true data-collapse=true ces-->
```diff
$ git diff --no-ext-diff  d7254b76^..HEAD -- grammar.js
diff --git a/grammar.js b/grammar.js
index df3fe83b..8e66e00d 100644
--- a/grammar.js
+++ b/grammar.js
@@ -61,6 +61,7 @@ module.exports = grammar({
         $.groovy_import,
         $.groovy_package,
         $.assignment,
+        $.multiple_assignment,
         $.class_definition,
         $.declaration,
         $.do_while_loop,
@@ -265,10 +266,13 @@ module.exports = grammar({
             $.groovy_doc_throws,
             $.groovy_doc_tag,
             $.groovy_doc_at_text,
-            /([^@*]|\*[^/])([^*\s@]|[^\s\n]@|\*[^/])+/,
+            // banner / divider lines made of a run of asterisks, e.g. `********`.
+            // a run of `*` is only valid as content when it is not the `*/` or `**/` terminator.
+            /\*+[^*/]/,
+            /([^@*]|\*[^*/])([^*\s@]|[^\s\n]@|\*[^*/])+/,
           ),
         ),
-        '*/'
+        choice('*/', '**/'),
       ),

     groovy_doc_param: $ => seq (
@@ -316,6 +320,30 @@ module.exports = grammar({
       ),
     ),

+    // groovy multiple (tuple) assignment:
+    //   def (a, b) = list
+    //   def (List diffs, Boolean isAncestor) = foo ? bar() : [[], false]
+    //   (a, b) = [1, 2]
+    multiple_assignment: $ => prec(2, seq(
+      choice(
+        seq('def', '(', list_of($.multiple_assignment_variable), ')'),
+        seq(
+          '(',
+          $.multiple_assignment_variable,
+          repeat1(seq(',', $.multiple_assignment_variable)),
+          optional(','),
+          ')',
+        ),
+      ),
+      '=',
+      field('value', $._expression),
+    )),
+
+    multiple_assignment_variable: $ => seq(
+      optional(choice(field('type', $._type), 'def')),
+      field('name', $.identifier),
+    ),
+
     parenthesized_expression: ($) =>
       prec(PREC.PRIORITY, choice(
         seq("(",
@@ -341,6 +369,7 @@ module.exports = grammar({
       $.list,
       $.map,
       $._callable_expression,
+      alias($._closure_call, $.juxt_function_call),
     )),

     _callable_expression: $ => choice(
@@ -351,6 +380,15 @@ module.exports = grammar({
       $._type_identifier,
     ),

+    // method call whose argument is a trailing closure with no parens,
+    // e.g. `list.collect { it.branch }`. Modeled as a primary expression so it
+    // works as an argument (`foo( list.collect { it } )`) and chains
+    // (`list.collect { it }.join('\n')`).
+    _closure_call: $ => prec.left(2, seq(
+      field('function', $._juxtable_expression),
+      field('args', alias(repeat1($.closure), $.argument_list)),
+    )),
+
     _juxtable_expression: $ => choice(
       $.dotted_identifier,
       $.identifier,
```
<!--endsec-->

## vim/nvim functions

### `:TSInstallAll`
```lua
-- ~/.config/nvim/lua/config/nvim-treesitter.lua
local ensure_installed = {
  'bash', 'c', 'cmake', 'css', 'csv', 'diff', 'dockerfile',
  'git_config', 'git_rebase', 'gitcommit', 'gitignore', 'groovy',
  'html', 'ini', 'java', 'jq', 'json', 'lua', 'markdown', 'python',
  'query', 'ssh_config', 'vim', 'vimdoc', 'xml', 'yaml'
}

-- for :TSInstallAll command
local function install_all_parsers()
  vim.schedule(function()
    local to_install = {}

    for _, lang in ipairs(ensure_installed) do
      local ok = pcall( vim.treesitter.language.inspect, lang )
      if not ok then
        table.insert( to_install, lang )
      end
    end

    if #to_install > 0 then
      vim.notify( "Installing TS parsers in background: " .. table.concat(to_install, ", ") )
      vim.cmd( "silent! TSInstall " .. table.concat(to_install, " ") )
      vim.cmd( "redraw!" )
      vim.notify( "Installation started! Use :messages to check progress.", vim.log.levels.INFO )
    else
      vim.notify( "All TS parsers are already installed." )
    end
  end)
end
-- register the command :TSInstallAll
vim.api.nvim_create_user_command( 'TSInstallAll', install_all_parsers, {} )
```

### `:TSUpdateGroovy`
```vim
" ~/.vimrc
" :TSUpdateGroovy → rebuild + re-sign the local groovy tree-sitter parser
function! TSUpdateGroovy() abort
  let l:repo = get(g:, 'groovy_ts_repo', '/opt/groovy/tree-sitter-groovy')
  if !isdirectory(l:repo)
    echohl ErrorMsg | echo 'groovy-ts: repo not found: ' . l:repo | echohl NONE
    return
  endif
  echo 'groovy-ts: building (make nvim-install) ...'
  let l:out = system('make -C ' . shellescape(l:repo) . ' nvim-install 2>&1')
  if v:shell_error != 0
    echohl ErrorMsg | echo "groovy-ts: build failed\n" . l:out | echohl NONE
    return
  endif
  echohl MoreMsg | echo 'groovy-ts: rebuilt + signed (restart nvim for the new parser binary)' | echohl NONE
endfunction
command! TSUpdateGroovy call TSUpdateGroovy()
```

### `:TSUpdateAll`
```lua
-- ~/.config/nvim/lua/config/nvim-treesitter.lua
-- for :TSUpdateAll command
--   -> run a full async update, then (once it finishes) rebuild + re-sign the local groovy parser via :TSUpdateGroovy.
--      nvim-treesitter builds groovy linker-signed (would crash nvim on macOS), so TSUpdateGroovy must run last.
--      uses the install task's completion callback so the timing is reliable.
vim.api.nvim_create_user_command('TSUpdateAll', function()
  local ok, install = pcall(require, 'nvim-treesitter.install')
  if not ok then
    vim.notify('nvim-treesitter.install not available', vim.log.levels.ERROR)
    return
  end
  vim.notify('TSUpdate: updating parsers ...', vim.log.levels.INFO)
  local task = install.update(nil, { summary = true })
  task:await(function(err)
    vim.schedule(function()
      if err then
        vim.notify('TSUpdate failed: ' .. tostring(err), vim.log.levels.ERROR)
        return
      end
      if vim.fn.exists(':TSUpdateGroovy') == 2 then
        vim.cmd('TSUpdateGroovy')
      else
        vim.notify('TSUpdateGroovy command not found (is ~/.marslo/vimrc.d/functions sourced?)', vim.log.levels.WARN)
      end
    end)
  end)
end, { desc = 'Update all parsers, then rebuild + re-sign the local groovy parser' })
```
