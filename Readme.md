# Reruby.vim

Ruby refactoring using [Reruby](https://github.com/dgsuarez/reruby) inside vim

# Usage

Exposes a single command, `:Reruby`, so for example

```
:Reruby rename_const NewName
```

Will rename the class/module the cursor is in to `NewName`. It's the same for
other Reruby refactorings.

# Installation

Install plugin using your preferred method (pathogen et al). Minimum vim
required is vim 8.

It also requires `reruby` in `$PATH`.


