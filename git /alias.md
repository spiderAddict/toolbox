``` bash
git config --global alias.co checkout
git config --global alias.br 'branch -lvv'
git config --global alias.st status
git config --global alias.lol 'log --graph --decorate --oneline'
git config --global alias.pfwl 'push --force-with-lease origin'
git config --global alias.cane 'commit --amend --no-edit'
```

---

### Pousser une branche qui n'existe pas encore dans le repo distant
La branche sera créé dans le repo distant avec le nom de la branche locale
``` bash
git config --global alias.pushd '!f() { _BRANCH $(git symbolic-ref --short head); git push --set-upstream origin $_BRANCH;}; f'
```
exemple : `git pushd`

---

### Rebase interactif de X commits
``` bash
git config --global alias.rbi '!f() { git rebase -i HEAD~$1; }; f'*
```
exemple : `git rbi 3`

---

### Mettre à jour une branche sans en changer
``` bash
git config --global alias.upbr '!f() { git fetch origin $1:$1; }; f'
```
exemple : `git upbr develop`
  
