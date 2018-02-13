# Reruby.vim

Ruby refactoring using [Reruby](https://github.com/dgsuarez/reruby) inside Vim

# Usage

Exposes a single command, `:Reruby`, so for example

```
:Reruby rename_const NewName
```

Will rename the class/module under the cursor to `NewName`

You can also pass in a text range:

```
:'<'>Reruby extract_method my_special_method
```

Will extract `my_special_method` with that code.

# Installation

Install plugin using your preferred method (pathogen et al). Minimum Vim
required is Vim 8.

It also requires `reruby` in `$PATH`.


