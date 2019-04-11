APP=$1
NOTIFICATION_RECIPIENTS=$2 # you can concatenate email addresses with a comma ,
CURRENT_TAG=$(cat .current-tag)
echo "CURRENT_TAG tag is $CURRENT_TAG"
git fetch --all
LATEST_TAG=$(git tag | tail -n 1)
echo "LATEST_TAG is $LATEST_TAG"

notify_success () {
    echo "$APP v$LATEST_TAG has been successfully deployed.\n\nWas at $CURRENT_TAG, now at $LATEST_TAG" | mail -s "[$APP v$LATEST_TAG] deploy successfull" $NOTIFICATION_RECIPIENTS
}

notify_rollback () {
    echo "Replacing $CURRENT_TAG with $LATEST_TAG failed. Deployment rolled back to $CURRENT_TAG." | mail -s "[$APP v$LATEST_TAG] deploy failed, rolled back to v$CURRENT_TAG" $NOTIFICATION_RECIPIENTS
}

notify_failure () {
    echo "There is a general error in the deploy process. Please check the deploy log.\nCURRENT_TAG is $CURRENT_TAG\nLATEST_TAG is $LATEST_TAG" | mail -s "[$APP] general deploy failure while deploying $LATEST_TAG." $NOTIFICATION_RECIPIENTS
}

deploy () {
    git checkout $LATEST_TAG && composer install && echo $LATEST_TAG > .current-tag && notify_success
}

rollback () {
    git checkout $CURRENT_TAG && composer install && echo $CURRENT_TAG > .current-tag && notify_failure
}

if [[ "$CURRENT_TAG" != "$LATEST_TAG" ]]; then
    echo "Detected new tag for $APP, starting deploy of $LATEST_TAG..."
    deploy && echo "Deployment of version $LATEST_TAG finished." || rollback || notify_failure

else
    echo "App $APP is already at latest tag."
fi
