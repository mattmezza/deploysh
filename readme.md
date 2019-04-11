deploysh
=====

### crontab

- `crontab -e`
- `*/5 * * * * cd /home/gitrepo && /usr/deploysh/branch.sh "my app" "email@gmail.com,other@guy.people" master


    _or_


- `*/5 * * * * cd /home/gitrepo && /usr/deploysh/tag.sh "my app" "email@gmail.com,other@guy.people"`
