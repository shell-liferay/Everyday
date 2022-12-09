everyday(){
	portalup=$(sudo netstat -tulpn | grep :8000)
	sudo dnf -y update
	if [[ ${portalup} == "" ]]; then 
		cd ~/dev/projects/liferay-portal
    haschanges=0 && [[ $(git status --porcelain | wc -l) -gt 0 ]] && haschanges=1
    isinmaster=0 && [[ $(git rev-parse --abbrev-ref HEAD) == "master" ]] && isinmaster=1

    [[ haschanges -eq 1 ]] && git stash
    [[ isinmaster -eq 0 ]] && git checkout master
    git pull upstream master
    git push origin master
    [[ isinmaster -eq 0 ]] && git checkout - && git rebase master
    [[ haschanges -eq 1 ]] && git stash pop
    portaltrash
    ant all
		cd -
	else 
		echo "ERRO: Talvez o liferay-portal esteja rodando na sua maquina"; 
	fi
}

portaltrash() {
  rm -R .git/gc.log
	rm -R .git/gitk.cache
	git clean -xdf -e '**/*.iml' -e '.gradle/gradle.properties' -e '.idea' -e '.m2' -e "app.server.$USER.properties" -e "build.$USER.properties"
}