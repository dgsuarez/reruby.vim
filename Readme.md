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

Install plugin using your preferred method (pathogen et al)

It also requires `reruby` in `$PATH`.


