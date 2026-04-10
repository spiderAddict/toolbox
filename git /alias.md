``` bash
git config --global alias.co checkout
git config --global alias.br 'branch -lvv'
git config --global alias.st status
git config --global alias.lol 'log --graph --decorate --oneline'
git config --global alias.pfwl 'push --force-with-lease origin'
git config --global alias.cane 'commit --amend --no-edit'
git config --global alias.rs1 'reset --soft HEAD~1'
```

---

### Pousser une branche qui n'existe pas encore dans le repo distant
La branche sera créé dans le repo distant avec le nom de la branche locale
``` bash
git config --global alias.pushd '!f() { _BRANCH $(git symbolic-ref --short head); git push --set-upstream origin $_BRANCH;}; f'
git config --global alias.pushd 'push --set-upstream origin HEAD'
```
exemple : `git pushd`

---

### Rebase interactif de X commits
``` bash
git config --global alias.rbi '!f() { n=${1:-1}; git rebase -i HEAD~$n; }; f'*
```
exemple : `git rbi 3`

---

### Mettre à jour une branche sans en changer
``` bash
git config --global alias.upbr '!f() { [ -z \"$1\" ] && { echo 'usage: git upbr <branch>'; return 1; }; git fetch origin \"$1:$1\";; }; f'

```
exemple : `git upbr develop`

  
