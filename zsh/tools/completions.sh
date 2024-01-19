_cd_repo() { _files -W ~/git; }
compdef _cd_repo cd_repo

_docker_exec_bash() { _docker ps; }
compdef _docker_exec_bash docker_exec_bash
