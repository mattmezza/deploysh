APP=$1
NOTIFICATION_RECIPIENTS=$2 # you can concatenate email addresses with a comma ,
BRANCH=$3

notify_failure () {
    echo "There is a general error in the deploy process. Please check the deploy log.\nBRANCH is $BRANCH" | mail -s "[$APP] general deploy failure while deploying branch $BRANCH." $NOTIFICATION_RECIPIENTS
}

deploy () {
    git fetch --all && git reset --hard origin/$BRANCH && composer install
}

echo "Starting deploy of app $APP at branch $BRANCH" && deploy && echo "Deployment of branch $BRANCH finished." || notify_failure
